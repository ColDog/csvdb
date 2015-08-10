require 'csvdb/version'
require 'csv'
require 'csvdb/row'
require 'csvdb/errors'
require 'csvdb/table'
require 'terminal-table'
require 'stat_sugar'

module Csvdb
  extend self
  def new(opts = {})
    Table.new(opts)
  end
  def files(files = {})

  end
end
