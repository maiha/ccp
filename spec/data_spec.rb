require "spec_helper"

describe Ccp::Data do
  subject { Object.new.extend Ccp::Data }
  def data; subject.data; end

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

