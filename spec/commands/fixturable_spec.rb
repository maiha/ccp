require "spec_helper"

describe Ccp::Commands::Fixturable do
  subject { Class.new{include Ccp::Commands::Fixturable} } 

  it { should respond_to("stub") }
  it { should respond_to("mock") }
end

describe Ccp::Commands::Core do
  subject { Class.new{include Ccp::Commands::Core} } 

  it { should include(Ccp::Commands::Fixturable) }
end
