# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Serializers do
  # API
  it { should respond_to(:dictionary) }
  it { should respond_to(:reload!) }
  it { should respond_to(:lookup) }

  describe "#dictionary" do
    specify do
      subject.dictionary.should be_kind_of(Hash)
    end
  end

  describe "#reload!" do
    def add_serializer(const_name)
      # define a new serializer
      mod = Module.new
      mod.module_eval <<-EOF
        include Ccp::Serializers::Core
        def ext; '#{const_name.downcase}'; end
        extend self
      EOF
      Ccp::Serializers.const_set(const_name, mod)
    end

    def del_serialier(name)
      Ccp::Serializers.instance_eval{ remove_const(name) }
    end

    specify do
      # given
      lambda { subject.lookup(:foo) }.should raise_error(Ccp::Serializers::NotFound)

      begin
        # main
        add_serializer("Foo")
        subject.reload!
        subject.lookup(:foo).should be_kind_of(Ccp::Serializers::Core)
      ensure
        del_serialier("Foo")
      end
    end
  end

  describe "#lookup" do
    context ":json" do
      it "should return Ccp::Serializers::Json" do
        subject.lookup(:json).should == Ccp::Serializers::Json
      end
    end

    context "'json'" do
      it "should return Ccp::Serializers::Json" do
        subject.lookup('json').should == Ccp::Serializers::Json
      end
    end

    context ":yaml" do
      it "should return Ccp::Serializers::Yaml" do
        subject.lookup(:yaml).should == Ccp::Serializers::Yaml
      end
    end

    context "'yaml'" do
      it "should return Ccp::Serializers::Yaml" do
        subject.lookup('yaml').should == Ccp::Serializers::Yaml
      end
    end

    context ":msgpack" do
      it "should return Ccp::Serializers::Msgpack" do
        subject.lookup(:msgpack).should == Ccp::Serializers::Msgpack
      end
    end

    context "'msgpack'" do
      it "should return Ccp::Serializers::Msgpack" do
        subject.lookup('msgpack').should == Ccp::Serializers::Msgpack
      end
    end

    context ":xxx" do
      it "should raise NotFound" do
        lambda {
          subject.lookup(:xxx)
        }.should raise_error(Ccp::Serializers::NotFound)
      end
    end
  end
end
