require "spec_helper"

describe Ccp::Commands::Fixturable do
  subject { Class.new{include Ccp::Commands::Fixturable} } 

  it { should respond_to("stub") }
  it { should respond_to("mock") }
end

__END__

describe Ccp::Commands::Core do
  subject { Class.new{include Ccp::Commands::Core} } 

  it { should include(Ccp::Commands::Fixturable) }

  class Cmd1Fixturable < Cmd1
    stub "tmp/spec/commands/fixturable/stub.json"
  end

  it "should stub data" do
    stub = Pathname("tmp/spec/commands/fixturable/stub.json")
    truncate_pathname(stub.parent)
    save_fixture(stub, "breadcrumbs"=>[])

    lambda {
      Cmd1.execute
    }.should raise_error(Typed::NotDefined)

    lambda {
      Cmd1Fixturable.execute
    }.should_not raise_error
  end
end

__END__

describe Ccp::Commands::Core do
  subject { Class.new{include Ccp::Commands::Core} } 

  it { should include(Ccp::Commands::Fixturable) }

  class Cmd1Fixturable < Cmd1
    stub "tmp/spec/commands/fixturable/stub.json"
  end

  it "should stub data" do
    path = truncate_pathname("tmp/spec/commands/fixturable")
    save_fixture(path + "stub.json", "breadcrumbs"=>[])

    lambda {
      Cmd1.execute
    }.should raise_error(Typed::NotDefined)

    lambda {
      Cmd1Fixturable.execute
    }.should_not raise_error
  end
end
