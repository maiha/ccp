require "spec_helper"
require 'fileutils'

describe "Ccp::Commands::Core" do
  describe ".execute" do
    before do
      FileUtils.rm_rf("tmp")
    end

    context "(:fixture_save=>true)" do
      it "should generate read/write fixtures in tmp/fixtures as json files" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true}

        TSFC.execute(data.merge(opts))

        load_fixture(path + "tsfc/read.json" ).should == {"a" => "a"}
        load_fixture(path + "tsfc/write.json").should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true, :fixture_ext=>:yaml)" do
      it "should generate read/write fixtures in tmp/fixtures as yaml files" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_ext=>:yaml}

        TSFC.execute(data.merge(opts))

        load_fixture(path + "tsfc/read.yaml" ).should == {"a" => "a"}
        load_fixture(path + "tsfc/write.yaml").should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true, :fixture_kvs=>:dir)" do
      it "should generate json files in read/write dir" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_kvs=>:dir}

        TSFC.execute(data.merge(opts))

        load_fixture(path + "tsfc/read.json/a.json" ).should == "a"
        load_fixture(path + "tsfc/write.json/x.json").should == 10
      end
    end
  end
end
