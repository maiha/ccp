# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Kvs do
  # API
  it { should respond_to(:lookup) }

  describe "#reload!" do
    def add_kvs(const_name)
      # define a new kvs
      ext = const_name.downcase
      kvs = Class.new
      kvs.class_eval <<-EOF
        include Ccp::Kvs::Core
        def ext; '#{ext}'; end
      EOF
      Ccp::Kvs[ext] = kvs
    end

    def del_serialier(const_name)
      ext = const_name.downcase
      Ccp::Serializers.delete(ext)
    end

    specify do
      # given
      lambda { subject.lookup(:foo) }.should raise_error(Ccp::Kvs::NotFound)

      begin
        # main
        add_kvs("Foo")
        subject.lookup(:foo).should be_kind_of(Class)
      ensure
        del_serialier("Foo")
      end
    end
  end

  describe "#lookup" do
    context ":hash" do
      it "should return Ccp::Kvs::Hash" do
        subject.lookup(:hash).should == Ccp::Kvs::Hash
      end
    end

    context ":xxx" do
      it "should raise NotFound" do
        lambda {
          subject.lookup(:xxx)
        }.should raise_error(Ccp::Kvs::NotFound)
      end
    end
  end
end
