# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Serializers::Core do
  subject { Object.new.extend Ccp::Serializers::Core }

  it "should provide ext" do
    subject.methods.include?("ext").should == true
  end

  it "should provide encode" do
    subject.methods.include?("encode").should == true
  end

  it "should provide decode" do
    subject.methods.include?("decode").should == true
  end
end
