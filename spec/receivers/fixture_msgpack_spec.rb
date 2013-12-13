require "spec_helper"
require 'fileutils'

describe "Ccp::Commands::Core" do
  describe ".execute" do
    before do
      FileUtils.rm_rf("tmp")
    end

    context "(:fixture_save=>true, :fixture_ext=>:msgpack, :fixture_kvs=>:file)" do
      it "should generate stub/mock fixtures in tmp/fixtures as yaml files" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_ext=>:msgpack, :fixture_kvs=>:file}

        TSFC.execute(data.merge(opts))

        Ccp::Persistent::File.new(path + "tsfc/stub.msgpack", :msgpack).read.should == {"a" => "a"}
        Ccp::Persistent::File.new(path + "tsfc/mock.msgpack", :msgpack).read.should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true, :fixture_ext=>:msgpack, :fixture_kvs=>:dir)" do
      it "should generate stub/mock fixtures in tmp/fixtures as yaml files" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_ext=>:msgpack, :fixture_kvs=>:dir}

        TSFC.execute(data.merge(opts))

        Ccp::Persistent::Dir.new(path + "tsfc/stub.msgpack", :msgpack).read.should == {"a" => "a"}
        Ccp::Persistent::Dir.new(path + "tsfc/mock.msgpack", :msgpack).read.should == {"x" => 10}
      end
    end
  end
end
