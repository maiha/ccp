require "spec_helper"
require 'fileutils'

describe Ccp::Invokers::Base do
  before do
    FileUtils.rm_rf("tmp")
  end

  class ULI < Ccp::Invokers::Base # UsingLoggerInvoker
    def execute
      data[:a]
      data[:logger]

      data[:x] = 10
      data[:logger] = Logger.new("/dev/null")
    end
  end

  describe ".execute" do
    context "(:fixture_save=>true)" do
      it "should ignore :logger in default" do
        ULI.execute(:a=>"a", :fixture_save=>true)

        Ccp::Persistent::Dir.new("tmp/fixtures/uli/stub.msgpack", :msgpack).read.should == {"a" => "a"}
        Ccp::Persistent::Dir.new("tmp/fixtures/uli/mock.msgpack", :msgpack).read.should == {"x" => 10}
      end
    end
  end
end
