$: << File.expand_path("../lib", __FILE__)
require 'dovico/version'

Gem::Specification.new do |s|
  s.name        = 'dovico'
  s.licenses    = ['MIT']
  s.version     = Dovico::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Théophile Helleboid', 'Paul Bonaud']
  s.email       = ['theophile.helleboid@trainline.com']
  s.homepage    = 'https://rubygems.org/gems/dovico'
  s.summary     = %q(Simple client & tools for http://www.dovico.com/.)
  s.description = %q(Simple client & tools for http://www.dovico.com/.)

  s.files         = `git ls-files`.split("\n") - ['bin/console']
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.2'

  s.add_dependency 'easy_app_helper'
  s.add_dependency 'active_attr'
  s.add_dependency 'typhoeus'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-rubocop'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'ci_reporter'
  s.add_development_dependency 'ci_reporter_rspec'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'webmock'
end
