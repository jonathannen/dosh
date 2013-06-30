#!/usr/bin/env dosh -r
# encoding: utf-8
# Performs an update and update of aptitude. Will attempt to do so unattended.

script 'ensure_passwordless_sudo'
script "sudo apt-get -y --force-yes update"
script "sudo apt-get -y --force-yes upgrade"
script "sudo apt-get -y --force-yes clean"
