#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# Called on deployment.

is_ruby = File.exists?('./Gemfile')

# Detect the installation. Right now we only support Rack-based unicorn.
raise "No Gemfile. Not a Ruby/Rack project?" unless is_ruby
raise "Gemfile.lock is required" unless File.exists?('./Gemfile.lock')

# require 'bundler'
# bundle = Bundler::LockfileParser.new(File.read("Gemfile.lock"))
# rails = bundle.specs.detect { |s| s.name == 'rails '}

puts "-----> Using Ruby/Rack"
puts "-----> Installing dependencies using Bundler"
script "cepa/update_ruby_bundle"
puts "-----> Restarting Unicorn container"
script "cepa/control_unicorn", "restart"
