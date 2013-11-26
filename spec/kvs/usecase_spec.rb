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
    }

    specify do
      kvs.set("1", {"mc"=>-1, "mi"=>0, "mr"=>-1.0, "tc"=>-1, "ti"=>-1, "tr"=>-1.0})
      kvs.get("1").should == {"mc"=>-1, "mi"=>0, "mr"=>-1.0, "tc"=>-1, "ti"=>-1, "tr"=>-1.0}
    end

    specify do
      kvs.set("2", [1,2,3])
      kvs.get("2").should == [1,2,3]
    end

    specify do
      kvs.set("2", [1,2,3])
      kvs.first.should == ["2", [1,2,3]]
    end
  end
end
