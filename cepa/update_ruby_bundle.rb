#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# $ cepa/update_ruby_bundle

# Bundler installed - if not put a local copy in the 
`which bundle`
if $?.success?
  bundle_bin = 'bundle'
else
  v = Dir["tmp/gems/bundler-*/bin/bundle"].first
  if v.nil?
    system "gem install --install-dir tmp --no-rdoc --no-ri bundler"
    raise "Installation of bundler failed" unless $?.success?
    v = Dir["tmp/gems/bundler-*/bin/bundle"].first
  end
  bundle_bin = File.expand_path(v)
end

puts bundle_bin

system "#{bundle_bin} check"
unless $?.success?
  system "#{bundle_bin} install --deployment --without development:test"
end


`#{bundle_bin} list | grep "* unicorn "`
unless $?.success?
  $stderr.puts "Your product needs to have unicorn in it's Gemfile"
  exit(-1)
end



# puts $?.inspect
# puts v.inspect

# require 'bundler'
# bundle = Bundler::LockfileParser.new(File.read("Gemfile.lock"))
# unless bundle.specs.detect { |s| s.name == 'unicorn' }
# end



# puts v.specs.last.name
# bundle = Bundler::Dsl.evaluate('./Gemfile', './Gemfile.lock', {})


# # script "bundle "
# `bundle
# dep 'app bundled', :root, :env do
#   requires_when_unmet Dep('current dir:packages')
#   met? {
#     if !(root / 'Gemfile').exists?
#       log "No Gemfile - skipping bundling."
#       true
#     else
#       shell? 'bundle check', :cd => root, :log => true
#     end
#   }
#   meet {
#     install_args = %w[development test].include?(env) ? '' : "--deployment --without 'development test'"
#     unless shell("bundle install #{install_args} | grep -v '^Using '", :cd => root, :log => true)
#       confirm("Try a `bundle update`", :default => 'n') {
#         shell 'bundle update', :cd => root, :log => true
#       }
#     end
#   }
# end
