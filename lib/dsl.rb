# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
require 'fileutils'

module Dosh

  # Convenient place to put the additional dosh scripting comments
  module DSL

    # http://ruby-doc.org/core-2.0/Dir.html#method-c-chdir
    def chdir(*args, &block)
      return Dir.chdir(&block) if args.length == 0
      path = args.map { |v| v.chomp(File::SEPARATOR) } * File::SEPARATOR
      path = File.expand_path(path)
      Dir.chdir(path, &block)
      true
    end
    alias :cd :chdir

    def fail(message = nil)
      $stderr.puts(message) unless message.nil?
      exit(-1)
    end

    def write_file(filename, opts)
      content = Hash === opts ? opts[:content] : opts.to_s
      File.open(filename, 'w') { |f| f.write(content) }

      if Hash === opts
        chmod = opts[:chmod]
        FileUtils.chmod(chmod, filename) unless chmod.nil?
      end
      true
    end

  end

end
