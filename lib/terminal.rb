# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
module Dosh

  module Terminal

    protected

    %w{black red green yellow blue magenta cyan grey}
    .each_with_index do |value, i|
      define_method(value.to_sym) { |v| "\e[0;3#{i}m#{v}\e[0m" }
      define_method(:gray) { |v| "\e[0;3#{i}m#{v}\e[0m" } if value == 'grey'
    end

    def white(v)
      "\e[0m#{v}"
    end

    def indentation_level
      (ENV[Dosh::ENV_STACK_DEPTH] || 0).to_i
    end

    def indentation
      '  ' * indentation_level
    end

    def log(*args)
      $stderr.puts "#{indentation}#{magenta(args * ' ')}"      
    end

    def log_failure(*args)
      $stderr.puts "#{indentation}#{red('✘')} #{args * ' '}"
    end

    def log_general(*args)
      $stderr.puts "#{indentation}#{args * ' '}"
    end

    def log_started(*args)
      i = indentation_level + 1
      if i > 0
        indent = grey('  ' * (i - 1)) + '#'
      else
        indent = '#' * i
      end

      $stderr.puts "#{indent} #{grey(args * ' ')}"
    end

    def log_success(*args)
      $stderr.puts "#{indentation}#{green('✔')} #{args * ' '}"
    end

  end

end
