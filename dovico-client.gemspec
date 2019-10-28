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
  s.executables   = ['bin/dovico'].map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.2.2'

  s.add_dependency 'easy_app_helper', '~> 4'
  s.add_dependency 'active_attr', '~> 0.10'
  s.add_dependency 'typhoeus', '~> 1'
  s.add_dependency 'highline', '~> 1'

  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'guard', '~> 2'
  s.add_development_dependency 'guard-rspec', '~> 4'
  s.add_development_dependency 'guard-rubocop', '~> 1'
  s.add_development_dependency 'rubocop', '~> 0'
  s.add_development_dependency 'ci_reporter', '~> 2'
  s.add_development_dependency 'ci_reporter_rspec', '~> 1'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake', '> 10'
  s.add_development_dependency 'rspec', '> 3'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'simplecov', '> 0.14'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'timecop', '> 0.8'
  s.add_development_dependency 'webmock', '~> 3'
end
