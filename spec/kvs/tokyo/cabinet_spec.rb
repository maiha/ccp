# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Kvs::Tokyo::Cabinet do
  let(:tmp) { tmp_path + "kvs/tokyo/cabinet" }
  let(:tch) { tmp + "foo.tch" }
  let(:kvs) { subject }

  subject { Ccp::Kvs::Tokyo::Cabinet.new(tch) }
  before  { FileUtils.rm_rf(tmp) if tmp.directory? }
  after   { subject.close }

  def put(key, val)
    kvs.touch
    system("tchmgr put #{kvs.path} #{key} #{val}")
  end

  def del(key)
    kvs.touch
    system("tchmgr out #{kvs.path} #{key}")
  end

  ######################################################################
  ### info

  describe "#info" do
    context "(no files)" do
      specify do
        lambda { subject.info }.should raise_error(Ccp::Kvs::NotConnected)
      end
    end

    context "(file exists)" do
      specify do
        subject.touch
        subject.info.should be_kind_of(Ccp::Kvs::Tokyo::Info)
      end
    end
  end

  ######################################################################
  ### count

  describe "#count" do
    context "(not opened)" do
      specify { lambda { subject.count }.should raise_error(Ccp::Kvs::NotAllowed) }
    end

    context "(for read)" do
      specify {
        kvs.touch
        kvs.R!()
        kvs.count.should == 0
      }

      specify {
        kvs.touch
        kvs.R{ kvs.count.should == 0 }
      }
    end

    context "(for write)" do
      specify {
        kvs.W!()
        kvs.count.should == 0
      }

      specify {
        kvs.W{ kvs.count.should == 0 }
      }
    end
  end

  ######################################################################
  ### get

  describe "#get" do
    context "(not opened)" do
      specify { lambda { kvs.get("foo") }.should raise_error(Ccp::Kvs::NotAllowed) }
    end

    context "(for read)[no records]" do
      before  { kvs.touch; kvs.R! }
      specify { kvs.get("foo").should == nil }
    end

    context "(for read block)[no records]" do
      before  { kvs.touch }
      specify { kvs.R { kvs.get("foo").should == nil } }
    end

    context "(for read)[exists]" do
      before  { put(:foo, 1); kvs.R! }
      specify { kvs.get("foo").should == "1" }
    end

    context "(for read block)[exists]" do
      before  { put(:foo, 1); kvs.R! }
      specify { kvs.R { kvs.get("foo").should == "1" } }
    end

    context "(for write)[no records]" do
      before  { kvs.W! }
      specify { kvs.get("foo").should == nil }
    end

    context "(for write block)[no records]" do
      specify { kvs.W { kvs.get("foo").should == nil } }
    end

    context "(for write)[exists]" do
      before  { put(:foo, 1); kvs.W! }
      specify { kvs.get("foo").should == "1" }
    end

    context "(for write block)[exists]" do
      before  { put(:foo, 1); kvs.W! }
      specify { kvs.W { kvs.get("foo").should == "1" } }
    end
  end

  ######################################################################
  ### set

  describe "#set" do
    before { kvs.touch }

    context "(not opened)" do
      specify { lambda { kvs.set("foo", 2) }.should raise_error(Ccp::Kvs::NotAllowed) }
    end

    context "(for read)" do
      before  { kvs.R! }
      specify { lambda { kvs.set("foo", 2) }.should raise_error(Ccp::Kvs::NotAllowed) }
    end

    context "(for read block)" do
      specify { lambda { kvs.R{ kvs.set("foo", 2) } }.should raise_error(Ccp::Kvs::NotAllowed) }
    end

    context "(for write)" do
      before  { kvs.W! }
      specify { kvs.set("foo", 2).should == "2" }
    end

    context "(for write block)" do
      specify { kvs.W{ kvs.set("foo", 2) }.should == "2" }
    end
  end

  ######################################################################
  ### del

  describe "#del" do
    before { kvs.touch; put(:foo, 3) }

    context "(not opened)" do
      specify { lambda { kvs.del("foo") }.should raise_error(Ccp::Kvs::NotAllowed) }
    end

    context "(for read)" do
      before  { kvs.R! }
      specify { lambda { kvs.del("foo") }.should raise_error(Ccp::Kvs::NotAllowed) }
    end

    context "(for read block)" do
      specify { lambda { kvs.R{ kvs.del("foo") } }.should raise_error(Ccp::Kvs::NotAllowed) }
    end

    context "(for write)" do
      before  { kvs.W! }
      specify {
        kvs.get("foo").should == "3"
        kvs.del("foo").should == "3"
        kvs.get("foo").should == nil
      }
    end

    context "(for write block)" do
      specify {
        kvs.W {
          kvs.get("foo").should == "3"
          kvs.del("foo").should == "3"
          kvs.get("foo").should == nil
        }
      }
    end

    context "(for write)[no records]" do
      before  { del(:foo); kvs.W! }
      specify {
        kvs.get("foo").should == nil
        kvs.del("foo").should == nil
      }
    end

    context "(for write block)[no records]" do
      before  { del(:foo) }
      specify {
        kvs.W {
          kvs.get("foo").should == nil
          kvs.del("foo").should == nil
        }
      }
    end
  end

  ######################################################################
  ### keys

  describe "#keys" do
    specify do
      put(:foo, 1)
      put(:bar, 2)
      put(:baz, 3)

      kvs.R!
      kvs.keys.sort.should == %w( bar baz foo )
    end
  end
end
