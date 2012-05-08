require "spec_helper"
require 'fileutils'

describe "Ccp::Commands::Core" do
  describe ".execute" do
    before do
      FileUtils.rm_rf("tmp")
    end

    context "(:fixture_save=>true)" do
      it "should generate stub/mock fixtures in tmp/fixtures as json files" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true}

        TSFC.execute(data.merge(opts))

        load_fixture(path + "tsfc/stub.json").should == {"a" => "a"}
        load_fixture(path + "tsfc/mock.json").should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true, :fixture_ext=>:yaml)" do
      it "should generate stub/mock fixtures in tmp/fixtures as yaml files" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_ext=>:yaml}

        TSFC.execute(data.merge(opts))

        load_fixture(path + "tsfc/stub.yaml" ).should == {"a" => "a"}
        load_fixture(path + "tsfc/mock.yaml").should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true, :fixture_kvs=>:dir)" do
      it "should generate json files in stub/mock dir" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_kvs=>:dir}

        TSFC.execute(data.merge(opts))

        load_fixture(path + "tsfc/stub.json/a.json" ).should == "a"
        load_fixture(path + "tsfc/mock.json/x.json").should == 10
      end
    end
  end
end
