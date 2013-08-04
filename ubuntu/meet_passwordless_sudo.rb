#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# meet_passwordless_sudo.rb <username>

username = ARGV.last
puts("Username must be supplied") & exit(1) if username.nil?

script 'ensure_passwordless_sudo'

`sudo su - murmur -c "sudo -n echo 1"`
puts $?.inspect

# filename = "/etc/sudoers.d/#{username}"
# unless File.exists?(filename)
#   File.open(filename, 'w') do |file|
#     file.write <<-DATA
# # dosh #{Dosh::VERSION} meet_passwordless_sudo.rb
# #{username} ALL=(ALL) NOPASSWD: ALL
#     DATA
#   end
#   `sudo chown root:root #{filename} && sudo chmod 0440 #{filename}`
# end

# $sudo chown root:root mount_conf
# $sudo chmod 0440 mount_conf
# $sudo mv mount_conf /etc/sudoers.d/
# `sudo -u murmur sudo -n echo 1`

# puts File.
# puts File.read("/etc/sudoers")

# sudo -n -u murmur
# system "sudo -n -u #{username} sudo -n echo 1 > /dev/null"
# unless $?.success?
  # addition = "#{username} ALL=(ALL) NOPASSWD: ALL"
  # system "echo '#{addition}'" # | sudo tee -a /etc/sudoers"
# end

# system "sudo -n -u #{username} sudo -n echo 1 > /dev/null"
# exit($?.success? ? 0 : 1)
