#!/usr/bin/env rake

begin
  require 'rspec/core/rake_task'

  desc "Run each test file in the sales engine solution independently."
  namespace :test do
    task :independently do
      working_directory = Dir.pwd
      begin
        Dir.chdir('../sales_engine')
        files = Dir.glob('test/**/*_test.rb')
        files.each do |file|
          system("ruby #{file}")
        end
      ensure
        Dir.chdir(working_directory)
      end
    end
  end

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--tag ~merchant --tag ~customer --tag ~invoice"
  end

  task :default do
    Rake::Task["spec"].invoke

    extensions = SalesEngine::EXTENSIONS.sort rescue []

    if extensions == %w(customer invoice merchant)
      Rake::Task["spec:extensions"].invoke
    else
      extensions.each {|ext| Rake::Task["spec:extensions:#{ext}"].invoke }
    end
  end

  RSpec::Core::RakeTask.new("spec:extensions") do |t|
    t.rspec_opts = "--tag merchant --tag customer --tag invoice"
  end

  RSpec::Core::RakeTask.new("spec:extensions:merchant") do |t|
    t.rspec_opts = "--tag merchant"
  end
  RSpec::Core::RakeTask.new("spec:extensions:invoice") do |t|
    t.rspec_opts = "--tag invoice"
  end
  RSpec::Core::RakeTask.new("spec:extensions:customer") do |t|
    t.rspec_opts = "--tag customer"
  end
rescue
end
