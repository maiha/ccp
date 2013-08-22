# -*- coding: utf-8 -*-
require 'spec_helper'

Ccp::Serializers.each do |serializer|
  describe serializer do
    its(:ext) { should == serializer.ext }

    describe "#encode, #decode" do
      let(:obj) { raise "Sub context responsibility" }
      subject {
        serializer.encode(obj).should be_kind_of(String)
        serializer.decode(serializer.encode(obj)).should == obj
      }

      context "[1,2,3]" do
        let(:obj) { [1,2,3] }
        it { should be }
      end

      context "'foo' => 1" do
        let(:obj) { { "foo" => 1 } }
        it { should be }
      end

      context "complex objects" do
        let(:obj) { {
            "cpm"     => 100.0,
            "domains" => ["google", "yahoo"],
          } }
        it { should be }
      end
    end
  end
end
