#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
# 
# $ unix/ensure_running_pidfile.rb --clean [pidfile]
#
# Exits successfully if the specified pidfile is present, and the process
# it is pointing to is running. If the process is running the pid is output
# to STDOUT.
#
# If the pidfile is present and the process *isn't* running, the --clean
# option will cause the pidfile to get deleted.

clean = ARGV.delete('--clean')

pidfile = ARGV.first
raise "A pid file is required" if pidfile.nil?

pid = File.file?(pidfile) ? File.read(pidfile).to_i : -1
if pid > 0
  begin
    Process.getpgid(pid)
    puts pidfile
    exit(0) # Running
  rescue Errno::ESRCH
  end
end

# Clean up if it's been requested
File.delete(pidfile) if clean && File.file?(pidfile)

exit(-1) # Not running
