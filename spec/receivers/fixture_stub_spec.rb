describe Ccp::Receivers::Fixtures do
  context "(with stub)" do
    class Cmd1Stub < Cmd1
      stub "spec/fixtures/stub/breadcrumbs.json"
    end

    it "should merge given data file into data variable" do
      lambda {
        Cmd1.execute
      }.should raise_error(Typed::NotDefined)

      lambda {
        Cmd1Stub.execute
      }.should_not raise_error
    end
  end

  context "(with valid mock)" do
    class Cmd1Mock < Cmd1
      stub "spec/fixtures/stub/breadcrumbs.json"
      mock "spec/fixtures/cmd1/mock.json"
    end

    it "should raise when current data doesn't match the given data" do
      lambda {
        Cmd1Mock.execute
      }.should_not raise_error
    end
  end

  context "(with invalid mock)" do
    class Cmd1MockInvalid < Cmd1
      stub "spec/fixtures/stub/breadcrumbs.json"
      mock "spec/fixtures/stub/breadcrumbs.json"
    end

    it "should raise when current data doesn't match the given data" do
      lambda {
        Cmd1MockInvalid.execute
      }.should raise_error(/should create/)
    end
  end
end
