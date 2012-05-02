# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Serializers::Json do
  its(:ext) { should == "json" }

  describe "with Array(Integer)" do
    it "should encode" do
      subject.encode([1,2,3]).should == "[1,2,3]"
    end

    it "should decode" do
      subject.decode("[1,2,3]").should == [1,2,3]
    end
  end

  describe "with {String => Integer}" do
    it "should encode" do
      subject.encode("foo" => 1).should == '{"foo":1}'
    end

    it "should decode" do
      subject.decode('{"foo":1}').should == {"foo" => 1}
    end
  end
end
