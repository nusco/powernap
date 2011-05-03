desc "Start app"
task :start do
  system "bundle exec rackup"
end

namespace :test do
  desc "Run in-memory tests"
  task :memory do
    system "bundle exec rspec spec/memory spec/shared"
  end
  
  desc "Run Mongoid tests"
  task :mongoid  do
    system "bundle exec rspec spec/mongoid spec/shared"
  end
  
  desc "Run all tests"
  task :all => [:memory, :mongoid]
end

task :default => 'test:all'
