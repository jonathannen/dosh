#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# install_openjdk [version]
#   version: "7" would install Java7. This is the default.

script(:meet) do
  @version = ARGV.shift || "7"

  def met?
    shell("java -version 2>&1").include?("version \"1.#{@version}.")
  end

  def meet
    script 'meet_apt_install', "openjdk-#{@version}-jdk"
  end

end
