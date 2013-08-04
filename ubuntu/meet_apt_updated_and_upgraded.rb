#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# meet_apt_updated_and_upgrade.rb
# Performs an update and update of aptitude. Will attempt to do so unattended.

script 'ensure_passwordless_sudo'
script "sudo apt-get -y --force-yes update"
script "sudo apt-get -y --force-yes upgrade"
script "sudo apt-get -y --force-yes clean"
