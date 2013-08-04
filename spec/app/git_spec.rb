# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
require 'spec_helper'

describe 'app/git' do

  # Target Repositories
  describe 'target repositories' do

    before(:all) do
      # Create a repo to push from
      `mkdir app_git_src_repo && cd app_git_src_repo 
       git init . && git remote add origin ../app_git_tgt_repo`
       touch_and_commit_file('CANARY', 'app_git_src_repo')
    end

    before(:each) do
      puts `pwd`
      FileUtils.rm_rf('./app_git_tgt_repo')
      script "dosh app/git/create_target_repo ./app_git_tgt_repo"
      script "cd app_git_src_repo && git push origin master"
      File.exists?('./app_git_tgt_repo/CANARY').should be_true
    end

    it 'should allow the initial and subsequent pushes' do
      touch = "HAIRY#{Time.now.to_i}"
      touch_and_commit_file(touch, "app_git_src_repo")
      script "cd app_git_src_repo && git push origin master"
      File.exists?("./app_git_tgt_repo/#{touch}").should be_true      
    end

    it 'should deny a push if there are local changes' do
      touch = "SCARY#{Time.now.to_i}"
      script "cd app_git_tgt_repo && touch #{touch} && git add ."

      touch = "FAIRY#{Time.now.to_i}"
      touch_and_commit_file(touch, "app_git_src_repo")
      expect { 
        script("cd app_git_src_repo && git push origin master") 
      }.to raise_error
    end

  end

  protected

  def touch_and_commit_file(name, directory)
    v = "cd #{directory}
         git config user.email \"cepa@example.org\"
         git config user.name \"Cepa Test\"
         touch #{name}
         git add .
         git commit -am 'Touched #{name}'".lines.map(&:strip) * ' && '
    script(v)
  end

end
