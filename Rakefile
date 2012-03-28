#!/usr/bin/env rake
require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--tag ~extension"
  end

  task default: :spec

  RSpec::Core::RakeTask.new("spec:extensions") do |t|
    t.rspec_opts = "--tag extension"
  end
rescue
end
