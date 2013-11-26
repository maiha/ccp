# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Ccp::Kvs::Tokyo::Info", :tch do
  let(:tmp) { tmp_path + "kvs/tokyo/info" }
  before { FileUtils.rm_rf(tmp) if tmp.directory? }

  describe ".parse" do
    let(:buf) { <<-EOF
      path: /tmp/tc/foo.tch
      database type: hash database
      record number: 0
      size: 528704
    EOF
    }

    subject { Ccp::Kvs::Tokyo::Info.parse(buf) }

    its(:path         ) { should == "/tmp/tc/foo.tch" }
    its(:database_type) { should == "hash database" }
    its(:record_number) { should == 0 }
    its(:size         ) { should == 528704 }

    # alias
    its(:count        ) { should == 0 }
  end
end
