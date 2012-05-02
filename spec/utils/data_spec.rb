require "spec_helper"

describe Ccp::Utils::Data do
  def data; subject; end

  ######################################################################
  ### Utils

  describe "#path" do
    it "should return pathname" do
      data[:foo] = __FILE__
      data.path(:foo).should be_kind_of(Pathname)
      data.path(:foo).basename.should == Pathname("data_spec.rb")
    end
  end
end

