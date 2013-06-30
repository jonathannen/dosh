# encoding: utf-8
require 'benchmark'

use_color = !ARGV.include?('--no-color')

module Dosh
  EXPLICIT_EXTENSIONS = ['.rb', '.sh']

  module Injection

    def script(*args, &block)
      s = Script.new
      s.script(*args, &block)
    end

  end

  class Script
    include Shelling
    include Terminal
    @@dosh_dir = File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..'))

    attr_reader :no_headers

    def initialize(opts = {})
      @no_headers = opts[:no_headers] || false
    end

    def candidate_files(filename)
      fn = [filename]
      fn += EXPLICIT_EXTENSIONS.map { |ext| "#{filename}#{ext}"} unless has_explicit_extension?(filename)
      fn += fn.product(platform_prefixes).map { |file, dir| File.join(dir, file) }
      fn.product(["", @@dosh_dir, Dir.pwd]).map { |file, dir| File.join(dir, file) }.uniq
    end

    def resolve_file(filename)
      candidate_files(filename).detect { |file| File.exists?(file) }
    end

    # @return [ true, false ] true if the command was successful
    def run(*args)
      cmd = args * ' '
      run_command(cmd)
    rescue ArgumentError => ae
      false
    rescue Exception => e
      puts "@todo " + e.inspect
      puts e.backtrace
      false
    end

    def run_command(cmd)
      filename = File.exists?(cmd) ? cmd : resolve_file(cmd)
      if filename
        raise "File '#{filename}' not executable" unless File.executable?(filename)
      else
        filename = cmd
      end
      system(filename)
      success = $?.success?
    end

    def resolve!(*args)
      cmd = args * ' '
      filename = resolve_file(cmd)
      raise "File for '#{cmd}' not found" if filename.nil?
      filename
    end

    def script(*args, &block)
      cmd = args * ' '
      current = ENV[Dosh::ENV_INDENT] || ""

      log_started(cmd) unless no_headers
      ENV[Dosh::ENV_INDENT] = "#{current}  "
      throw "fail" unless run(*args)

      run_block(&block) if block_given?

      ENV[Dosh::ENV_INDENT] = current
      log_success(cmd) unless no_headers
      true
    rescue Exception => e
      ENV[Dosh::ENV_INDENT] = current
      log_failure(cmd) unless no_headers
      throw e
    end

    def run_block(&block)
      s = Script.new
      result = s.instance_eval(&block)
    rescue ArgumentError => ae
      false
      raise ae
    rescue Exception => e
      puts "@todo " + e.inspect
      puts e.backtrace
      raise e
    end

    protected 

    def has_explicit_extension?(filename)
      !!EXPLICIT_EXTENSIONS.detect { |ext| filename.end_with?(ext) }
    end

  end
  
end

Object.send(:include, Dosh::Injection)
