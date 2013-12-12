require "spec_helper"
require 'fileutils'

describe "Ccp::Commands::Core" do
  describe ".execute" do
    before do
      FileUtils.rm_rf("tmp")
    end

    context "(:fixture_save=>true, :fixture_ext=>:msgpack)" do
      it "should generate stub/mock fixtures in tmp/fixtures as yaml files" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_ext=>:msgpack}

        TSFC.execute(data.merge(opts))

        load_fixture(path + "tsfc/stub.msgpack").should == {"a" => "a"}
        load_fixture(path + "tsfc/mock.msgpack").should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true, :fixture_ext=>:msgpack, :fixture_kvs=>:dir)" do
      it "should generate stub/mock fixtures in tmp/fixtures as yaml files" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_ext=>:msgpack, :fixture_kvs=>:dir}

        TSFC.execute(data.merge(opts))

        load_fixture(path + "tsfc/stub.msgpack/a.msgpack").should == "a"
        load_fixture(path + "tsfc/mock.msgpack/x.msgpack").should == 10
      end
    end
  end
end
