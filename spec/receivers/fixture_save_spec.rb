require "spec_helper"
require 'fileutils'

describe Ccp::Receivers::Fixtures do
  class TSFC                  # TestSaveFixtureCmd
    include Ccp::Commands::Core

    def execute
      data[:a]                # read
      data[:x] = 10           # write
    end
  end

  def load(path)
    case path.extname
    when ".json"; JSON.load(Pathname(path).read{})
    when ".yaml"; YAML.load(Pathname(path).read{})
    else; raise "load doesn't support #{path.extname}"
    end
  end

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

        load(path + "tsfc/read.json" ).should == {"a" => "a"}
        load(path + "tsfc/write.json").should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true, :fixture_ext=>:yaml)" do
      it "should generate read/write fixtures in tmp/fixtures as yaml files" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_ext=>:yaml}

        TSFC.execute(data.merge(opts))

        load(path + "tsfc/read.yaml" ).should == {"a" => "a"}
        load(path + "tsfc/write.yaml").should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true, :fixture_dir=>...)" do
      it "should generate read/write fixtures in <save_fixture_dir> as json files" do
        path = Pathname("tmp/test/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_dir=>path.to_s}

        TSFC.execute(data.merge(opts))

        load(path + "tsfc/read.json" ).should == {"a" => "a"}
        load(path + "tsfc/write.json").should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true, :fixture_kvs=>:dir)" do
      it "should generate json files in read/write dir" do
        path = Pathname("tmp/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_kvs=>:dir}

        TSFC.execute(data.merge(opts))

        load(path + "tsfc/read.json/a.json" ).should == "a"
        load(path + "tsfc/write.json/x.json").should == 10
      end
    end
  end
end
