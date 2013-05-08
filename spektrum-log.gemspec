# -*- encoding: utf-8 -*-
require File.expand_path('../lib/spektrum-log/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nick Veys"]
  gem.email         = ["nick@codelever.com"]
  gem.description   = %q{Read and interpret Spektrum TLM log files.}
  gem.summary       = %q{Spektrum TLM log file reader}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "spektrum-log"
  gem.require_paths = ["lib"]
  gem.version       = Spektrum::Log::VERSION

  gem.add_development_dependency 'rspec', '~> 2.12'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'ci_reporter', '= 1.8.4'
end
