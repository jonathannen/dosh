# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# Called immediately by the dosh binary. Effectively the command line code
# for dosh.

dir = File.dirname(File.expand_path(File.realdirpath(__FILE__)))
require File.expand_path(File.join(dir, 'dosh.rb'))
$stdout.sync = true

# No arguments, display help
ARGV << 'commands/help' if ARGV.length == 0

# Standalone help and version flags
if ARGV.length == 1
  ARGV << 'commands/help' if ARGV.delete('--help')
  ARGV << 'commands/version' if ARGV.delete('--version')
end

s = Dosh::Script.new
filename = s.resolve_file(ARGV.first)

if filename =~ /\.rb\z/
  s.block(ARGV.shift) do      
    content = File.read(filename)
    eval(content, nil, filename)
    true
  end
else
  result = s.script(*ARGV)
end
