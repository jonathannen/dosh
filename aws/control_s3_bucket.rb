#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
#
# $ dosh aws/control_s3_bucket 
#   lists all available buckets
#
# $ aws/control_s3_bucket create NAME REGION [acl] [-Hname=value]
#   create a bucket with the given name in the given region
#
# $ aws/control_s3_bucket put BUCKET FILE
#
require 'rexml/document'
require 'time'

regions = %w{
  ap-northeast-1 ap-southeast-1 ap-southeast-2 
  eu-west-1 
  us-east-1 us-west-1 us-west-2 
  sa-east-1
}

path = resource = "/"
filename = content_type = data = nil

headers = {}
arguments = []

# Parse any headers
command = ARGV.shift.to_s.downcase
ARGV.each do |arg|
  next unless arg =~ /\A-H/i
  k, v = arg[2..-1].split(":").map(&:strip)
  headers[k] = v || ""
end

case command
when 'create'
  command = :create
  bucket, region, acl = ARGV
  raise "Bucket name must be supplied" if bucket.nil?
  raise "A region must be specified from the list '#{regions * ', '}'" unless regions.include?(region)

  method = "PUT"
  headers['Content-Type'] = 'text/xml'
  headers['Host'] = "#{bucket}.s3.amazonaws.com"
  arguments << "--data '<CreateBucketConfiguration xmlns=\"http://s3.amazonaws.com/doc/2006-03-01/\"><LocationConstraint>#{region}</LocationConstraint></CreateBucketConfiguration>'"
  endpoint = "s3.amazonaws.com"
  resource = "/#{bucket}/"

when 'put'
  command = :put
  bucket, filename = ARGV.first(2)
  raise "Bucket must be supplied" if bucket.nil?
  raise "File must be supplied" if filename.nil?

  filename = File.expand_path(filename)
  mime_type = script("echo_mime_type", filename).strip
  method = "PUT"
  headers['Content-Type'] = mime_type
  endpoint = headers['Host'] = "#{bucket}.s3.amazonaws.com"
  arguments << "--upload-file #{filename}"
  path = "/#{File.basename(filename)}"  
  resource = "/#{bucket}/#{File.basename(filename)}"  

else
  command = :list
  method = "GET"
  endpoint = "s3.amazonaws.com"
end

puts headers.inspect

headers['Date'] = Time.now.httpdate
sign = [method, headers['Content-MD5'], headers['Content-Type'], headers['Date']]
sign += headers.select { |k,v| k =~ /\Ax-amz-/i }.map { |a,b| 
  "#{a.downcase.strip}:#{b.downcase.strip}" }.sort
request = (sign << resource) * "\n"
puts request

# Create the curl arguments
signature = `echo '#{request}' | dosh aws/echo_s3_auth_header`.strip
headers['Authorization'] = "AWS #{signature}"
arguments += headers.map { |a,b| "--header \"#{a}: #{b}\"" }
arguments << "--request #{method}"  

# Go time
retries = 0
while true
  raise "Too many retries or redirects" if retries > 5
  retries +=1

  curl = "curl #{arguments * ' '} https://#{endpoint}#{path}" #" 2> /dev/null"
  $stderr.puts curl.inspect
  v = `#{curl}` # 2> /dev/null`
  exit(-1) unless $?.success?
  response = REXML::Document.new(v)

  # Handle Redirects
  redirect = response.elements['//Error/Endpoint']
  unless redirect.nil?
    endpoint = redirect.text
    $stderr.puts "Redirecting to #{endpoint}"
    next
  end

  # Handle Errors
  error_code = response.elements['//Error/Code']
  unless error_code.nil?
    error_message = response.elements['//Error/Message']
    $stderr.puts "#{error_code.text}: #{error_message.nil? ? "" : error_message.text}"
    exit(-1)
  end

  break
end

case command
when :list
  response.root.elements['Buckets'].each { |e| puts e.elements['Name'].text }
else
  puts response
end
exit(0)
