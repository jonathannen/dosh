#!/usr/bin/env ruby
# encoding: utf-8
# install_apt_source.rb <entry>

puts("Entry must be supplied. Something like \"deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen\"") & exit(1) if ARGV.length == 0
entry = ARGV * ' '

def met?(entry)
  `cat /etc/apt/sources.list`.lines.detect { |v| v.strip == entry }
end

exit(0) if met?(entry)
system "echo '#{entry}' | sudo tee -a /etc/apt/sources.list"
system "sudo apt-get -y --force-yes update"
exit(met?(entry) ? 0 : 1)
