#!/usr/bin/env dosh -r
# encoding: utf-8
# Installs MongoDB via the 10gen repository.

script 'install_apt_key', '7F0CEB10'
script 'install_apt_source', 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen'
script 'meet_apt_install', 'mongodb-10gen'
