# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Utils::Colorize::Bar do
  delegate :strip, :to=>"Ccp::Utils::Colorize"
  delegate :success, :to=>"Ccp::Utils::Colorize::Bar"

  ######################################################################
  ### API

  subject { Ccp::Utils::Colorize::Bar }
  it { should respond_to(:success) }
  it { should respond_to(:info) }
  it { should respond_to(:warning) }
  it { should respond_to(:danger) }

  it { should respond_to(:green) }
  it { should respond_to(:blue) }
  it { should respond_to(:yellow) }
  it { should respond_to(:red) }

  ######################################################################
  ### Success

  describe ".success" do
    subject { strip(success(*args)) }

    context '("Mem[%sMB]", 73, [4004,24105])' do
      let(:args) { ["Mem[%sMB]", 73, [4004,24105]] }
      it { should == "Mem[||||||||||                                              4004/24105MB]" }
    end

    context '("Mem[%s]", 73, 0.16)' do
      let(:args) { ["Mem[%s]", 73, 0.16] }
      it { should == "Mem[|||||||||||                                                    16.0%]" }
    end

    context '"Mem[%s]", 73, 16' do
      let(:args) { ["Mem[%s]", 73, 16] }
      it { should == "Mem[|||||||||||                                                      16%]" }
    end

    ######################################################################
    ### invalid value

    context '("Mem[%s]", 73, -10)' do
      let(:args) { ["Mem[%s]", 73, -10] }
      it { should == "Mem[                                                                -10%]" }
    end

    context '("Mem[%s]", 73, -1.2)' do
      let(:args) { ["Mem[%s]", 73, -1.2] }
      it { should == "Mem[                                                             -120.0%]" }
    end

    context '("Mem[%s]", 73, [-10, 30])' do
      let(:args) { ["Mem[%s]", 73, [-10, 30]] }
      it { should == "Mem[                                                              -10/30]" }
    end

    context '("Mem[%s]", 73, 300)' do
      let(:args) { ["Mem[%s]", 73, 300] }
      it { should == "Mem[||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||300%]" }
    end

    context '("Mem[%s]", 73, 1.5)' do
      let(:args) { ["Mem[%s]", 73, 1.5] }
      it { should == "Mem[||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||150.0%]" }
    end

    context '("Mem[%s]", 73, [1000, 50])' do
      let(:args) { ["Mem[%s]", 73, [1000, 50]] }
      it { should == "Mem[|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||1000/50]" }
    end
  end
end
