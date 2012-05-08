# $:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'ccp'

require File.join(File.dirname(__FILE__), "models")

def breadcrumbs_receiver
  r = Ccp::Receivers::Base.new
  r.data[:breadcrumbs] = [] 
  return r
end

def lookup_serializer(extname)
  {".json"=>JSON, ".yaml"=>YAML}[extname] or raise "no serializers for #{extname}"
end

def load_fixture(path)
  path = Pathname(path)
  lookup_serializer(path.extname).load(path.read{})
end

def save_fixture(path, obj)
  path = Pathname(path)
  buf  = lookup_serializer(path.extname).dump(obj)
  path.open("w+"){|f| f.print buf}
end

def truncate_pathname(dir)
  path = Pathname(dir)
  FileUtils.rm_rf(path.to_s)
  path.mkpath
  return path
end
