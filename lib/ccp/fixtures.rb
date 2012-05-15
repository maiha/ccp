module Ccp
  module Fixtures
    NotFound = Class.new(RuntimeError)
    autoload :Observer       , 'ccp/fixtures/observer'
    autoload :Writers        , 'ccp/fixtures/writers'
  end
end
