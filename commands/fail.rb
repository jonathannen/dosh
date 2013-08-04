#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# describe: Causes the script to fail with an optional message

$stderr.puts "#{ENV['DOSH_INDENT']}#{ARGV.first}" if ARGV.length > 0
exit(false)
