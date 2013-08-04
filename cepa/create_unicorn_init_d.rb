#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# # cepa/create_unicorn_init_d.rb [USERNAME] [DIRECTORY] [options]
#
# Options:
#   --env NAME
#   Sets the Rack Environment. Defaults to "production".
#
# Creates an init.d script that will switch user (su) to the given username
# and then change to the given directory. The script args are then passed
# directly to the cepa/control_unicorn script.
#
# The resulting script will have the name /etc/init.d/unicorn-#{username}

username, directory = ARGV
username ||= `whoami`
directory ||= Dir.pwd

write_file "/etc/init.d/unicorn-#{username}", chmod: '+x', content: <<-CONTENT
#!/bin/bash
# This is a generated file. For details, see:
# #{__FILE__}

set -e
cd #{directory} || exit 1
quoted_args="$(printf " %q" "$@")"
su - #{username} -c "cd #{directory} && dosh cepa/control_unicorn $quoted_args"
CONTENT
