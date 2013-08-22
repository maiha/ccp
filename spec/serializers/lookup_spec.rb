# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Serializers do
  # API
  it { should respond_to(:lookup) }

  describe "#reload!" do
    def add_serializer(const_name)
      # define a new serializer
      ext = const_name.downcase
      mod = Module.new
      mod.module_eval <<-EOF
        include Ccp::Serializers::Core
        def ext; '#{ext}'; end
        extend self
      EOF
      Ccp::Serializers[ext] = mod
    end

    def del_serialier(const_name)
      ext = const_name.downcase
      Ccp::Serializers.delete(ext)
    end

    specify do
      # given
      lambda { subject.lookup(:foo) }.should raise_error(Ccp::Serializers::NotFound)

      begin
        # main
        add_serializer("Foo")
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
