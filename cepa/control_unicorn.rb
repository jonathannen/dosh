#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# $ cepa/unicorn.rb [restart|run|start|stop]
# Operates unicorn in the current directory.

if ARGV.delete('--help')
  puts <<-HELP
Controls a Unicorn process, defaulting to the current directory.

  cepa/unicorn.rb [restart|run|start|stop|tail]

Commands:
  restart: Triggers a "graceful" restart of unicorn. Starts if not running.
  run: Runs unicorn in the current process (The default).
  start: Starts unicorn, unless already running.
  stop: Stops unicorn.
  tails: Tails the production stdout and stderr logs.

Environment Variables:
  RACK_ENV: The system environment. Defaults to "development".
  UNICORN_DIRECTORY: The directory to run unicorn in. Defaults to the current.
  UNICORN_PID: Unicorn master pid file. Defaults to $UNICORN_DIRECTORY/tmp/pids/unicorn.pid
  UNICORN_WORKERS: Number of workers. Defaults to 2 generally. 3 in production.
HELP
  exit(0)
end

$stdout.sync = true
ENV['RACK_ENV'] ||= 'development'
dir = ENV['UNICORN_DIRECTORY'] ||= Dir.pwd

config = File.join(File.dirname(__FILE__), '_unicorn_config.rb')
control = (ARGV.first || 'run').downcase

# Check on the pid and determine the command based on the running status
pidfile = ENV['UNICORN_PID'] ||= File.join(dir, 'tmp/pids/unicorn.pid')
oldbin = File.join(dir, 'tmp/pids/unicorn.pid.oldbin')

if try_script('ensure_running_pidfile', pidfile, '--clean')
  pid = File.read(pidfile).strip.to_i
  if %w{run start}.include?(control)
    puts "Cannot #{control}, unicorn already running at pid:#{pid}."
    exit(-1)
  end
else
  if control == 'stop'
    puts("Cannot stop, no running unicorn found.")
    exit(-1)
  end
  if control == 'restart'
    puts "No running unicorn found. Starting instead."
    control = 'start'
  end
end

case control
  # Work out the command to run based upon the co
  # Ask unicorn to quiesce the existing workers.
  # See http://unicorn.bogomips.org/SIGNALS.html
  when 'restart' then
    script "kill -USR2 #{pid}"
    timeout = 120
    $stdout.print "Waiting #{timeout}s for successful unicorn restart "

    # Wait for timeout for a new pid file to appear
    restarted = false
    started = Time.now
    while !restarted && ((Time.now - started) < timeout)
      sleep 0.5
      $stdout.print "."
      next if !File.exists?(pidfile) || File.exists?(oldbin)
      newpid = File.read(pidfile).strip.to_i
      restarted = (newpid != pid)
    end

    puts restarted ? " OK (Unicorn #{pid} -> #{newpid})" : " Fail (Timed out. Check your unicorn logs)."
    exit(-1) unless restarted

  when 'run' then
    script "bundle exec unicorn -c #{config}"

  when 'start' then
    fork { exec "bundle exec unicorn -c #{config} > /dev/null 2>&1 &" }

  when 'stop' then
    script "kill -QUIT #{pid}"

  when 'tail' then
    stderr = File.join(dir, 'log/unicorn.stderr.log')
    stdout = File.join(dir, 'log/unicorn.stdout.log')
    script "tail -f #{stderr} -f #{stdout}"

  else nil
    puts "Command '#{ARGV.first}' not valid. Run with --help for instructions."
    exit(-1)

end
