# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Serializers::Yaml do
  its(:ext) { should == "yaml" }

  describe "with Array(Integer)" do
    it "should encode" do
      subject.encode([1,2,3]).should == "--- \n- 1\n- 2\n- 3\n"
    end

    it "should decode" do
      subject.decode("--- \n- 1\n- 2\n- 3\n").should == [1,2,3]
    end
  end

  describe "with {String => Integer}" do
    it "should encode" do
      subject.encode("foo" => 1).should == "--- \nfoo: 1\n"
    end

    it "should decode" do
      subject.decode("--- \nfoo: 1\n").should == {"foo" => 1}
    end
  end
end
