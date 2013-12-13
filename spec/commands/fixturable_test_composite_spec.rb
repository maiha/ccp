require "spec_helper"

describe Ccp::Receivers::Fixtures do
  before do
    FileUtils.rm_rf("tmp/fixtures")
    FileUtils.mkdir_p("tmp/fixtures")
  end

  class CRFC1
    def execute
      data[:a] = 1
    end
  end

  class CRFC2
    def execute
      data[:b] = 2
    end
  end

  class CRFCC
    include Ccp::Commands::Composite
    command CRFC1
    command CRFC2
  end

  describe CRFCC do
    describe ".test" do
      it "should test CRFC1, CRFC2, CRFF in order" do
        lambda {
          CRFCC.test
        }.should raise_error(Ccp::Fixtures::NotFound, "tmp/fixtures/crfc1/mock.msgpack")

        save_fixture("tmp/fixtures/crfc1/mock.msgpack", "a"=>1)
        lambda {
          CRFCC.test
        }.should raise_error(Ccp::Fixtures::NotFound, "tmp/fixtures/crfc2/mock.msgpack")

        save_fixture("tmp/fixtures/crfc2/mock.msgpack", "b"=>2)
        lambda {
          CRFCC.test
        }.should raise_error(Ccp::Fixtures::NotFound, "tmp/fixtures/crfcc/mock.msgpack")

        save_fixture("tmp/fixtures/crfcc/mock.msgpack", {})
        lambda {
          CRFCC.test
        }.should_not raise_error
      end

      context "(:fixture_test=>'CRFC2')" do
        it "should test only CRFC2" do
          lambda {
            CRFCC.test(:fixture_test=>'CRFC2')
          }.should raise_error(Ccp::Fixtures::NotFound, "tmp/fixtures/crfc2/mock.msgpack")
        end
      end
    end

    describe ".execute" do
      context "(:fixture_test=>true)" do
        it "should test CRFC1, CRFC2, CRFF in order" do
          lambda {
            CRFCC.execute(:fixture_test=>true)
          }.should raise_error(Ccp::Fixtures::NotFound, "tmp/fixtures/crfc1/mock.msgpack")

          save_fixture("tmp/fixtures/crfc1/mock.msgpack", "a"=>1)
          lambda {
            CRFCC.execute(:fixture_test=>true)
          }.should raise_error(Ccp::Fixtures::NotFound, "tmp/fixtures/crfc2/mock.msgpack")

          save_fixture("tmp/fixtures/crfc2/mock.msgpack", "b"=>2)
          lambda {
            CRFCC.execute(:fixture_test=>true)
          }.should raise_error(Ccp::Fixtures::NotFound, "tmp/fixtures/crfcc/mock.msgpack")

          save_fixture("tmp/fixtures/crfcc/mock.msgpack", {})
          lambda {
            CRFCC.execute(:fixture_test=>true)
          }.should_not raise_error
        end
      end

      context "(:fixture_test=>'CRFC2')" do
        it "should test only CRFC2" do
          lambda {
            CRFCC.execute(:fixture_test=>'CRFC2')
          }.should raise_error(Ccp::Fixtures::NotFound, "tmp/fixtures/crfc2/mock.msgpack")
        end
      end

    end
  end
end
