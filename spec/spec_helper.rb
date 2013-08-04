# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
require 'fileutils'
require 'pathname'
require 'timeout'

# Load dosh itself
dir = File.dirname(File.expand_path(File.realdirpath(__FILE__)))
require File.expand_path(File.join(dir, '..', 'lib', 'dosh.rb'))

# We can't guarantee dosh is installed - plus we want to use this explicit
# local version. So we tweak the path.
bin = File.expand_path(File.join(dir, '..', 'bin'))
puts bin.inspect
ENV['PATH'] = "#{bin}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
puts ENV['PATH']

# Clear down the tmp directory
tmp = File.expand_path(File.join(dir, '..', 'tmp'))
FileUtils.rm_r Dir.glob(File.join(tmp, '*'))

module Helpers

  def should_not_timeout(time, wait = 0.2, &block)
    success = false
    Timeout::timeout(time) do
      sleep(wait) until yield
    end
  end

end

RSpec.configure do |c|
  c.include Helpers
  c.before(:suite) { Dir.chdir(tmp) }
  c.before(:each)  { Dir.chdir(tmp) }
end
