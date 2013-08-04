# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
require 'benchmark'

use_color = !ARGV.include?('--no-color')

module Dosh
  EXPLICIT_EXTENSIONS = ['.rb', '.sh']

  module Injection

    def block(name = nil, &block)
      Script.new.block(name, &block)
    end

    def script(*args)
      Script.new.script(*args)
    end

    def try_script(*args)
      Script.new.try_script(*args)
    end

  end
  Object.send(:include, Dosh::Injection)

  class Script
    include DSL
    include Paths
    include Platform
    include POpen
    include SwitchUser
    include Terminal

    def block(name = nil, &block)
      name ||= ""
      log_started(name)
      increment do 
        s = Script.new(@opts)
        @success = s.instance_eval(&block)
      end
    rescue SystemExit => se
      @success = se.success?
      raise se unless @success
    rescue Exception => e
      @success = false
      raise e
    ensure
      @success ? log_success(name) : log_failure(name)
    end

    def initialize(opts = {})
      @opts = opts
      @success = nil
    end

    def script(*args)
      result, _ = v = run(args)
      exit(result.exitstatus) unless result.success?
      v
    end

    def success?
      !!@success
    end

    def try_script(*args)
      result, = res = run(args)
      @success
    rescue Exception => e
      @exception = e
      @success = false
    end

    protected 

    def increment(&block)
      current = (ENV[Dosh::ENV_STACK_DEPTH] || 0).to_s
      raise "Dosh stack overflow" if current.to_i > Dosh::MAXIMUM_STACK_DEPTH
      ENV[Dosh::ENV_STACK_DEPTH] = (current.to_i + 1).to_s
      yield
    ensure
      ENV[Dosh::ENV_STACK_DEPTH] = current
    end

    def run(args)
      result = res = nil
      name, filename, args, opts = resolve_command(args)
      command = "#{filename} #{args * ' '}"
      block(name) do
        result, _ = res = pipe3(command, opts)
        result.success?
      end
      res
    end

  end
  
end

