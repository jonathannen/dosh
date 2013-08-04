#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# $ cepa/install_nginx_vhost [NAME] [DIRECTORY]
require 'fileutils'

name, directory = ARGV
name = `whoami`.strip

path = File.join(Dir.pwd, '.cepa', 'nginx_vhost.conf')
path = File.expand_path(path)
FileUtils.mkdir_p(File.dirname(path))

asset_path = File.join(Dir.pwd, 'public')
socket_path = File.join(Dir.pwd, 'tmp/sockets/unicorn.sock')

File.open(path, 'w') do |f| 
  f.write <<-CONTENT
# nginx & unicorn Virtual Host configuration.
#
# This is a generated file. For details, see:
# #{__FILE__}

gzip on;
gzip_http_version 1.0;
gzip_proxied any;
gzip_min_length 500;
gzip_disable "MSIE [1-6]\.";
gzip_types text/plain text/xml text/css text/comma-separated-values text/javascript application/x-javascript application/atom+xml;

upstream #{name}_upstream {
  server unix:#{socket_path} fail_timeout=0;
}

server {
  charset utf-8;
  keepalive_timeout 5;
  listen 80 default deferred;
  root #{asset_path};
  server_name _;

  location ~ ^/assets/ {
    expires max;
    gzip_static on;
    add_header Cache-Control public;
    add_header Last-Modified "";
    add_header ETag "";
    break;
  }

  try_files $uri /maintenance.html @app;

  location @app {
    proxy_pass           http://#{name}_upstream;
    proxy_redirect       off;

    proxy_buffer_size    64k;
    proxy_buffers        32 16k;
    client_max_body_size 128m;

    proxy_set_header     Host              $host;
    proxy_set_header     X-Real-IP         $remote_addr;
    proxy_set_header     X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header     X-Forwarded-Proto $scheme;
  }

}
CONTENT
end
