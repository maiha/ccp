require "spec_helper"

describe Ccp::Receivers::Skippable do
  let(:options) { {:breadcrumbs => []} }
  let(:program) { Program }
  let(:data)    { program.execute(options).data }

  def breadcrumbs
    data[:breadcrumbs]
  end

  describe "#execute" do
    context "(standard case)" do
      it "should execute normally" do
        breadcrumbs.should == ["Program#before", "Cmd1#before", "Cmd1#execute", "Cmd1#after", "Cmd2#before", "Cmd2#execute", "Cmd2#after", "Cmd3#before", "Cmd3#execute", "Cmd3#after", "Program#after"]
      end
    end

    context "(:skip_cmd1 given)" do
      before { options[:skip_cmd1] = true }
      it "should execute without Cmd1" do
        breadcrumbs.should == ["Program#before", "Cmd2#before", "Cmd2#execute", "Cmd2#after", "Cmd3#before", "Cmd3#execute", "Cmd3#after", "Program#after"]
      end
    end

    context "(:skip_cmd1, :skip_cmd3 given)" do
      before { options[:skip_cmd1] = true; options[:skip_cmd3] = true }
      it "should execute without Cmd1 and Cmd3" do
        breadcrumbs.should == ["Program#before", "Cmd2#before", "Cmd2#execute", "Cmd2#after", "Program#after"]
      end
    end

    context "(:skip_program(top level cmd) given)" do
      before { options[:skip_program] = true }
      it "should execute nothing" do
        breadcrumbs.should == []
      end
    end

    context "(non-matched skip key given)" do
      before { options[:skip_XXX] = true }
      it "should execute normally" do
        breadcrumbs.should == ["Program#before", "Cmd1#before", "Cmd1#execute", "Cmd1#after", "Cmd2#before", "Cmd2#execute", "Cmd2#after", "Cmd3#before", "Cmd3#execute", "Cmd3#after", "Program#after"]
      end
    end
  end

  context "[moduled cmd]" do
    let(:program) { ::SkippableTest::Program }

    module ::SkippableTest
      class CmdX < Cmd1
        include Breadcrumbing
      end

      class Program
        include Ccp::Commands::Composite
        command CmdX
        command Cmd1
      end
    end

    context "(standard case)" do
      it "should execute normally" do
        breadcrumbs.should == ["SkippableTest::CmdX#before", "SkippableTest::CmdX#execute", "SkippableTest::CmdX#after", "Cmd1#before", "Cmd1#execute", "Cmd1#after"]
      end
    end

    context "(:skip_cmd1 given)" do
      before { options[:skip_cmd1] = true }
      it "should execute without Cmd1" do
        breadcrumbs.should == ["SkippableTest::CmdX#before", "SkippableTest::CmdX#execute", "SkippableTest::CmdX#after"]
      end
    end

    context "(:skip_skippable_test_cmd_x given)" do
      before { options[:skip_skippable_test_cmd_x] = true }
      it "should execute without Skippable::CmdX" do
        breadcrumbs.should == ["Cmd1#before", "Cmd1#execute", "Cmd1#after"]
      end
    end
  end
end
