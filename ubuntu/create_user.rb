#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# # dosh cepa/create_user <name>

name = ARGV.first
raise "A username must be specified" if name.nil?

unless name =~ /\A[a-z_][a-z0-9_]{0,30}\z/
  raise "The name '#{name}'' isn't a valid username. It must be an alphanumeric "\
        "string, starting with a letter and up to a maximum of 32 characters."
end

begin 
  Etc.getpwnam(name)
  result = true
rescue 
  `sudo useradd --base-dir /home --create-home --shell /bin/bash #{name}`
  result = $?.success?
end

result
