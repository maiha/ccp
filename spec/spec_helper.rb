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

def load_fixture(path)
  path = Pathname(path)
  case path.extname
  when ".json"; JSON.load(Pathname(path).read{})
  when ".yaml"; YAML.load(Pathname(path).read{})
  else; raise "load doesn't support #{path.extname}"
  end
end
