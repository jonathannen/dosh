#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# install_apt_key.rb <recv> [keyserver]

recv = ARGV.shift
keyserver = ARGV.shift || 'hkp://keyserver.ubuntu.com:80'
puts("The apt-key recv value is required") & exit(1) if recv.nil?

def met?(recv)
  `sudo apt-key list | grep #{recv}`.length > 0
end

exit(0) if met?(recv)
system "sudo apt-key adv --keyserver #{keyserver} --recv #{recv}"
exit(met?(recv) ? 0 : 1)
