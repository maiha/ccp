# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Persistent::Tsv do
  def root; Pathname("tmp/spec/ccp/persistent/tsv"); end

  before do
    FileUtils.rm_rf(root)
    root.mkpath
  end

  describe "#tsv_path_for" do
    it "should return tsv pathname" do
      kvs = Ccp::Persistent::Tsv.new(root, :json)
      kvs.tsv_path_for(:states).should == Pathname(root) + "states.json.tsv"
    end
  end

  context "(with json)" do
    let(:kvs) { Ccp::Persistent::Tsv.new(root, :json)}

    it "should save and load hash" do
      kvs["a"] = {"int"=>1, "str"=>"x"}
      kvs["a"].should == {"int"=>1, "str"=>"x"}
    end

    it "should save and load complex-valued hash" do
      kvs["a"] = {"int"=>[1,2], "str"=>["x","y"]}
      kvs["a"].should == {"int"=>[1,2], "str"=>["x","y"]}
    end
  end

  context "(with yaml)" do
    let(:kvs) { Ccp::Persistent::Tsv.new(root, :yaml) }

    it "should save and load hash" do
      kvs["a"] = {"int"=>1, "str"=>"x"}
      kvs["a"].should == {"int"=>1, "str"=>"x"}
    end

    it "should save and load complex-valued hash" do
      kvs["a"] = {"int"=>[1,2], "str"=>["x","y"]}
      kvs["a"].should == {"int"=>[1,2], "str"=>["x","y"]}
    end

    it "should save and load tab-contained hash" do
      kvs["a"] = {"str"=>"a\tb"}
      kvs["a"].should == {"str"=>"a\tb"}
    end
  end
end
