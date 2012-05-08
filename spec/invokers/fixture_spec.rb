require "spec_helper"
require 'fileutils'

describe Ccp::Invokers::Base do
  describe "(class methods)" do
    subject {Class.new(Ccp::Invokers::Base)}
    it { should respond_to(:fixture_save) }
    it { should respond_to(:fixture_keys) }
    it { should respond_to(:fixture_dir) }
    it { should respond_to(:fixture_kvs) }
    it { should respond_to(:fixture_ext) }
  end
end
