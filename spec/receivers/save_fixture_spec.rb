require "spec_helper"

describe Ccp::Commands::Base do
  describe ".execute(:save_fixture=>true)" do
    class TSFC                  # TestSaveFixtureCmd
      include Ccp::Commands::Core

      def execute
        data[:a]                # read
        data[:x] = 10           # write
      end
    end

    def load_yaml(path)
      YAML.load(Pathname(path).read{})
    end

    def truncate(path)
      require 'fileutils'
      FileUtils.rm_rf(path.to_s)
    end

    it "should generate in/out fixtures in tmp/fixtures" do
      path = Pathname("tmp/fixtures")
      data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
      opts = {:save_fixture=>true}

      truncate(path)
      TSFC.execute(data.merge(opts))

      load_yaml(path + "tsfc/in.yaml" ).should == {:a=>"a"}
      load_yaml(path + "tsfc/out.yaml").should == {:x=>10}
    end

    it "should generate in/out fixtures in <save_fixture_dir>" do
      path = Pathname("tmp/test/fixtures")
      data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
      opts = {:save_fixture=>true, :save_fixture_dir=>path}

      truncate(path)
      TSFC.execute(data.merge(opts))

      load_yaml(path + "tsfc/in.yaml" ).should == {:a=>"a"}
      load_yaml(path + "tsfc/out.yaml").should == {:x=>10}
    end
  end
end
