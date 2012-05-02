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
end
