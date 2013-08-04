# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
require 'open3'
require 'stringio'

module Dosh

  module POpen

    protected

    def close_and_reopen_pipes(*pipes)
      pipes.each do |(close, reopen), io|
        close.close
        io.reopen reopen
        reopen.close
      end
    end

    def pipe3(command, opts = {})      
      # Pipe ourselves to a forked process
      pin, pout, perr = pipes = [IO.pipe.reverse, IO.pipe, IO.pipe]
      pid = fork do
        close_and_reopen_pipes([pin, $stdin], [pout, $stdout], [perr, $stderr])
        exec(command)
      end
      pipes.each { |n,f| n.sync = true; f.close } # Handle the pipes on this side

      # Read out from the Pipes
      sout, serr = StringIO.new, StringIO.new
      readfds = pipes.map(&:first)
      writefd = readfds.shift
      readers = { readfds[0] => [$stdout, sout], readfds[1] => [$stderr, serr] }

      run_pipes readers, writefd
      _, result = Process.waitpid2(pid)
      [result, sout.string, serr.string]
    ensure
      pipes.map(&:first).each {|p| p.close unless p.closed? }
    end

    def run_pipes(readers, writefd)
      readfds = readers.keys

      # @todo: Optional String or IO input -- writefd.write("")
      writefd.close

      # Run the pipes until it's exhausted
      readfds.reject!(&:closed?)
      until readfds.empty?
        readable, writeable, _ = IO.select(readfds)
        readable.each do |pipe| 
          buf = pipe.gets
          buf.nil? ? pipe.close : readers[pipe].each { |out| out.write(buf) }
        end
        readfds.reject!(&:closed?)
      end
    end

  end

end
