#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# Installs nginx.

script 'install_apt_key', '7BD9BF62'
script 'install_apt_source', 'deb http://nginx.org/packages/ubuntu/ precise nginx'
script 'meet_apt_install', 'nginx'
