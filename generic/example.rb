#!/usr/bin/env dosh -r
# encoding: utf-8
# describe: Runs a sample script

script "echo A" do
  script "echo B"
  script "echo", "C" do
    script "generic/fail"
  end
end
