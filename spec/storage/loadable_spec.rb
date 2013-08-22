# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Storage do
  specify ".load" do
    Ccp::Storage.should respond_to(:load)
  end

  describe ".load" do
    before { FileUtils.rm_rf(tmp_path) if tmp_path.directory? }

    context "('tmp/foo.json.tch')" do
      subject { Ccp::Storage.load('tmp/foo.json.tch') }
      its(:source) { should == 'tmp/foo.json.tch' }
      its(:kvs)    { should be_kind_of(Ccp::Kvs::Tch) }
      its(:codec)  { should == Ccp::Serializers::Json }

      describe "table(:foo)" do
        subject { Ccp::Storage.load('tmp/foo.json.tch').table(:bar) }
        its(:source) { should == 'tmp/foo.json.tch/bar.json.tch' }
        its(:kvs)    { should be_kind_of(Ccp::Kvs::Tch) }
        its(:codec)  { should == Ccp::Serializers::Json }
      end
    end
  end

#  it { should respond_to(:tables) }
#  it { should respond_to(:table) }
end
