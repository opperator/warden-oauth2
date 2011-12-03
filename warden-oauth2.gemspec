# -*- encoding: utf-8 -*-
require File.expand_path('../lib/warden/oauth2/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Bleigh"]
  gem.email         = ["michael@intridea.com"]
  gem.description   = %q{OAuth 2.0 strategies for Warden}
  gem.summary       = %q{OAuth 2.0 strategies for Warden}
  gem.homepage      = "https://github.com/opperator/warden-oauth2"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "warden-oauth2"
  gem.require_paths = ["lib"]
  gem.version       = Warden::OAuth2::VERSION

  gem.add_dependency 'warden'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rack-test'
end
