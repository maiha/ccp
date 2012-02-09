require "spec_helper"

describe Ccp::Commands::Core do
  subject { Object.new.extend Ccp::Commands::Core } 

  # data container
  it { should respond_to(:data?) }
  it { should respond_to(:data) }
  its(:data) { should be_kind_of(Ccp::Data::KVS) }

  # executable
  it { should respond_to(:execute) }
  it { should respond_to(:benchmark) }

  # receivable
  it { should respond_to(:receiver) }
  its(:receiver) { should be_kind_of(Ccp::Receivers::Base) }
end
