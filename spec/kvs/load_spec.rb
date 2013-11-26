# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Kvs do

  specify ".load" do
    Ccp::Kvs.should respond_to(:load)
  end

  ######################################################################
  ### Unknown case

  context "(unknown codec)" do
    specify do
      expect{ Ccp::Kvs.load("foo.xxx.kch") }.to raise_error(/xxx/)
    end
  end

  context "(unknown ext)" do
    specify do
      expect{ Ccp::Kvs.load("foo.json.yyy") }.to raise_error(/yyy/)
    end
  end

  ######################################################################
  ### Usally case

  codecs = %w( json msgpack )
  exts   = %w( kch )
  exts << "tch" if defined?(TokyoCabinet)

  codecs.product(exts).each do |codec, ext|
    file = "foo.#{codec}.#{ext}"

    context "(#{file})" do
      subject { Ccp::Kvs.load(file) }

      it { should be_kind_of(Ccp::Kvs::Core) }
      its(:source) { should == file }
      its(:ext)    { should == ext }
      it { subject.codec.ext.should == codec }
    end
  end
end
