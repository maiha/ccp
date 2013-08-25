# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Utils::Colorize do
  let(:text) { "hello" }

  subject {
    # methods
    object.black(text)  .should be_kind_of(String)
    object.red(text)    .should be_kind_of(String)
    object.green(text)  .should be_kind_of(String)
    object.yellow(text) .should be_kind_of(String)
    object.blue(text)   .should be_kind_of(String)
    object.magenta(text).should be_kind_of(String)
    object.purple(text) .should be_kind_of(String)
    object.pink(text)   .should be_kind_of(String)
    object.cyan(text)   .should be_kind_of(String)
    object.aqua(text)   .should be_kind_of(String)
    object.white(text)  .should be_kind_of(String)

    # alias
    object.purple(text).should == object.magenta(text)
    object.pink(text)  .should == object.magenta(text)
    object.aqua(text)  .should == object.cyan(text)
  }

  context "(static)" do
    subject { Ccp::Utils::Colorize }
    it { should be }
  end

  context "(include)" do
    subject { Object.new.extend(Ccp::Utils::Colorize) }
    it { should be }
  end

  context "(fore)" do
    subject { Ccp::Utils::Colorize::Fore }
    it { should be }
  end

  context "(fore include)" do
    subject { Object.new.extend(Ccp::Utils::Colorize::Fore) }
    it { should be }
  end

  context "(back)" do
    subject { Ccp::Utils::Colorize::Back }
    it { should be }
  end

  context "(back include)" do
    subject { Object.new.extend(Ccp::Utils::Colorize::Back) }
    it { should be }
  end
end
