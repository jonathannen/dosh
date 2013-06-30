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

    def initialize(use_require = false)
      @use_require = use_require
    end

    def candidate_files(filename)
      fn = [filename]
      fn += EXPLICIT_EXTENSIONS.map { |ext| "#{filename}#{ext}"} unless has_explicit_extension?(filename)
      fn += fn.product(platform_prefixes).map { |file, dir| File.join(dir, file) }
      fn.product([@@dosh_dir, Dir.pwd]).map { |file, dir| File.join(dir, file) }.uniq
    end

    def resolve_file(filename)
      candidate_files(filename).detect { |file| File.exists?(file) }
    end

    def script(*args, &block)
      if args.first == :meet
        command = args.first
        task = Meet.new
        task.instance_eval(&block)
      else 
        filename = nil
        command = args.shift
        if @use_require || !File.exists?(command)
          filename = resolve_file(command)
        end
        task = @use_require ? Require.new(filename, args) : Standard.new(filename, command, args)
      end

      raise "#{command} failed" unless run_dependency(command, task, &block)

    rescue Exception => e
      raise e
    end

    protected 

    def has_explicit_extension?(filename)
      !!EXPLICIT_EXTENSIONS.detect { |ext| filename.end_with?(ext) }
    end

    def run_dependency(header, task, &block)
      current = ENV['DOSH_INDENT'] || ""
      log_started(header)
      ENV['DOSH_INDENT'] = "#{current}  "
      result = task.run(&block)
      ENV['DOSH_INDENT'] = current

      result ? log_success(header) : log_failure(header)
      result
    rescue Exception => e
      puts e.message
      puts e.backtrace
      ENV['DOSH_INDENT'] = current
      log_failure(header)
      raise e
    end

  end


  class Meet < Script

    def run
      return true if self.met?
      meet
      self.met?
    end

  end

  class Require < Script

    def initialize(filename, args)
      @filename = filename
      @args = args
    end

    def run
      raise "File '#{command}' not found" if @filename.nil?
      ARGV.clear
      @args.each { |a| ARGV << a }
      require(@filename)
    end

  end

  class Standard < Script

    def initialize(filename, command, args)
      @filename = filename
      @command = command
      @args = args
    end

    def run(&block)
      raise "File '#{@filename}' not executable" if !@filename.nil? && !File.executable?(@filename)
      system(@filename || @command, *@args)
      success = $?.success?
      self.instance_eval(&block) if success && block_given?
      success
    end

  end
  
end

Object.send(:include, Dosh::Injection)
