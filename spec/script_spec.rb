# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.

require 'spec_helper'

describe Dosh do

  it "should reflect a success on 'echo 1'" do
    r, o, e = script "echo 1"
    o.strip.should == "1"
  end

  it "should reflect a failure on 'exit 1'" do
    expect { script "exit 1" }.to raise_error
  end

end
