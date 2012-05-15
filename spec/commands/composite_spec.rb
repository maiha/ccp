require "spec_helper"

describe Ccp::Commands::Composite do
  describe "(instance)" do
    subject { Program.new }

    # data container
    it { should respond_to(:data?) }
    it { should respond_to(:data) }
    its(:data) { should be_kind_of(Typed::Hash) }

    # executable
    it { should respond_to(:execute) }

    # receivable
    it { should respond_to(:receiver) }
    its(:receiver) { should be_kind_of(Ccp::Receivers::Base) }
  end
end

describe Ccp::Commands::Composite do
  describe "#execute" do
    it "should call its execute and sub commands's {before,execute,after} in declared order" do
      c = Program.new
      c.data[:breadcrumbs] = []
      c.execute
      c.data[:breadcrumbs].should ==
        ["Cmd1#before", "Cmd1#execute", "Cmd1#after",
         "Cmd2#before", "Cmd2#execute", "Cmd2#after",
         "Cmd3#before", "Cmd3#execute", "Cmd3#after"]
    end
  end

  describe ".execute" do
    it "should call its and sub commands's {before,execute,after} in declared order" do
      c = Program.execute(:receiver=>breadcrumbs_receiver)
      c.data[:breadcrumbs].should ==
        ["Program#before",
         "Cmd1#before", "Cmd1#execute", "Cmd1#after",
         "Cmd2#before", "Cmd2#execute", "Cmd2#after",
         "Cmd3#before", "Cmd3#execute", "Cmd3#after",
         "Program#after"]
    end
  end

  describe ".command" do
    ArgedCmd = Struct.new(:a,:b,:c) {
      include Ccp::Commands::Core
      def execute
        data[:args] = [a,b,c]
      end
    }

    it "should pass given args to initializer" do
      parent = Class.new { include Ccp::Commands::Composite
        command ArgedCmd
      }.new
      parent.execute
      parent.data[:args].should == [nil,nil,nil]

      parent = Class.new { include Ccp::Commands::Composite
        command ArgedCmd, 1, "x"
      }.new
      parent.execute
      parent.data[:args].should == [1, "x", nil]
    end

    it "should ignore same commands" do
      composite = Class.new { include Ccp::Commands::Composite
        command ArgedCmd
        command ArgedCmd
      }
      composite.commands.size.should == 1
    end

    it "should distinct command's args" do
      composite = Class.new { include Ccp::Commands::Composite
        command ArgedCmd
        command ArgedCmd, 1
      }
      composite.commands.size.should == 2
    end
  end
end

describe "Ccp::Commands::Composite(nested)" do
  describe "#execute" do
    it "should call its execute and sub commands's {before,execute,after} in declared order" do
      c = CompositeProgram.new
      c.data[:breadcrumbs] = []
      c.execute
      c.data[:breadcrumbs].should ==
        ["Cmd1#before", "Cmd1#execute", "Cmd1#after",
         "Cmd23#before",
         "Cmd23#execute:start",
         "Cmd2#before", "Cmd2#execute", "Cmd2#after",
         "Cmd3#before", "Cmd3#execute", "Cmd3#after",
         "Cmd23#execute:end",
         "Cmd23#after",
         "Cmd4#before", "Cmd4#execute", "Cmd4#after"]
    end
  end

  describe ".execute" do
    it "should call its and sub commands's {before,execute,after} in declared order" do
      c = CompositeProgram.execute(:receiver=>breadcrumbs_receiver)
      c.data[:breadcrumbs].should ==
        ["CompositeProgram#before",
         "Cmd1#before", "Cmd1#execute", "Cmd1#after",
         "Cmd23#before",
         "Cmd23#execute:start",
         "Cmd2#before", "Cmd2#execute", "Cmd2#after",
         "Cmd3#before", "Cmd3#execute", "Cmd3#after",
         "Cmd23#execute:end",
         "Cmd23#after",
         "Cmd4#before", "Cmd4#execute", "Cmd4#after",
         "CompositeProgram#after"]
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
