#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# Installs bundler as a system-level gem.

`which bundle && bundle version`
unless $?.success?
  `sudo gem install bundler`
end

`bundle version`
$?.success?
