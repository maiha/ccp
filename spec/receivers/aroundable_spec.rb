require "spec_helper"

describe Ccp::Receivers::Aroundable do
  class AroundableTestOk < Cmd1
    def execute
      # NOP
    end
  end

  class AroundableTestNg < Cmd1
    def execute
      raise "some error"
    end
  end

  let(:options)  { {:breadcrumbs => []} }
  let(:program)  { raise "program not set" }
  let(:receiver) { Ccp::Receivers::Base.new }
  let(:data)     { receiver.data }

  def execute
    data[:breadcrumbs] = []
    program.execute(:receiver => receiver)
  end

  describe "#execute" do
    context "(success)" do
      let(:program) { AroundableTestOk }
      it "should call before, after" do
        lambda { execute }.should_not raise_error
        data[:breadcrumbs].should == ["AroundableTestOk#before", "AroundableTestOk#after"]
      end
    end

    context "(error)" do
      let(:program) { AroundableTestNg }
      it "should call before, after" do
        lambda { execute }.should raise_error("some error")
        data[:breadcrumbs].should == ["AroundableTestNg#before", "AroundableTestNg#after"]
      end
    end
  end
end
