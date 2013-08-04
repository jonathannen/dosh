# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Assigns execute permissions to suitable files'
task :chmod do
  Dir["./**/*.rb"].each do |f|
    next if !(f =~ /\A\.\/spec\/sample/) && f =~ /\A\.\/spec/
    v = File.read(f).lines.first.to_s.strip
    next unless ['#!/usr/bin/env dosh', '#!/usr/bin/env ruby'].include?(v)
    puts "+x #{f}"
    FileUtils.chmod("+x", f)
  end
end

desc 'Runs the RSpecs'
RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = ['--color']
end

task :default => :spec
