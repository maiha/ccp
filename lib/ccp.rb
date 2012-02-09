require "must"
require "active_support/core_ext"
require "ccp/version"
require "ccp/data"

module Ccp
  autoload :Colorize,          'ccp/colorize'
  autoload :Commands,          'ccp/commands'
  autoload :Invokers,          'ccp/invokers'
  autoload :Receivers,         'ccp/receivers'
end
