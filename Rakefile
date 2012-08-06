require 'bundler/setup'

desc "Start app"
task :start do
  system "bundle exec rackup"
end

require 'rspec/core/rake_task'

desc "run specs"
RSpec::Core::RakeTask.new

task :default => 'test'
