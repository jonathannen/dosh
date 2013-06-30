# encoding: utf-8
module Dosh

  module Terminal

    protected

    COLORS = %w{black red green yellow blue magenta cyan grey}
    
    COLORS.each_with_index do |value, i|
      define_method(value.to_sym) { |v| "\e[0;3#{i}m#{v}\e[0m" }

      if value == 'grey'
        define_method(:gray) { |v| "\e[0;3#{i}m#{v}\e[0m" } 
      end
    end

    def white(v)
      "\e[0m#{v}"
    end

    def indentation
      ENV[Dosh::ENV_INDENT]
    end

    def log_failure(*args)
      puts "#{indentation}#{red('✘')} #{args * ' '}"
    end

    def log_general(*args)
      puts "#{indentation}#{args * ' '}"
    end

    def log_started(*args)
      puts "#{indentation}> #{grey(args * ' ')}"
    end

    def log_success(*args)
      puts "#{indentation}#{green('✔')} #{args * ' '}"
    end

  end

end
