# encoding: utf-8
module Dosh

  module Shelling

    protected

    # Simple shelling. 
    # @return [ String ] the output to STDOUT of the script.
    def shell(*args)
      cmd = args * ' '
      `#{cmd}`
    rescue Errno::ENOENT => e
      nil
    end

  end

end
