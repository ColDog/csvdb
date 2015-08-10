require 'csv'
require 'csvdb/row'
require 'csvdb/errors'

module Csvdb

  class Join

  end

  class Table
    attr_accessor :cols, :table, :table_name

    def initialize(opts = {})
      @table_name = opts[:name]
      if opts[:file]
        @file = opts[:file]
        table = CSV.read(@file)
        @cols = table[0].map.with_index {|head,idx| [head.to_sym,idx] }.to_h
        table.delete_at(0)
      elsif opts[:ary]
        table = opts[:ary]
        @cols = opts[:cols]
      else
        raise ParseError, 'No table or file to parse.'
      end

      @cols.each do |col, val|
        add_attr(col, val)
      end

      @table = []
      table.each_with_index do |row, idx|
        @table[idx] = Row.new(row, self, idx)
      end

    end

    def write(file = @file)
      File.open(file, 'w') unless File.file?(file)
      CSV.open(file, 'wb') do |csv|
        csv << @cols.keys
        @table.each do |row|
          csv << row
        end
      end
    end

    def all
      @table
    end

    def count
      @table.count
    end

    def create(attrs)
      new_row = []
      attrs.each do |att, new_val|
        new_row[@cols[att]] = new_val
      end
      @table << Row.new(new_row, self, @table.length)
    end

    def add(attrs)
      @table << Row.new(attrs, self, @table.length)
    end

    def where
      Table.new(ary: @table.select { |row| yield(row) }, cols: self.cols)
    end

    # todo note that right now it currently requires that each
    # column name be unique within the table except that column
    # which is joined on.
    def join(table, column)
      col = self.send(column)
      cols = ([column] + (self.cols.keys - [column])
                .map { |k| "#{k}_#{self.table_name}".to_sym } +
                ((table.cols.keys - [column])
                .map { |k| "#{k}_#{table.table_name}".to_sym }))
                .map.with_index {|head,idx| [head.to_sym,idx] }.to_h

      joined = Table.new(ary: [], cols: cols)
      ids = (self.pluck(column) + table.pluck(column)).uniq
      ids.each do |id|
        self.where { |row| row[col] == id }.table.each do |outer_row|
          table.where { |row| row[col] == id }.table.each do |inner_row|
            inner_row.delete_at(col)
            joined.add(outer_row + inner_row)
          end
        end
      end
      return joined
    end

    def find(idx = nil)
      if block_given?
        @table.select { |row| yield(row) }.first
      elsif idx
        @table[idx]
      else
        raise ArgumentError, 'Must pass either an index or a block.'
      end
    end

    def pluck(header)
      col = @cols[header.to_sym] ; vals = []
      raise SearchError, "Column #{header} does not exist." unless col
      @table.each do |row|
        vals << row[col]
      end
      vals
    end

    def pretty
      table = Terminal::Table.new headings: @cols.keys, rows: @table
      puts table
    end

    private
      def add_attr(name, value)
        self.class.send(:attr_accessor, name)
        instance_variable_set("@#{name}", value)
      end

  end
end
