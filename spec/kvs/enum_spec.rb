# -*- coding: utf-8 -*-
require 'spec_helper'

codecs = %w( json msgpack )
exts   = %w( kch )
exts << "tch" if defined?(TokyoCabinet)

codecs.product(exts).each do |codec, ext|
  klass = Ccp::Kvs[ext]
  describe "#{klass}(#{codec})" do
    before { FileUtils.rm_rf(tmp_path) if tmp_path.directory? }
    let(:kvs) { klass.new(tmp_path + "kvs.#{ext}") }

    before {
      kvs.codec!(codec)

      kvs.touch
      kvs["1"] = 10
      kvs["2"] = 20
      kvs["3"] = 30
      kvs["4"] = 40
      kvs.del("3")
      # => {"1"=>10, "2"=>20, "4"=>40}
    }

    specify "(given)" do
      kvs.read.should == {"1"=>10, "2"=>20, "4"=>40}
    end

    ######################################################################
    ### enumerable

    describe "#each" do
      specify do
        hash = {}
        kvs.each do |k,v|
          hash[k] = v
        end
        hash.should == {"1"=>10, "2"=>20, "4"=>40}
      end
    end

    describe "#each_pair" do
      specify do
        hash = {}
        kvs.each_pair do |k,v|
          hash[k] = v
        end
        hash.should == {"1"=>10, "2"=>20, "4"=>40}
      end
    end

    describe "#each_key" do
      specify do
        array = []
        kvs.each_key do |k|
          array << k
        end
        array.sort.should == %w( 1 2 4 )
      end
    end

    describe "#keys" do
      specify do
        kvs.keys.sort.should == %w( 1 2 4 )
      end
    end

    describe "#first_key" do
      specify do
        kvs.first_key.should =~ /^[124]$/
      end
    end

    describe "#first" do
      specify do
        k,v = kvs.first
        (k.to_i*10).should == v
      end
    end

    ######################################################################
    ### usecase

    describe "#each with break" do
      specify do
        head = []
        i = 0
        kvs.each do |k,v|
          i += 1
          break if i > 1
          head << v
        end

        head.should == [10]
      end
    end

    describe "#each with raise" do
      specify do
        head = []
        i = 0

        lambda {
          kvs.each do |k,v|
            i += 1
            raise "ok" if i > 1
            head << v
          end
        }.should raise_error(/ok/)

        head.should == [10]
      end
    end

    describe "#each with next" do
      specify do
        tail = []
        i = 0
        kvs.each do |k,v|
          i += 1
          next if i <= 1
          tail << v
        end

        tail.sort.should == [20, 40]
      end
    end

  end

end
