require "spec_helper"

describe Ccp::Invokers::Base do
  def no_logger; Logger.new('/dev/null'); end

  describe "#execute" do
    it "should call its execute and sub commands's {before,execute,after} in declared order" do
      c = CompositeInvoker.new
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

  describe "#benchmark" do
    it "should call its and sub commands's {before,execute,after} in declared order" do
      c = CompositeInvoker.new
      c.data[:breadcrumbs] = []
      c.benchmark
      c.data[:breadcrumbs].should ==
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

  describe ".execute" do
    it "should call its and sub commands's {before,execute,after} in declared order" do
      c = CompositeInvoker.execute(:breadcrumbs => [])
      c.data[:breadcrumbs].should ==
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

    it "should call only show_comments in default" do
      r = Ccp::Receivers::Base.new
      r.should_receive(:show_comments).once
      r.should_receive(:show_profiles).never
      CompositeInvoker.execute(:receiver => r, :breadcrumbs => [])
    end

    it "should call show_profiles if :profile option is given" do
      r = Ccp::Receivers::Base.new
      r.should_receive(:show_profiles).once
      CompositeInvoker.execute(:receiver => r, :breadcrumbs => [], :profile => true)
    end

    it "should disable show_comments if :comment option is false" do
      r = Ccp::Receivers::Base.new
      r.should_receive(:show_comments).never
      CompositeInvoker.execute(:receiver => r, :breadcrumbs => [], :comment => false)
    end
  end

  describe ".benchmark" do
    it "should call its and sub commands's {before,execute,after} in declared order" do
      r = Ccp::Receivers::Base.new
      r.stub!(:show_comments)   # disable output
      r.stub!(:show_profiles)   # disable output

      c = CompositeInvoker.benchmark(:receiver => r, :breadcrumbs => [])
      c.data[:breadcrumbs].should ==
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

    it "should call only show_comments in default" do
      r = Ccp::Receivers::Base.new
      r.should_receive(:show_comments).once
      r.should_receive(:show_profiles).once
      CompositeInvoker.benchmark(:receiver => r, :breadcrumbs => [])
    end

    it "should disable show_profiles if :profile option is false" do
      r = Ccp::Receivers::Base.new
      r.should_receive(:show_comments).once
      r.should_receive(:show_profiles).never
      CompositeInvoker.benchmark(:receiver => r, :breadcrumbs => [], :profile => false)
    end

    it "should disable show_comments if :comment option is false" do
      r = Ccp::Receivers::Base.new
      r.should_receive(:show_comments).never
      r.should_receive(:show_profiles).once
      CompositeInvoker.benchmark(:receiver => r, :breadcrumbs => [], :comment => false)
    end
  end
end


