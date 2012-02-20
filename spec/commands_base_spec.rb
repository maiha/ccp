require "spec_helper"

describe Ccp::Commands::Base do
  describe "#initialize" do
    it "should accept *args" do
      lambda {
        Ccp::Commands::Base.new
        Ccp::Commands::Base.new(1)
        Ccp::Commands::Base.new(:a, "str", {1=>[]})
      }.should_not raise_error
    end
  end

  describe "#args" do
    it "should return args" do
      cmd = Ccp::Commands::Base.new("data.db", :adapter=>"sqlite", :type=>"kvs")
      cmd.args.should == ["data.db", {:adapter=>"sqlite", :type=>"kvs"}]
    end
  end
end
