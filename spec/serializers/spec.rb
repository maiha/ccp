# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Serializers do
  describe "#lookup" do
    context ":json" do
      it "should return Ccp::Serializers::Json" do
        subject.lookup(:json).should == Ccp::Serializers::Json
      end
    end

    context "'json'" do
      it "should return Ccp::Serializers::Json" do
        subject.lookup('json').should == Ccp::Serializers::Json
      end
    end

    context ":yaml" do
      it "should return Ccp::Serializers::Yaml" do
        subject.lookup(:yaml).should == Ccp::Serializers::Yaml
      end
    end

    context "'yaml'" do
      it "should return Ccp::Serializers::Yaml" do
        subject.lookup('yaml').should == Ccp::Serializers::Yaml
      end
    end

    context ":xxx" do
      it "should raise NotFound" do
        lambda {
          subject.lookup(:xxx)
        }.should raise_error(Ccp::Serializers::NotFound)
      end
    end
  end
end
