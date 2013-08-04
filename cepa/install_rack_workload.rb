#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# Host Rack workloads using nginx and unicorn.
#
# $ dosh cepa/install_rack_workload [name=current_user]

name = ARGV.first || `whoami`
reponame = 'webrepo'

block "Installing prerequisites for a Rack-based workload" do
  script 'app/git/create_target_repo', '~/webrepo'
end
