require "spec_helper"
require 'fileutils'

describe Ccp::Receivers::Fixtures do
  before do
    FileUtils.rm_rf("tmp")
  end

  module Example1
    class LoadInts
      include Ccp::Commands::Core
      def execute
        data[:ints] = [10,20,30]
      end
    end

    class CalculateMean
      include Ccp::Commands::Core
      def before
        data.check(:ints)
      end

      def execute
        data[:mean] = data[:ints].sum / data[:ints].size
      end
    end

    class Main < Ccp::Invokers::Base
      command LoadInts
      command CalculateMean
    end
  end

  describe ".execute" do
    context "(:fixture_save=>true, :fixture_kvs=>:dir, :fixture_ext=>:msgpack)" do
      before { @options = {:fixture_save=>true, :fixture_kvs=>:dir, :fixture_ext=>:msgpack} }

      it "should create stubs and mocks as dir" do
        Example1::Main.execute(@options)

        Pathname("tmp/fixtures/example1").should exist
        Dir["tmp/**/*.msgpack"].sort.should ==
          ["tmp/fixtures/example1/calculate_mean/mock.msgpack",
           "tmp/fixtures/example1/calculate_mean/mock.msgpack/mean.msgpack",
           "tmp/fixtures/example1/calculate_mean/stub.msgpack",
           "tmp/fixtures/example1/calculate_mean/stub.msgpack/ints.msgpack",
           "tmp/fixtures/example1/load_ints/mock.msgpack",
           "tmp/fixtures/example1/load_ints/mock.msgpack/ints.msgpack",
           "tmp/fixtures/example1/main/mock.msgpack",
           "tmp/fixtures/example1/main/mock.msgpack/ints.msgpack",
           "tmp/fixtures/example1/main/mock.msgpack/mean.msgpack",
           "tmp/fixtures/example1/main/stub.msgpack",
           "tmp/fixtures/example1/main/stub.msgpack/ints.msgpack"]
      end

      it "should pass all test" do
        Example1::Main.execute(@options)
        lambda {
          Example1::Main.test(:fixture_kvs=>:dir, :fixture_ext=>:msgpack)
        }.should_not raise_error
      end

      it "should pass partial test" do
        Example1::Main.execute(@options)
        lambda {
          Example1::CalculateMean.test(:fixture_kvs=>:dir, :fixture_ext=>:msgpack)
        }.should_not raise_error
      end
      
      it "should raise Typed::NotDefined when partial stub file is deleted" do
        Example1::Main.execute(@options)
        Pathname("tmp/fixtures/example1/calculate_mean/stub.msgpack/ints.msgpack").unlink
        lambda {
          Example1::CalculateMean.test(:fixture_kvs=>:dir, :fixture_ext=>:msgpack)
        }.should raise_error(Typed::NotDefined, /'ints' is not initialized/)
      end
    end
  end
end
