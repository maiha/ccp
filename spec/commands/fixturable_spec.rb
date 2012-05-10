require "spec_helper"

describe Ccp::Commands::Core do
  subject { Class.new{include Ccp::Commands::Core} } 

  it { should include(Ccp::Commands::Fixturable) }
end

describe Ccp::Commands::Fixturable do
  context "Ccp::Commands::Core" do
    subject { Cmd1 }
    it { should respond_to("stub") }
    it { should respond_to("mock") }
    it { should respond_to("fail") }
    it { should respond_to("save") }
    it { should respond_to("keys") }
    it { should respond_to("dir") }
    it { should respond_to("kvs") }
    it { should respond_to("ext") }
    it { should respond_to("fixture") }
    its(:fixture) { should respond_to("options") }
  end

  context "Ccp::Commands::Composite" do
    subject { Program }
    it { should respond_to("stub") }
    it { should respond_to("mock") }
    it { should respond_to("fail") }
    it { should respond_to("save") }
    it { should respond_to("keys") }
    it { should respond_to("dir") }
    it { should respond_to("kvs") }
    it { should respond_to("ext") }
    it { should respond_to("fixture") }
    its(:fixture) { should respond_to("options") }
  end

  context "Ccp::Invokers::Base" do
    subject { CompositeInvoker }
    it { should respond_to("stub") }
    it { should respond_to("mock") }
    it { should respond_to("fail") }
    it { should respond_to("save") }
    it { should respond_to("keys") }
    it { should respond_to("dir") }
    it { should respond_to("kvs") }
    it { should respond_to("ext") }
    it { should respond_to("fixture") }
    its(:fixture) { should respond_to("options") }
  end

  context "included class" do
    subject { Class.new{include Ccp::Commands::Fixturable} } 
    it { should respond_to("stub") }
    it { should respond_to("mock") }
    it { should respond_to("fail") }
    it { should respond_to("save") }
    it { should respond_to("keys") }
    it { should respond_to("dir") }
    it { should respond_to("kvs") }
    it { should respond_to("ext") }
    it { should respond_to("fixture") }
    its(:fixture) { should respond_to("options") }
  end
end

