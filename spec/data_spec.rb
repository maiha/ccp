require "spec_helper"

describe Ccp::Data::KVS do
  ######################################################################
  ### Accessor

  it "should behave like hash" do
    subject[:foo] = 1
    subject[:foo].should == 1
  end

  describe "#[]" do
    it "should raise NotDefined if no data exist for the key" do
      lambda {
        subject[:foo]
      }.should raise_error(Ccp::Data::NotDefined)
    end
  end

  describe "#[]=" do
    it "can override values" do
      subject[:foo] = 1
      subject[:foo] = 2
      subject[:foo].should == 2
    end
  end

  ######################################################################
  ### Testing

  describe "#exist?" do
    it "should return true if the value is set" do
      subject[:foo] = 1
      subject.exist?(:foo).should == true
    end

    it "should return false if the value is not set" do
      subject.exist?(:foo).should == false
    end
  end

  describe "#set?" do
    it "should return true if the value is set and not (nil|false)" do
      subject[:foo] = 0
      subject.set?(:foo).should == true

      subject.default[:bar] = 0
      subject.set?(:bar).should == true

      subject.default(:baz) { 0 }
      subject.set?(:baz).should == true
    end

    it "should return false if the value is set but (nil|false)" do
      subject[:foo] = nil
      subject.set?(:foo).should == false

      subject[:foo] = false
      subject.set?(:foo).should == false
    end
  end

  describe "#check" do
    it "should satisfy its type" do
      subject[:foo] = 1
      lambda {
        subject.check(:foo, Integer)
      }.should_not raise_error
    end

    it "should satisfy its struct" do
      subject[:foo] = {:a => "text"}
      lambda {
        subject.check(:foo, {Symbol => String})
      }.should_not raise_error
    end

    it "should raise TypeError if not satisfied" do
      subject[:foo] = {:a => "text"}
      lambda {
        subject.check(:foo, Integer)
      }.should raise_error(TypeError)
    end
  end

  ######################################################################
  ### Default values

  describe "#default" do
    it "should set default value" do
      subject.default[:foo] = 1
      subject.exist?(:foo).should == true
      subject[:foo].should == 1
    end

    it "should be overriden by []=" do
      subject.default[:foo] = 1
      subject[:foo] = 2
      subject[:foo].should == 2
    end

    it "should not affect data when already set" do
      subject[:foo] = 1
      subject.default[:foo] = 2
      subject[:foo].should == 1
    end
  end

  describe "#default(&block)" do
    it "should set lazy default value" do
      @a = 1
      subject.default(:foo) { @a }
      @a = 2
      subject[:foo].should == 2
    end
  end

  ######################################################################
  ### Utils

  describe "#path" do
    it "should return pathname" do
      subject[:foo] = __FILE__
      subject.path(:foo).should be_kind_of(Pathname)
      subject.path(:foo).basename.should == Pathname("data_spec.rb")
    end
  end
end

