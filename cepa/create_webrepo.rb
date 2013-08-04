#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# $ cepa/create_webrepo [directory=~/webrepo]

dir = ARGV.first || '~/webrepo'

block 'Creating Web Repository' do

  # puts resolve_command('app/git/create_target_repo')
  # script 'app/git/create_target_repo', dir

end
