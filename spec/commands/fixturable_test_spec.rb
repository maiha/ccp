require "spec_helper"

describe Ccp::Commands::Fixturable do
  before do
    @stub = Pathname("tmp/fixtures/square_cmd/stub.msgpack")
    @mock = Pathname("tmp/fixtures/square_cmd/mock.msgpack")
    @stub.parent.mkpath
    save_fixture(@stub, "x"=>10)
    save_fixture(@mock, "x"=>100)
  end

  after do
    FileUtils.rm_rf("tmp/fixtures")
  end

  class SquareCmd
    include Ccp::Commands::Core
    def execute
      data[:x] = data[:x] * data[:x]
    end
  end

  class SquareCmdPass < SquareCmd
    stub "tmp/fixtures/square_cmd/stub.msgpack"
    mock "tmp/fixtures/square_cmd/mock.msgpack"
  end

  class SquareCmdFail < SquareCmd
    stub "tmp/fixtures/square_cmd/stub.msgpack"
    mock "tmp/fixtures/square_cmd/mock.msgpack"

    def execute
      data[:x] = data[:x] + 1
    end
  end

  describe ".test" do
    it "should use stub automatically if exists" do
      cmd = SquareCmd.test
      cmd.data[:x].should == 100
    end

    it "should use mock automatically" do
      save_fixture(@mock, "x"=>1)

      lambda {
        SquareCmd.test
      }.should raise_error(Ccp::Failed)
    end

    it "should raise Fixtures::NotFound if mock doesn't exist" do
      @mock.unlink

      lambda {
        SquareCmd.test
      }.should raise_error(Ccp::Fixtures::NotFound)
    end

    context "(pass case)" do
      it "should raise nothing" do
        cmd = SquareCmdPass.test
        cmd.data[:x].should == 100
      end
    end

    context "(fail case)" do
      it "should raise RuntimeError" do
        failed = nil
        SquareCmdFail.stub @stub
        SquareCmdFail.mock @mock

        lambda {
          SquareCmdFail.test
        }.should raise_error(Ccp::Failed)
      end

      it "should call fail handler if given" do
        failed = nil
        SquareCmdFail.stub @stub
        SquareCmdFail.mock @mock
        SquareCmdFail.fail {|cmd, key, expected, got|
          failed = key
        }
        
        lambda {
          SquareCmdFail.test
        }.should_not raise_error
        failed.should == "x"
      end
    end
  end
end
