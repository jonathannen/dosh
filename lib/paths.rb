# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
module Dosh

  module Platform

    def kernel
      @_kernel ||= case `uname -s`.strip
      when 'Darwin' 
        :osx

      when 'Linux' 
        case
        when `which lsb_release > /dev/null 2>&1 && lsb_release -d`.strip =~ /\ADescription:\tUbuntu/ 
          :ubuntu
        else 
          :linux
        end

      else 
        :unknown
      end
    end

    def platform_prefixes
      @_platform_prefixes ||= case kernel
      when :linux  then %w{linux  unix generic commands}
      when :ubuntu then %w{ubuntu unix generic commands}
      when :osx    then %w{osx    unix generic commands}
      else %w{generic commands}
      end
    end

  end

  module Paths
    EXPLICIT_EXTENSIONS = ['.rb', '.sh']

    @@dosh_dir = File.expand_path(File.join(File.dirname(File.expand_path(File.realdirpath(__FILE__))), '..'))

    def candidate_files(filename)
      v = File.expand_path(filename)
      return [v] if File.exists?(v)

      fn = [filename]
      fn += EXPLICIT_EXTENSIONS.map { |ext| "#{filename}#{ext}"} unless has_explicit_extension?(filename)
      fn += fn.product(platform_prefixes).map { |file, dir| File.join(dir, file) }
      fn.product([@@dosh_dir, Dir.pwd]).map { |file, dir| File.join(dir, file) }.uniq
    end

    def resolve_command(args)
      opts = Hash === args.last ? args.pop : {}

      # @todo
      args = args.map { |v| v.split(/\s/) }.flatten

      name = args.first
      filename = resolve_file(name)
      if filename
        args.shift
        raise "File '#{filename}' not executable" unless File.executable?(filename)
      else
        filename = args * ' '
        name = filename.split(' ').first.split('/').last
        args = []
      end

      [name, filename, args, opts]
    end

    def resolve_file(filename)
      candidate_files(filename).detect { |file| File.exists?(file) }
    end

    def has_explicit_extension?(filename)
      !!EXPLICIT_EXTENSIONS.detect { |ext| filename.end_with?(ext) }
    end



    # def split_command(args)
    #   opts = Hash === args.last ? args.pop : {}
    #   filename = args.shift
    #   # @todo: Rules around spaces and quoting
    #   return filename, args, opts
    # end

    # # 1. Exact path match.
    # # 2. Platform prefixed. ubuntu12.04, ubuntu, linux, generic.
    # # 3. ./
    # # 4. ./dosh
    # # 5. ~/dosh
    # # 6. /usr/local/dosh
    # # 7. Installed gem directories with with `.doshes` in the root.
    # def resolve_file(name)


    # end
    #   # fn = [filename]
    #   # fn += EXPLICIT_EXTENSIONS.map { |ext| "#{filename}#{ext}"} unless has_explicit_extension?(filename)
    #   # fn += fn.product(platform_prefixes).map { |file, dir| File.join(dir, file) }
    #   # fn.product([@@dosh_dir, Dir.pwd]).map { |file, dir| File.join(dir, file) }.uniq

  end

end
