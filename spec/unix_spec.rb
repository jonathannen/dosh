# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.

require 'spec_helper'

describe "unix" do

  it "should recognize common mime types with optional charset" do
    {
      'canary.jpg'             => ['image/jpeg', 'binary'],
      'canary.png'             => ['image/png',  'binary'],
      'utf8_text_file.txt'     => ['text/plain', 'utf-8'],
      'utf16le_text_file.txt'  => ['text/plain', 'utf-16le'],
    }.each do |file, (mime, charset)|
      r, o, e = script 'echo_mime_type', "../spec/sample/#{file}"
      o.strip.should == mime
      next if charset.nil?

      r, o, e = script 'echo_mime_type', "../spec/sample/#{file}", '--charset'
      o.strip.should == "#{mime}; charset=#{charset}"
    end
  end

end
