require "spec_helper"
require 'fileutils'

describe "Ccp::Commands::Core" do
  describe ".execute" do
    before do
      FileUtils.rm_rf("tmp")
    end

    context "(:fixture_save=>true, :fixture_dir=>...)" do
      it "should generate stub/mock fixtures in <save_fixture_dir> as msgpack files" do
        path = Pathname("tmp/test/fixtures")
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true, :fixture_dir=>path.to_s}

        TSFC.execute(data.merge(opts))

        Ccp::Persistent::Dir.new(path + "tsfc/stub.msgpack", :msgpack).read.should == {"a" => "a"}
        Ccp::Persistent::Dir.new(path + "tsfc/mock.msgpack", :msgpack).read.should == {"x" => 10}
      end
    end

    context "(:fixture_save=>true) with hard coded" do
      it "should generate fixtures in given path" do
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true}

        begin
          TSFC.stub "tmp/tsfc/in.msgpack"
          TSFC.mock "tmp/tsfc/out.msgpack"

          TSFC.execute(data.merge(opts))
        ensure
          TSFC.stub nil
          TSFC.mock nil
        end

        Ccp::Persistent::Dir.new("tmp/tsfc/in.msgpack" , :msgpack).read.should == {"a" => "a"}
        Ccp::Persistent::Dir.new("tmp/tsfc/out.msgpack", :msgpack).read.should == {"x" => 10}
      end

      it "should generate stub/mock fixtures in <dir> as msgpack files" do
        data = {:a=>"a", :b=>"b", :x=>1, :y=>2}
        opts = {:fixture_save=>true}

        begin
          TSFC.dir "tmp/foo"

          TSFC.execute(data.merge(opts))
        ensure
          TSFC.dir nil
        end

        Ccp::Persistent::Dir.new("tmp/foo/tsfc/stub.msgpack", :msgpack).read.should == {"a" => "a"}
        Ccp::Persistent::Dir.new("tmp/foo/tsfc/mock.msgpack", :msgpack).read.should == {"x" => 10}
      end
    end
  end
end
