require "spec_helper"

describe Ccp::Commands::Core do
  describe "(accessor)" do
    subject { Object.new.extend Ccp::Commands::Core } 

    # data container
    it { should respond_to(:data?) }
    it { should respond_to(:data) }
    its(:data) { should be_kind_of(Typed::Hash) }

    # executable
    it { should respond_to(:execute) }
    it { should respond_to(:benchmark) }

    # receivable
    it { should respond_to(:receiver) }
    its(:receiver) { should be_kind_of(Ccp::Receivers::Base) }
  end

  describe "#execute" do
    it "should call only execute" do
      cmd1 = Cmd1.new
      cmd1.data[:breadcrumbs] = []
      cmd1.execute
      cmd1.data[:breadcrumbs].should == ["Cmd1#execute"]
    end
  end

  describe "#benchmark" do
    it "should call {before,execute,after}" do
      cmd1 = Cmd1.new
      cmd1.data[:breadcrumbs] = []
      cmd1.benchmark
      cmd1.data[:breadcrumbs].should == ["Cmd1#before", "Cmd1#execute", "Cmd1#after"]
    end

    it "should call receiver.profile" do
      (receiver = Ccp::Receivers::Base.new).should_receive(:profile)

      cmd1 = Cmd1.new
      cmd1.receiver = receiver
      cmd1.data[:breadcrumbs] = []
      cmd1.benchmark
    end
  end
end
