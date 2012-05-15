# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Persistent do
  it { should respond_to("load") }

  describe ".load" do
    before { FileUtils.rm_rf "tmp" }

    context "('tmp/foo.json')" do
      subject { Ccp::Persistent.load('tmp/foo.json') }
      its(:class)  { should == Ccp::Persistent::File }
      its(:ext)    { should == "json" }
      its(:source) { should == 'tmp/foo.json' }
    end

    context "('tmp/foo.yaml')" do
      subject { Ccp::Persistent.load('tmp/foo.yaml') }
      its(:class)  { should == Ccp::Persistent::File }
      its(:ext)    { should == "yaml" }
      its(:source) { should == 'tmp/foo.yaml' }
    end

    context "('tmp/foo.json/')" do
      subject { Ccp::Persistent.load('tmp/foo.json/') }
      its(:class)  { should == Ccp::Persistent::Dir }
      its(:ext)    { should == "json" }
      its(:source) { should == 'tmp/foo.json' }
    end

    context "(Pathname('tmp/foo.json) with existed directory')" do
      before { FileUtils.mkdir_p("tmp/foo.json") }
      subject { Ccp::Persistent.load(Pathname('tmp/foo.json')) }
      its(:class)  { should == Ccp::Persistent::Dir }
      its(:ext)    { should == "json" }
      its(:source) { should == Pathname('tmp/foo.json') }
    end

    context "('tmp/foo.json with existed directory')" do
      before { FileUtils.mkdir_p("tmp/foo.json") }
      subject { Ccp::Persistent.load('tmp/foo.json') }
      its(:class)  { should == Ccp::Persistent::Dir }
      its(:ext)    { should == "json" }
      its(:source) { should == 'tmp/foo.json' }

      it "can read!" do
        save_fixture("tmp/foo.json/a.json", 1)
        subject.read!.should == {"a"=>1}
      end
    end

    context "('tmp/foo')" do
      it "should raise Ccp::Serializers::NotFound" do
        lambda {
          Ccp::Persistent.load('tmp/foo')
        }.should raise_error(Ccp::Serializers::NotFound)
      end
    end

    context "('tmp/foo/')" do
      it "should raise Ccp::Serializers::NotFound" do
        lambda {
          Ccp::Persistent.load('tmp/foo/')
        }.should raise_error(Ccp::Serializers::NotFound)
      end
    end
  end
end
