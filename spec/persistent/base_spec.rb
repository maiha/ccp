# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Ccp::Persistent::Base do
  subject { Ccp::Persistent::Base.new(:source, Ccp::Serializers::Json) }

  describe "#source" do
    it "should return source" do
      subject.source.should == :source
    end
  end

  it { should respond_to("ext") }
  it { should respond_to("exist?") }
  it { should respond_to("save") }
  it { should respond_to("load!") }
  it { should respond_to("load") }
  it { should respond_to("[]") }
  it { should respond_to("[]=") }
  it { should respond_to("keys") }
  it { should respond_to("truncate") }
end
