require "spec_helper"
require 'fileutils'

describe Ccp::Invokers::Spec do
  it "should inherit Ccp::Invokers::Base" do
    subject.should be_kind_of(Ccp::Invokers::Base)
  end

  describe "(class)" do
    subject { Ccp::Invokers::Spec }
    it { should respond_to("spec") }
  end
end


__END__

  class Cmd1Spec < Ccp::Invokers::Spec
    fixture_dir "spec/fixtures/invokers/spec/stub"
    command Cmd1
  end

  it "should stub data" do
    path = truncate_pathname("tmp/fixtures/spec/invokers/spec/stub")
    save_fixture(path + "stub.json", "breadcrumbs"=>[])

    lambda {
      Cmd1Spec.execute
    }.should raise_error(Typed::NotDefined)

    lambda {
      Cmd1Spec.spec
    }.should_not raise_error
  end
end

