# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Storage do
  specify ".load" do
    Ccp::Storage.should respond_to(:load)
  end

  describe ".load" do
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

    context "('tmp/foo.msgpack.tch')" do
      subject { Ccp::Storage.load('tmp/foo.msgpack.tch') }
      its(:source) { should == 'tmp/foo.msgpack.tch' }
      its(:kvs)    { should be_kind_of(Ccp::Kvs::Tch) }
      its(:codec)  { should == Ccp::Serializers::Msgpack }
    end

    context "(pathname)" do
      subject { Ccp::Storage.load(Pathname('tmp/foo.msgpack.tch')) }
      its(:source) { should == Pathname('tmp/foo.msgpack.tch') }
      its(:kvs)    { should be_kind_of(Ccp::Kvs::Tch) }
      its(:codec)  { should == Ccp::Serializers::Msgpack }
    end
  end

  describe "#read!" do
    before { FileUtils.rm_rf(tmp_path) if tmp_path.directory? }

    context "(file)" do
      let(:tch) { tmp_path + "foo.json.tch" }
      subject { Ccp::Storage.new(tch, Ccp::Kvs::Tch, Ccp::Serializers::Json) }
      before  {
        tch.parent.mkpath
        system("tchmgr create #{tch}")
        system("tchmgr put #{tch} a '[1,2]'")
        system("tchmgr put #{tch} b 0.1")
      }
      specify do
        subject.read!.should == {"a" => [1, 2], "b" => 0.1}
      end
    end
    
    context "(directory)" do
      let(:tch) { tmp_path + "foo.json.tch" }
      subject { Ccp::Storage.new(tch, Ccp::Kvs::Tch, Ccp::Serializers::Json) }
      before  {
        tch.mkpath
        system("tchmgr create #{tch}/a.json.tch")
        system("tchmgr put    #{tch}/a.json.tch x '[1,2]'")
        system("tchmgr put    #{tch}/a.json.tch y []")
        system("tchmgr create #{tch}/b.json.tch")
        system("tchmgr put    #{tch}/b.json.tch y 0.1")
      }
      specify do
        subject.read!.should == {
          "a" => {"x" => [1, 2], "y" => []},
          "b" => {"y" => 0.1},
        }
      end
    end

  end

#  it { should respond_to(:tables) }
#  it { should respond_to(:table) }
end
