#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# meet_apt_install.rb <package1> [package2..]

puts("At least one package is required") & exit(1) if ARGV.length == 0

def met?(names)
  !names.detect { |name| `dpkg -s #{name}`; !$?.success? }
end

exit(0) if met?(ARGV)
system "sudo apt-get -y --force-yes install #{ARGV * ' '}"
exit(met?(ARGV) ? 0 : 1)
