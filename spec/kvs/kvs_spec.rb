# -*- coding: utf-8 -*-
require 'spec_helper'

Ccp::Kvs.each do |kvs|
  describe kvs do
    its(:ext) { should == kvs.ext }

    describe "#get, #set, #out" do
      let(:key) { raise "Sub context responsibility" }
      let(:val) { raise "Sub context responsibility" }

      subject {
#        kvs.encode(obj).should be_kind_of(String)
#        kvs.decode(kvs.encode(obj)).should == obj
        k = kvs.open
        k[key] = val
        k[key].should == val
      }

      context "foo => 1" do
        let(:key) { "foo" }
        let(:val) { "1"   }
        it { should be }
      end
    end
  end
end
