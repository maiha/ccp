require "spec_helper"

describe Ccp::Commands::Composite do
  describe "#execute" do
    it "should call its execute and sub commands's {pre,execute,post} in declared order" do
      c = Program.new
      c.data[:breadcrumbs] = []
      c.execute
      c.data[:breadcrumbs].should ==
        ["Cmd1#pre", "Cmd1#execute", "Cmd1#post",
         "Cmd2#pre", "Cmd2#execute", "Cmd2#post",
         "Cmd3#pre", "Cmd3#execute", "Cmd3#post"]
    end
  end

  describe "#benchmark" do
    it "should call its and sub commands's {pre,execute,post} in declared order" do
      c = Program.new
      c.data[:breadcrumbs] = []
      c.benchmark
      c.data[:breadcrumbs].should ==
        ["Program#pre",
         "Cmd1#pre", "Cmd1#execute", "Cmd1#post",
         "Cmd2#pre", "Cmd2#execute", "Cmd2#post",
         "Cmd3#pre", "Cmd3#execute", "Cmd3#post",
         "Program#post"]
    end
  end
end

describe "Ccp::Commands::Composite(nested)" do
  describe "#execute" do
    it "should call its execute and sub commands's {pre,execute,post} in declared order" do
      c = CompositeProgram.new
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
    it "should call its and sub commands's {pre,execute,post} in declared order" do
      c = CompositeProgram.new
      c.data[:breadcrumbs] = []
      c.benchmark
      c.data[:breadcrumbs].should ==
        ["CompositeProgram#pre",
         "Cmd1#pre", "Cmd1#execute", "Cmd1#post",
         "Cmd23#pre",
         "Cmd23#execute:start",
         "Cmd2#pre", "Cmd2#execute", "Cmd2#post",
         "Cmd3#pre", "Cmd3#execute", "Cmd3#post",
         "Cmd23#execute:end",
         "Cmd23#post",
         "Cmd4#pre", "Cmd4#execute", "Cmd4#post",
         "CompositeProgram#post"]
    end
  end

  it "should update receiver recursively" do
    cmd = CompositeProgram.new
    cmd.commands.each do |c|
      c.receiver.should == cmd.receiver
    end

    new_receiver = Ccp::Receivers::Base.new
    new_receiver.should_not == cmd.receiver

    # update receiver
    cmd.receiver = new_receiver
    cmd.commands.each do |c|
      c.receiver.should == cmd.receiver
    end
  end
end
