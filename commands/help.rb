#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# Output the dosh usage instructions.

puts <<-HELP
dosh version #{Dosh::VERSION}

Usage: dosh command_or_file [options]

HELP
exit(0)
