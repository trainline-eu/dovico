# Test tasks
begin
  require "ci/reporter/rake/rspec"
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
  task :rspec => "ci:setup:rspec"

  # Default
  task :default => :spec
rescue LoadError
end
