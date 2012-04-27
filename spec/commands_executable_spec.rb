require "spec_helper"

describe Ccp::Commands::Executable do
  describe "#execute" do
    it "should call only execute" do
      cmd1 = Cmd1.new
      cmd1.data[:breadcrumbs] = []
      cmd1.execute
      cmd1.data[:breadcrumbs].should == ["Cmd1#execute"]
    end
  end

  describe ".execute" do
    it "should call {before,execute,after}" do
      cmd1 = Cmd1.execute(:breadcrumbs => [])
      cmd1.data[:breadcrumbs].should == ["Cmd1#before", "Cmd1#execute", "Cmd1#after"]
    end
  end
end
