# -*- coding: utf-8 -*-
require 'spec_helper'

kvs_args = {}

kvs_args["tch"] = "#{tmp_path}/kvs/foo.tch" if defined?(TokyoCabinet)
kvs_args["kch"] = "#{tmp_path}/kvs/foo.kch"

Ccp::Kvs.each do |klass|
  describe klass do
    before  { FileUtils.rm_rf(tmp_path) if tmp_path.directory? }

    let(:kvs) { kvs_args[klass.ext] ? klass.new(*kvs_args[klass.ext]) : klass.new }

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

    describe "#get, #set, #ou (with msgpack)t" do
      let(:key) { raise "Sub context responsibility" }
      let(:val) { raise "Sub context responsibility" }

      before { kvs.codec! :msgpack }

      subject {
        k = kvs
        k.touch
        k.count.should == 0
        k.get(key).should == nil
        k.set(key, val)
        k.get(key).should == val
        k.count.should == 1
        k.out(key).should == val
        k.get(key).should == nil
        k
      }

      context "nil" do
        let(:key) { :foo }
        let(:val) { nil  }
        it { should be }
      end

      context ":foo => [true, nil]" do
        let(:key) { :foo }
        let(:val) { [true, nil]  }
        it { should be }
      end
    end

    describe "#read" do
      specify do
        kvs.touch
        kvs.codec! :json
        kvs.set(:a, 1)
        kvs.set(:b, ["x", 0])
        kvs.read.should == {"a"=>1, "b"=>["x", 0]}
      end
    end

    describe "#write" do
      specify do
        kvs.touch
        kvs.codec! :json
        kvs.write("a"=>1, "b"=>["x", 0])
        kvs["a"].should == 1
        kvs["b"].should == ["x", 0]
      end
    end

    describe "#codec!" do
      specify "return self" do
        kvs.codec!(:msgpack).should == kvs
      end
    end
  end
end
