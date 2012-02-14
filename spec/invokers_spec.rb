require "spec_helper"

describe Ccp::Invokers::Base do
  describe "#execute" do
    it "should call sub commands's {pre,execute,post} in declared order" do
      c = CompositeInvoker.new
      c.data[:breadcrumbs] = []
      c.execute
      c.data[:breadcrumbs].should ==
        ["Cmd1#pre", "Cmd1#execute", "Cmd1#post",
         "Cmd23#pre",
         "Cmd23#execute:start",
         "Cmd2#pre", "Cmd2#execute", "Cmd2#post",
         "Cmd3#pre", "Cmd3#execute", "Cmd3#post",
         "Cmd23#execute:end",
         "Cmd23#post",
         "Cmd4#pre", "Cmd4#execute", "Cmd4#post"]
    end
  end

  describe "#benchmark" do
    it "should call sub commands's {pre,execute,post} in declared order" do
      c = CompositeInvoker.new
      c.data[:breadcrumbs] = []
      c.benchmark
      c.data[:breadcrumbs].should ==
        ["Cmd1#pre", "Cmd1#execute", "Cmd1#post",
         "Cmd23#pre",
         "Cmd23#execute:start",
         "Cmd2#pre", "Cmd2#execute", "Cmd2#post",
         "Cmd3#pre", "Cmd3#execute", "Cmd3#post",
         "Cmd23#execute:end",
         "Cmd23#post",
         "Cmd4#pre", "Cmd4#execute", "Cmd4#post"]
    end
  end
end


