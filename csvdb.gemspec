# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csvdb/version'

Gem::Specification.new do |spec|
  spec.name          = "csvdb"
  spec.version       = Csvdb::VERSION
  spec.authors       = ["Colin Walker"]
  spec.email         = ["cjwalker@sfu.ca"]

  spec.summary       = %q{Object relational mapping for CSV files. Holds the entire database as a table of rows in memory.}
  spec.homepage      = "https://github.com/ColDog/csvdb"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'terminal-table', '~> 1.5.2'
  spec.add_dependency 'stat_sugar', '~> 1.0.0'

end
