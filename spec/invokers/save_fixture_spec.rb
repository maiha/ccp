require "spec_helper"
require 'fileutils'

describe Ccp::Invokers::Base do
  describe ".execute" do
    before do
      FileUtils.rm_rf("tmp")
    end

    context "(:fixture_save=>true)" do
      it "should generate stub/mock fixtures in tmp/fixtures as msgpack files" do
        path = Pathname("tmp/fixtures")
        data = {:breadcrumbs => []}
        opts = {:fixture_save=>true}

        CompositeInvoker.execute(data.merge(opts))

        stub = path + "composite_invoker/stub.msgpack"
        stub.should exist
        load_fixture("#{stub}/breadcrumbs.msgpack").should ==
          ["CompositeInvoker#before",
           "Cmd1#before", "Cmd1#execute", "Cmd1#after",
           "Cmd23#before",
           "Cmd23#execute:start",
           "Cmd2#before", "Cmd2#execute", "Cmd2#after",
           "Cmd3#before", "Cmd3#execute", "Cmd3#after",
           "Cmd23#execute:end",
           "Cmd23#after",
           "Cmd4#before", "Cmd4#execute", "Cmd4#after",
           "CompositeInvoker#after"]
      end
    end
  end
end
