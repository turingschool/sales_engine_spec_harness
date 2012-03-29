#!/usr/bin/env rake
require "bundler/gem_tasks"
Bundler.require

begin
  require 'rspec/core/rake_task'

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
