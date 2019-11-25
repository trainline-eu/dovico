require "simplecov"
require "simplecov-rcov"
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter
]
SimpleCov.start do
  add_filter "db/"
  add_filter "spec/"
  add_filter "lib/dovico/app.rb"
  add_group "Dovico", "lib/dovico"
end
require "rspec"
require "rspec/its"
require "timecop"
require "rack/test"
require 'webmock/rspec'
require 'fileutils'
require 'tmpdir'

require 'pry'

# Load libs
require "dovico"

Timecop.safe_mode = true
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Use a temporary directory for cache file
  config.before(:example) do
    @cache_dir = Dir.mktmpdir("dovico")
    stub_const("Dovico::Assignments::CACHE_FILE", "#{@cache_dir}/assignments.json")
  end

  config.after(:example) do
    FileUtils.rm_rf(@cache_dir)
  end
end
