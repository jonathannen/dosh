# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
require 'fileutils'

module Dosh
  ENV_STACK_DEPTH = '_DSTACK'
  MAXIMUM_STACK_DEPTH = 50
  VERSION = "0.0.2"

  class << self

    def puts(*args)
      STDOUT.print ENV[Dosh::ENV_INDENT]
      STDOUT.puts(*args)
    end

  end
end

dir = File.dirname(File.expand_path(__FILE__))
%w{dsl paths popen switch_user terminal 
  script}.each { |v| require File.join(dir, v) }
