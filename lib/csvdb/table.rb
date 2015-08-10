require 'csv'
require 'csvdb/row'
require 'csvdb/errors'

module Csvdb
  class Table
    attr_accessor :cols, :table

    def initialize(opts = {})

      if opts[:file]
        @file = opts[:file]
        table = CSV.read(@file)
        @cols = table[0].map.with_index {|head,idx| [head.to_sym,idx] }.to_h
      elsif opts[:ary]
        table = opts[:ary]
        @cols = opts[:cols]
      else
        raise ParseError, 'No table or file to parse.'
      end

      table = table - table[0] if table[0]
      @table = []
      table.each_with_index do |row, idx|
        @table[idx] = Row.new(row, self, idx)
      end

      @cols.each do |col, val|
        add_attr(col, val)
      end

    end

    def write(file = @file)
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

    def where
      Table.new(ary: @table.select { |row| yield(row) }, cols: self.cols)
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
      puts ' '
      print @cols.keys
      puts ' '
      @table.each do |row|
        print row
        puts ' '
      end
    end

    private
      def add_attr(name, value)
        self.class.send(:attr_accessor, name)
        instance_variable_set("@#{name}", value)
      end

  end
end
