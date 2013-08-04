#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# Installs MongoDB via the 10gen repository.

script 'install_apt_key', '7F0CEB10'
script 'install_apt_source', 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen'
script 'meet_apt_install', 'mongodb-10gen'
