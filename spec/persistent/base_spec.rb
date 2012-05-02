# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Persistent::Base do
  subject { Ccp::Persistent::Base.new(:source, Ccp::Serializers::Json) }

  describe "#source" do
    it "should return source" do
      subject.source.should == :source
    end
  end

  it "should provide ext" do
    subject.methods.include?("ext").should == true
  end

  it "should provide exist?" do
    subject.methods.include?("exist?").should == true
  end

  it "should provide #load!" do
    subject.methods.include?("load!").should == true
  end

  it "should provide #load" do
    subject.methods.include?("load").should == true
  end

  it "should provide #[]" do
    subject.methods.include?("[]").should == true
  end

  it "should provide #[]=" do
    subject.methods.include?("[]=").should == true
  end

  it "should provide #keys" do
    subject.methods.include?("keys").should == true
  end

  it "should provide #truncate" do
    subject.methods.include?("truncate").should == true
  end
end
