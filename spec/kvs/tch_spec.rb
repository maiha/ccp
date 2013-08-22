# -*- coding: utf-8 -*-
require 'spec_helper'

__END__

describe Ccp::Kvs::Tch do
  let(:kvs) { s = Ccp::Kvs::Tch.new; s.open(source); s }
  let(:tmp) { tmp_path + "kvs/tch" }
  before { FileUtils.rm_rf(tmp) if tmp.directory? }

  describe "#open" do
    subject { inform }

    context "foo.tch" do
      let(:source) { tmp + "foo.tch" }
      its(:path) { should == "" }
    end
  end
end
