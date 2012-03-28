#!/usr/bin/env rake
require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--tag ~merchant --tag ~customer --tag ~invoice"
  end

  task default: :spec

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
