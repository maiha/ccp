# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Persistent::Versioned do
  def root; Pathname("tmp/spec/ccp/persistent/versioned"); end

  before do
    FileUtils.rm_rf(root)
    root.mkpath
  end

  describe "(accessors)" do
    subject { Ccp::Persistent::Versioned.new(root, :kvs=>"dir", :ext=>"yaml") }
    its(:kvs) { should == "dir" }
    its(:ext) { should == "yaml" }
  end

  describe "#latest" do
    it "should return a kvs with the latest dated file" do
      # create directories
      (root + "1.json" ).mkpath
      (root + "10.xxx" ).mkpath
      (root + "5.json" ).mkpath
      (root + "20.yaml").mkpath

      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)
      kvs = ver.latest

      kvs.should be_kind_of(Ccp::Persistent::Dir)
      kvs.source.should == root + "20.yaml"
      kvs.ext.should == "yaml"
    end

    it "should lookup timestamp when same dated files exist" do
      # create directories
      (root + "1.json").mkpath
      (root + "1.yaml").mkpath

      (root + "1.json").utime(100,100)
      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)
      ver.latest.ext.should == "yaml"

      (root + "1.yaml").utime(10,10)
      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)
      ver.latest.ext.should == "json"
    end

    it "should return nil when no files" do
      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)
      ver.latest.should == nil
    end
  end

  describe "#latest!" do
    it "should return a kvs with the latest dated file" do
      # create directories
      [1, 10, 5, 100].each{|i| (root + "#{i}.json").mkpath}

      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)
      kvs = ver.latest!

      kvs.should be_kind_of(Ccp::Persistent::Dir)
      kvs.source.should == root + "100.json"
    end

    it "should return StorageNotFound when no files exist" do
      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)

      lambda {
        ver.latest!
      }.should raise_error(Ccp::Persistent::NotFound)
    end
  end

  describe "#default" do
    it "should return a kvs with the latest dated file" do
      # create directories
      [1, 10, 5, 100].each{|i| (root + "#{i}.json").mkpath}

      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)
      kvs = ver.default

      kvs.should be_kind_of(Ccp::Persistent::Dir)
      kvs.source.should == root + "100.json"
    end

    it "should create a new kvs when no files exist" do
      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)
      kvs = ver.default
      kvs.should be_kind_of(Ccp::Persistent::Dir)
      kvs.ext.should == "json"
    end
  end

  describe "#now" do
    it "should create a new kvs with current time" do
      Time.stub!(:now) { Time.at(12345) }
      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)
      kvs = ver.now
      kvs.should be_kind_of(Ccp::Persistent::Dir)
      kvs.path.basename.to_s.should == "12345.json"
      kvs.ext.should == "json"
    end
  end

  describe "#[]" do
    it "should return a kvs with given base name" do
      ver = Ccp::Persistent::Versioned.new(root, :kvs=>:dir, :ext=>:json)
      kvs = ver[:data]
      kvs.should be_kind_of(Ccp::Persistent::Dir)
      kvs.path.basename.to_s.should == "data.json"
      kvs.ext.should == "json"
    end
  end
end
