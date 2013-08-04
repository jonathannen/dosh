# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
require 'etc'

module Dosh

  module SwitchUser

    def su(*args)
      name = args.shift
      user = Fixnum === name ? Etc.getpwuid(name) : Etc.getpwnam(name)

      # No need to switch if we're already them
      return script(args) if Process.uid == user.uid

      indent = (ENV[Dosh::ENV_INDENT] || 0).to_i + 1
      script "sudo su - #{name} -c \""\
             "export #{Dosh::ENV_INDENT}=\"#{indent}\" && "\
             "#{resolve_command(*args).gsub('"', '\"')}\""
    end

    # @todo: This code had the appearance of working, but didn't work when
    # shelling.
    # http://brizzled.clapper.org/blog/2011/01/01/running-a-ruby-block-as-another-user/
    # def su(user, &block)
    #   # Resolve the user using the etc package - /etc/passwd under the hood
    #   user = Fixnum === user ? Etc.getpwuid(user) : Etc.getpwnam(user)
    #   puts user.inspect

    #   case
    #   # No need to switch user if we're already there
    #   when Process.uid == user.uid 
    #     yield
      
    #   # We're not the user, but we're not root either
    #   when Process.uid != 0
    #     raise "Script must be run using as root or using sudo"
      
    #   # Switch user and run already
    #   else
    #     p = Process.fork do
    #       Process.uid = user.uid
    #       yield
    #     end
    #     Process.wait(p)
    #   end
    # end

  end

end
