require "spec_helper"

describe Ccp::Receivers::Fixtures do
  context "Ccp::Commands::Core" do
    subject { Cmd1 }
    it { should respond_to("stub") }
    it { should respond_to("mock") }
    it { should respond_to("fail") }
  end

  context "Ccp::Commands::Composite" do
    subject { Program }
    it { should respond_to("stub") }
    it { should respond_to("mock") }
    it { should respond_to("fail") }
  end

  context "Ccp::Invokers::Base" do
    subject { CompositeInvoker }
    it { should respond_to("stub") }
    it { should respond_to("mock") }
    it { should respond_to("fail") }
  end
end

describe Ccp::Receivers::Fixtures do
  context "(stub)" do
    class Cmd1Stub < Cmd1
      stub "spec/fixtures/stub/breadcrumbs.json"
    end

    it "should merge given data file into data variable" do
      lambda {
        Cmd1.execute
      }.should raise_error(Typed::NotDefined)

      lambda {
        Cmd1Stub.execute
      }.should_not raise_error
    end
  end

  context "(stub and mock)" do
    class Cmd1StubMock < Cmd1
      stub "spec/fixtures/stub/breadcrumbs.json"
      mock "spec/fixtures/cmd1stub_mock/mock.json"
    end

    it "should raise when current data doesn't match the given data" do
      lambda {
        Cmd1StubMock.execute
      }.should_not raise_error
    end
  end

  context "(stub and invalid mock)" do
    class Cmd1StubInvalidMock < Cmd1
      stub "spec/fixtures/stub/breadcrumbs.json"
      mock "spec/fixtures/stub/breadcrumbs.json"
    end

    it "should raise when current data doesn't match the given data" do
      lambda {
        Cmd1StubInvalidMock.execute
      }.should raise_error(/should create/)
    end
  end

  context "(stub and mock and fail)" do
    class Cmd1StubInvalidMockWithFail < Cmd1
      dsl_accessor :failed, false

      stub "spec/fixtures/stub/breadcrumbs.json"
      mock "spec/fixtures/stub/breadcrumbs.json"

      fail do |cmd, key, expected, got|
        Cmd1StubInvalidMockWithFail.failed true
      end
    end

    it "should raise when current data doesn't match the given data" do
      Cmd1StubInvalidMockWithFail.failed.should == false
      Cmd1StubInvalidMockWithFail.execute
      Cmd1StubInvalidMockWithFail.failed.should == true
    end
  end
end
