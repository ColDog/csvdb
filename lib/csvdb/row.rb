module Csvdb
  class Row < Array
    attr_accessor :row, :attrs, :table

    def initialize(attrs, table, row)
      @table = table
      @row = row
      if attrs.is_a? Hash
        cols = @table.cols ; ary = []
        attrs.each do |key, val|
          ary[cols[key]] = val
          add_attr(key, val) if @table.cols.keys.include?(key)
        end
        super(ary)
      elsif attrs.is_a? Array
        super(attrs)
        @table.cols.each { |col, idx| add_attr(col, attrs[idx]) }
      else
        raise ParseError, "Cannot create a row out of a #{attrs.class}"
      end
    end

    def update(attrs)
      cols = @table.cols
      attrs.each do |att, new_val|
        @table.table[@row][cols[att.to_sym]] = new_val
        add_attr(att.to_sym, new_val) if @table.cols.keys.include?(att)
      end
      self
    end

    def delete
      @table.table[@row] = nil
      self
    end

    def to_hash
      head = @table.cols.keys ; hash = {}
      self.map.with_index { |a, i| hash[head[i]] = a }
      hash
    end

    private
      def add_attr(name, value)
        self.class.send(:attr_accessor, name)
        instance_variable_set("@#{name}", value)
      end
  end
end
