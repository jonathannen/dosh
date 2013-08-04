#!/usr/bin/env ruby
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# $ aws/echo_s3_auth_header.rb [--urlencode]
# Performs Amazon S3 REST Authentication on STDIN, as per
# http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html
#
# @todo cepa file credential requirements

require 'base64'
require 'cgi'
require 'digest/sha1'
require 'openssl'
require 'yaml'

filename = File.expand_path(File.join(Dir.pwd, '..', '.cepa.yml'))
config = YAML.parse(File.read(filename)).to_ruby

v = 'aws_access_key_id'
aws_access_key_id = ENV[v.upcase] || config[v]
v = 'aws_secret_access_key'
aws_secret_access_key = ENV[v.upcase] || config[v]

input = $stdin.read.strip

digest = OpenSSL::Digest::Digest.new('sha1')
hmac = OpenSSL::HMAC.digest(digest, aws_secret_access_key, input)
base64 = Base64.encode64(hmac).strip

base64 = CGI::escape(base64) if ARGV.delete('--urlencode') 
puts "#{aws_access_key_id}:#{base64}"
