#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# Host Rack workloads using nginx and unicorn.
#
# # dosh cepa/install_rack_application <name>

name = ARGV.first
raise "A username for the workload must be specified" if name.nil?

block "Creating an application user and associated workload" do

  script 'create_user', name
  su name, 'cepa/install_rack_workload'
  script 'cepa/create_unicorn_init_d', name, "/home/#{name}/webrepo"

end
