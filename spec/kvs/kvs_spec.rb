# -*- coding: utf-8 -*-
require 'spec_helper'

kvss = []
kvss << Ccp::Kvs::Hash.new
kvss << Ccp::Kvs::Tch.new("#{tmp_path}/kvs/foo.tch")
       
kvss.each do |kvs|
  describe kvs do
    before  { FileUtils.rm_rf(tmp_path) if tmp_path.directory? }

    its(:ext) { should == kvs.class.ext }

    describe "#get, #set, #out" do
      let(:key) { raise "Sub context responsibility" }
      let(:val) { raise "Sub context responsibility" }

      subject {
        k = kvs
        k.touch
        k.count.should == 0
        k.get(key).should == nil
        k.set(key, val)
        k.get(key).should == val.to_s
        k.count.should == 1
        k.out(key).should == val.to_s
        k.get(key).should == nil
        k
      }

      context "'foo' => '1'" do
        let(:key) { "foo" }
        let(:val) { "1"   }
        it { should be }
      end

      context ":foo => '2'" do
        let(:key) { :foo }
        let(:val) { "2"  }
        it { should be }
      end
    end

    describe "#read!" do
      specify do
        kvs.touch
        kvs.codec! :json
        kvs.set(:a, 1)
        kvs.set(:b, ["x", 0])
        kvs.read!.should == {"a"=>1, "b"=>["x", 0]}
      end
    end

  end
end
