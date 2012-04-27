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

