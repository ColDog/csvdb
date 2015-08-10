require 'csvdb/version'
require 'csv'
require 'csvdb/row'
require 'csvdb/errors'
require 'csvdb/table'


module Csvdb
  extend self
  def new(opts = {})
    Table.new(opts)
  end
end
