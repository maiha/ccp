# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Kvs::Core do
  subject { Object.new.extend Ccp::Kvs::Core }

  it { should respond_to("ext") }
  it { should respond_to("get") }
  it { should respond_to("set") }
  it { should respond_to("del") }
  it { should respond_to("keys") }
  it { should respond_to("touch") }
  it { should respond_to("exist?") }
  it { should respond_to("key?") }
end
