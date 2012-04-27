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

    # receivable
    it { should respond_to(:receiver) }
    its(:receiver) { should be_kind_of(Ccp::Receivers::Base) }

    it "should ignore nil for receiver values" do
      subject.receiver = nil
      subject.receiver.should be_kind_of(Ccp::Receivers::Base)
    end
  end

  describe "#execute" do
    it "should call only execute" do
      cmd1 = Cmd1.new
      cmd1.data[:breadcrumbs] = []
      cmd1.execute
      cmd1.data[:breadcrumbs].should == ["Cmd1#execute"]
    end
  end
end
