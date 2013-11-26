# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Kvs::Kyoto::Cabinet do
  let(:tmp) { tmp_path + "kvs/kyoto/cabinet" }
  let(:kch) { tmp + "foo.kch" }
  let(:kvs) { subject }

  subject { Ccp::Kvs::Kyoto::Cabinet.new(kch) }
  before  { FileUtils.rm_rf(tmp) if tmp.directory? }
  after   { subject.close }

  def put(key, val)
    kvs.touch
    system("kchashmgr set #{kvs.path} #{key} #{val}")
  end

  def del(key)
    kvs.touch
    system("kchashmgr remove #{kvs.path} #{key}")
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

    ### error: rare case

    pending "TODO: tc,kc is not safe about file deletion" do
      # ruby: + open(read) -----------------+ kvs.get ---
      # file:                + delete kch ---------------
      context "(for read with file deletion)" do
        before  { put(:foo, 1); kvs.W!; kch.unlink }
        specify { kvs.set("xxx", "_").should == false }
      end
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
      specify { lambda { kvs.set("foo", 2) }.should_not raise_error }
    end

    context "(for write block)" do
      specify { lambda { kvs.W{ kvs.set("foo", 2) }.should_not raise_error } }
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
  ### read / write

  describe "#read" do
    specify do
      put(:foo, 1)
      put(:bar, 2)

      kvs.R!
      kvs.read.should == {"foo" => "1", "bar" => "2"}
    end
  end

  describe "#write" do
    specify do
      kvs.W!
      kvs.write("foo" => "1", "bar" => "2")

      kvs.get("foo").should == "1"
      kvs.get("bar").should == "2"
    end
  end

  ######################################################################
  ### each

  describe "#each" do
    specify do
      put(:foo, 1)
      put(:bar, 2)

      kvs.R!

      hash = {}
      kvs.each{|k,v| hash[k] = v}
      hash.should == {"foo" => "1", "bar" => "2"}
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

  ######################################################################
  ### first

  describe "#first" do
    specify do
      put(:foo, 1)
      put(:bar, 2)

      kvs.R!
      first = kvs.first
      first.should be_kind_of(Array)
      first.size.should == 2
      first[0].should =~ /^(foo|bar)$/
      first[1].should =~ /^(1|2)$/
    end
  end

  describe "#first_key" do
    specify do
      put(:foo, 1)
      put(:bar, 2)

      kvs.R!
      kvs.first_key.should =~ /^(foo|bar)$/
    end
  end

  ######################################################################
  ### exist?

  describe "#exist?" do
    specify do
      put(:foo, 1)

      kvs.R!
      kvs.exist?(:foo).should be
      kvs.exist?(:bar).should_not be
    end
  end
end
