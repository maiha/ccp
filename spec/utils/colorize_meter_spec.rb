# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Utils::Colorize::Meter do
  delegate :strip, :to=>"Ccp::Utils::Colorize"
  delegate :percent, :to=>"Ccp::Utils::Colorize::Meter"

  ######################################################################
  ### API

  subject { Ccp::Utils::Colorize::Meter }
  it { should respond_to(:percent) }

  ######################################################################
  ### Percent

  describe ".percent" do
    subject { strip(percent(*args)) }
    let(:colors) { [:green, :blue, :yellow] }
    let(:chars) { ['|','x','-', ' '] }
    let(:vals)   { [10,8,71] }
    let(:fmt)    { "Mem[%s24G]" }
    let(:size)   { 75 }
    def args; [fmt, size, vals, colors, chars]; end
    
    context 'normal' do
      it { should == "Mem[|||||||xxxxxx------------------------------------------------      24G]" }
    end

    context "(chars:['|'])" do
      let(:chars) { ['|'] }
      it { should == "Mem[|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||      24G]" }
    end

    ######################################################################
    ### bound error

    context '(percent exceeds 100%)' do
      let(:vals)   { [10,8,100] }
      it { should == "Mem[|||||||xxxxxx------------------------------------------------------24G]" }
    end

    context '(percent contains minus value)' do
      let(:vals)   { [10,-8,71] }
      it { should == "Mem[|||||||------------------------------------------------            24G]" }
    end
  end
end
