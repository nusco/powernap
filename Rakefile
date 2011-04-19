desc "Start app"
task :start do
  system "bundle exec rackup"
end

desc "Run tests"
task :test do
  system "bundle exec rspec spec/"
end

task :default => :start
