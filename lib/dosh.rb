# encoding: utf-8

module Dosh
  VERSION = "0.0.1"
end

dir = File.dirname(File.expand_path(__FILE__))
%w{shelling terminal script platform}.each { |v| require File.join(dir, v) }