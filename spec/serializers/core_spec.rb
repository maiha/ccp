# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ccp::Serializers::Core do
  subject { Object.new.extend Ccp::Serializers::Core }

  it { should respond_to("ext") }
  it { should respond_to("encode") }
  it { should respond_to("decode") }
end
