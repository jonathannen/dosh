#!/usr/bin/env dosh
# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
# 
# $ app/git/target_repo_created.rb <path>
#
# Creates a git repository that is in "always receive" mode. When code is pushed
# to this repository, scripts will be triggered via git hooks.
require 'fileutils'

path = ARGV.first
fail "A path for the repository must be specified" if path.nil?

path = File.expand_path(path)
FileUtils.mkdir_p(path)
cd(path) do

  block("Ensure the git repo is initialized and set to receive") {
    script "test -d .git || git init"
    v = `git config receive.denyCurrentBranch`.strip
    script "git config receive.denyCurrentBranch ignore" unless v == "ignore"
  }

  write_file ".git/hooks/pre-receive", chmod: '+x', content: <<-CONTENT
#!/usr/bin/env ruby
Dir.chdir '..'

# Handle the case where the repo is totally new
`unset GIT_DIR && git rev-parse --verify HEAD`
unless $?.success?
  puts "Target appears to be a new repository"
  exit(0)
end

puts "Target currently at: '\#{`unset GIT_DIR && git branch -v`.strip}'"

diffindex = `unset GIT_DIR && git diff-index --name-status HEAD`.strip
if diffindex.length > 0
  puts "Cannot Receive: The target repository has unstaged changes. Output was:
\#{diffindex}

You need a clean target repository to push code. Target repositories aren't
intended to have local changes - just receive code.

If you wish to delete these changes, try the following on the target repository:
  $ git reset --hard
or stash the changes
  $ git stash"
  exit(-1)
end
CONTENT


  write_file ".git/hooks/post-receive", chmod: "+x", content: <<-CONTENT
#!/usr/bin/env ruby
Dir.chdir '..'
current_id, next_id, ref = $stdin.read.split(' ')
branch = ref.split('/').last
`unset GIT_DIR && git reset --hard \#{next_id}`
exit(1) unless $?.success?

puts "Target updated to: '\#{`unset GIT_DIR && git branch -v`.strip}'"

system "dosh cepa/trigger_deploy"
exit(0)
CONTENT

end
