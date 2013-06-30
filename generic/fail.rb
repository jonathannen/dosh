#!/usr/bin/env ruby
# encoding: utf-8
# describe: Causes the script to fail with an optional message

puts "#{ENV['DOSH_INDENT']}#{ARGV.first}" if ARGV.length > 0
exit(false)
