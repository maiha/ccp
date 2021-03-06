$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'ccp'
require 'fileutils'

Ccp::Kvs                        # force to autoload for tokyocabinet, kyotocabinet

require File.join(File.dirname(__FILE__), "models")


RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.filter_run_excluding :tch unless defined?(TokyoCabinet)
  config.run_all_when_everything_filtered = true
end


def tmp_path
  Pathname(File.dirname(__FILE__)) + "../tmp"
end

def breadcrumbs_receiver
  r = Ccp::Receivers::Base.new
  r.data[:breadcrumbs] = [] 
  return r
end

def load_fixture(path)
  path = Pathname(path)
  ext  = Ccp::Serializers.lookup(path.extname.sub(/^\./, ''))
  ext.decode(path.open("rb").read{})
end

def save_fixture(path, obj)
  path = Pathname(path)
  ext  = Ccp::Serializers.lookup(path.extname.sub(/^\./, ''))
  buf  = ext.encode(obj)
  path.open("wb+"){|f| f.print buf}
end

def truncate_pathname(dir)
  path = Pathname(dir)
  FileUtils.rm_rf(path.to_s)
  path.mkpath
  return path
end
