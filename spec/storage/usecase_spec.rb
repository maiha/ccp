# -*- coding: utf-8 -*-
require 'spec_helper'

codecs = %w( json msgpack )
exts   = %w( tch kch )

codecs.product(exts).each do |codec, ext|
  dir = "foo.#{codec}.#{ext}"
  describe "Ccp::Storage.load('#{dir}')" do
    before  { FileUtils.rm_rf(tmp_path) if tmp_path.directory? }
    let(:storage)  { Ccp::Storage.load(tmp_path + dir) }

    context "(table)" do
      let(:path) { tmp_path + dir + "user/budget.#{codec}.#{ext}" }
      let(:kvs)  { storage.table("user/budget") }

      before { path.exist?.should == false } # no file exists

      specify "touch creates file" do
        kvs.touch
        path.exist?.should == true
      end

      specify "dump and load" do
        kvs["1"] = 100
        kvs["2"] = "test"
        kvs["3"] = [1,2,3]
        kvs["4"] = {"mc"=>-1, "mi"=>0, "mr"=>-1.0, "tc"=>-1, "ti"=>-1, "tr"=>-1.0}
        kvs.del("2")

        kvs.count.should == 3
        kvs.get("3").should == [1,2,3]
      end
    end    
  end
end
