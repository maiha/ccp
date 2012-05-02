require "typed"
require "dsl_accessor"
require "active_support/core_ext"
require "ccp/version"
require "ccp/data"

module Ccp
  autoload :Colorize,          'ccp/colorize'
  autoload :Fixtures,          'ccp/fixtures'
  autoload :Commands,          'ccp/commands'
  autoload :Invokers,          'ccp/invokers'
  autoload :Receivers,         'ccp/receivers'
  autoload :Persistent,        'ccp/persistent'
  autoload :Serializers,       'ccp/serializers'
end
