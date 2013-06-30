# encoding: utf-8
module Dosh

  module Shelling

    protected

    def shell(*args)
      cmd = args * ' '
      `#{cmd}`
    rescue Errno::ENOENT => e
      nil
    end

  end

end
