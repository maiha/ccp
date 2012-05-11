# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Persistent::Dir do
  def root; Pathname("tmp/spec/ccp/persistent/dir"); end
  def db1 ; root + "db1"; end
  def db2 ; root + "db2"; end

  before do
    FileUtils.rm_rf(root)
    root.mkpath
  end

  describe ".ext" do
    it "should return ''" do
      Ccp::Persistent::Dir.ext.should == ''
    end
  end

  describe "#path" do
    it "should return the given source" do
      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs.path.to_s.should == root.to_s
    end
  end

  describe "#[]=" do
    it "should create data.file into <dir>/<key>.<ext>" do
      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs[:foo] = "[1,2,3]"
      (root + "foo.json").should exist
    end
  end

  describe "#load!" do
    it "should fetch data if exists" do
      (root + "foo.json").open("w+"){|f| f.print "1"}
      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs.load!(:foo).should == 1
    end

    it "should raise NotFound if not exists" do
      kvs = Ccp::Persistent::Dir.new(root, :json)
      lambda {
        kvs.load!(:foo)
      }.should raise_error(Ccp::Persistent::NotFound)
    end
  end

  describe "#load" do
    it "should fetch data if exists" do
      (root + "foo.json").open("w+"){|f| f.print "1"}
      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs.load(:foo).should == 1
    end

    it "should return nil if not exists" do
      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs.load(:foo).should == nil
    end
  end

  describe "#[]" do
    it "should fetch data if exists" do
      (root + "foo.json").open("w+"){|f| f.print "1"}
      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs.load!(:foo).should == 1
    end

    it "should raise NotFound if not exists" do
      kvs = Ccp::Persistent::Dir.new(root, :json)
      lambda {
        kvs.load!(:foo)
      }.should raise_error(Ccp::Persistent::NotFound)
    end
  end

  describe "#read" do
    it "should fetch all data if exists" do
      (root + "foo.json").open("w+"){|f| f.print "1"}
      (root + "bar.json").open("w+"){|f| f.print "2"}
      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs.read.should == {"foo"=>1, "bar"=>2}
    end

    it "should return {} if the path doesn't exist" do
      kvs = Ccp::Persistent::Dir.new(root + "no-such-path", :json)
      kvs.read.should == {}
    end
  end

  describe "#read!" do
    it "should fetch all data if exists" do
      (root + "foo.json").open("w+"){|f| f.print "1"}
      (root + "bar.json").open("w+"){|f| f.print "2"}
      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs.read!.should == {"foo"=>1, "bar"=>2}
    end

    it "should raise NotFound if the path doesn't exist" do
      kvs = Ccp::Persistent::Dir.new(root + "no-such-path", :json)
      lambda {
        kvs.read!
      }.should raise_error(Ccp::Persistent::NotFound)
    end
  end

  describe "#keys" do
    it "should return a sorted array of key names filtered by given ext" do
      ["1.json", "2.yaml", "3.json"].each do |i|
        (root + i).open("w+"){}
      end

      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs.keys.should == ["1","3"]
    end

    it "should raise NotFound if the path doesn't exist" do
      kvs = Ccp::Persistent::Dir.new(root + "no-such-path", :json)
      lambda {
        kvs.keys
      }.should raise_error(Ccp::Persistent::NotFound)
    end
  end

  describe "#truncate" do
    it "should delete all *.<ext>" do
      ["1.json", "2.yaml", "3.json"].each do |i|
        (root + i).open("w+"){}
      end
      root.children.map{|i| i.basename.to_s}.sort.should == ["1.json", "2.yaml", "3.json"]

      kvs = Ccp::Persistent::Dir.new(root, :json)
      kvs.truncate
      root.children.map{|i| i.basename.to_s}.sort.should == ["2.yaml"]
    end
  end

  it "should save data into storage and load it" do
    kvs = Ccp::Persistent::Dir.new(db1, :json)
    kvs[:foo] = "[1,2,3]"

    FileUtils.mv(db1, db2)
    kvs = Ccp::Persistent::Dir.new(db2, :json)
    kvs[:foo].should == "[1,2,3]"
  end
end
