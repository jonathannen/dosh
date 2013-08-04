# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
# 
# Unicorn configuration file.
#   UNICORN_DIRECTORY: Directory to start unicorn in.
#   UNICORN_PORT: Listen port. Defaults to 4567 or a domain socket in production.
#   UNICORN_WORKERS: Number of workers to start. Defaults to 2.

require 'fileutils'

dir = ENV['UNICORN_DIRECTORY'] || Dir.pwd
raise "UNICORN_DIRECTORY value '#{dir}' not found." unless File.directory?(dir)
production = ENV['RACK_ENV'] == 'production'
%w{log tmp/pids tmp/sockets}.each { |v| FileUtils.mkdir_p(File.join(dir, v)) }

preload_app true
worker_processes (ENV['UNICORN_WORKERS'] || (production ? 3 : 2)).to_i
working_directory dir
timeout 30

port = ENV['UNICORN_PORT'] || (production ? File.join(dir, 'tmp/sockets/unicorn.sock') : 4567)
listen port, backlog: 64

pid File.join(dir, 'tmp/pids/unicorn.pid')
if production
  stderr_path File.join(dir, 'log/unicorn.stderr.log')
  stdout_path File.join(dir, 'log/unicorn.stdout.log')
end

# A USR2 has been sent to the master unicorn - this quits the old process
# when the new one starts up.
# See: http://unicorn.bogomips.org/SIGNALS.html
before_fork do |server, worker|
  oldpid = File.join(dir, 'tmp/pids/unicorn.pid.oldbin')
  if File.exists?(oldpid) && server.pid != oldpid
    begin
      Process.kill("QUIT", File.read(oldpid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
