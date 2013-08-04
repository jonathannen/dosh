# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
require 'fileutils'
require 'spec_helper'

describe 'cepa/unicorn' do

  # Target Repositories
  describe 'unicorn deployment' do

    before(:all) do
      FileUtils.mkdir_p('cepa_unicorn')
      File.open("Gemfile", 'w') { |f| f.write("gem 'unicorn'\n") }
    end
    before(:each) { Dir.chdir('cepa_unicorn') }

    it 'should not start a bad unicorn' do
      File.open("config.ru", 'w') {|f| f.write("raise 'Boom'\n") }
      expect { 
        script('cepa/control_unicorn', 'run') 
      }.to raise_error
    end

    it 'should start, restart and stop a good unicorn' do
      start_good_unicorn
      pid = File.read('tmp/pids/unicorn.pid').strip

      script 'cepa/control_unicorn', 'restart'
      should_not_timeout(1) { 
        File.read('tmp/pids/unicorn.pid').strip != pid
      }

      stop_unicorn
    end

    it 'should not allow the restart a bad (new) unicorn' do
      start_good_unicorn
      pid = File.read('tmp/pids/unicorn.pid').strip

      # Start up a bad one instead. We don't use the script as it takes
      # it's time to timeout
      File.open("config.ru", 'w') {|f| f.write("raise 'Boom'\n") }
      system "kill -USR2 #{pid}"
      sleep(1)
      
      File.read('tmp/pids/unicorn.pid').strip.should == pid
      stop_unicorn
    end

  end

  protected

  def start_good_unicorn
    File.open("config.ru", 'w') {|f| f.write("ENV['RACK_ENV'] = 'development'; run Proc.new {|env| [200, {}, ['CANARY']]}\n") }
    script 'cepa/control_unicorn', 'start'
    should_not_timeout(5) {
      `wget -qO- http://127.0.0.1:4567/` == "CANARY" 
    }
  end

  def stop_unicorn
    script 'cepa/control_unicorn', 'stop'
    should_not_timeout(5) { !File.exists?('tmp/pids/unicorn.pid') }
  end

end
