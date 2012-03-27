# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sales_engine_spec_harness/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Yoho"]
  gem.email         = ["mby@mattyoho.com"]
  gem.description   = %q{Test harness for Hungry Academy SalesEngine project}
  gem.summary       = %q{Test harness for Hungry Academy SalesEngine project}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sales_engine_spec_harness"
  gem.require_paths = ["lib"]
  gem.version       = SalesEngineSpecHarness::VERSION

  gem.add_development_dependency 'rspec'
end
