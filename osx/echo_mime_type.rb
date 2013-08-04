#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# $ echo_mime_type FILENAME [--charset]

filename = ARGV.first
raise "A filename must be specified" if filename.nil?
filename = File.realdirpath(File.expand_path(filename))
charset = ARGV.delete('--charset')

result = `file -I #{filename}`.strip.split(' ')
exit(1) unless $?.success?
result.shift
result = result * ' '

puts charset ? result : result.split(';').first
