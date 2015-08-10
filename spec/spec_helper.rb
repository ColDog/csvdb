$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'csvdb'

def path(doc)
  root = File.dirname __dir__
  File.join root, doc
end

def one
  path('/spec/docs/one.csv')
end

def write_to
  path('/spec/docs/write_to.csv')
end

def stats
  path('/spec/docs/stats.csv')
end

def join1
  path('/spec/docs/join1.csv')
end

def join2
  path('/spec/docs/join2.csv')
end
