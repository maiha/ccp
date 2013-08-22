require "typed"
require "pathname"
require "dsl_accessor"
require "active_support/core_ext"
require "ccp/version"

module Ccp
  Failed = Class.new(RuntimeError)

  autoload :Utils,             'ccp/utils'
  autoload :Fixtures,          'ccp/fixtures'
  autoload :Commands,          'ccp/commands'
  autoload :Invokers,          'ccp/invokers'
  autoload :Receivers,         'ccp/receivers'
  autoload :Persistent,        'ccp/persistent'
  autoload :Serializers,       'ccp/serializers'
  autoload :Kvs,               'ccp/kvs'
end
