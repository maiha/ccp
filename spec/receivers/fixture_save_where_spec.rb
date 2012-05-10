require "spec_helper"
require 'fileutils'

describe "Ccp::Commands::Core" do
  describe ".execute" do
    before do
      FileUtils.rm_rf("tmp")
    end

    context "(:fixture_save=>true, :fixture_dir=>...)" do
      it "should generate stub/mock fixtures in <save_fixture_dir> as json files" do
        path = Pathname("tmp/test/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_dir=>path.to_s}

        TSFC.execute(data.merge(opts))

        load_fixture(path + "tsfc/stub.json").should == {"a" => "a"}
        load_fixture(path + "tsfc/mock.json").should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true) with hard coded" do
      it "should generate fixtures in given path" do
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true}

        begin
          TSFC.stub "tmp/tsfc/in.json"
          TSFC.mock "tmp/tsfc/out.json"

          TSFC.execute(data.merge(opts))
        ensure
          TSFC.stub nil
          TSFC.mock nil
        end

        load_fixture("tmp/tsfc/in.json").should == {"a" => "a"}
        load_fixture("tmp/tsfc/out.json").should == {"x" => 10}
      end

      it "should generate stub/mock fixtures in <dir> as json files" do
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true}

        begin
          TSFC.dir "tmp/foo"

          TSFC.execute(data.merge(opts))
        ensure
          TSFC.dir nil
        end

        load_fixture("tmp/foo/tsfc/stub.json").should == {"a" => "a"}
        load_fixture("tmp/foo/tsfc/mock.json").should == {"x" => 10}
      end
    end
  end
end
