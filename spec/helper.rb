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

require 'pry'

# Load libs
require "dovico"

Timecop.safe_mode = true
WebMock.disable_net_connect!(allow_localhost: true)
