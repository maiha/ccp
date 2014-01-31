module Ccp
  module Receivers
    autoload :Core           , 'ccp/receivers/core'
    autoload :Base           , 'ccp/receivers/base'
    autoload :Loggable       , 'ccp/receivers/loggable'
    autoload :Global         , 'ccp/receivers/global'
    autoload :Settings       , 'ccp/receivers/settings'
    autoload :Variables      , 'ccp/receivers/variables'
    autoload :Executable     , 'ccp/receivers/executable'
    autoload :Aroundable     , 'ccp/receivers/aroundable'
    autoload :Skippable      , 'ccp/receivers/skippable'
    autoload :Commentable    , 'ccp/receivers/commentable'
    autoload :Profileable    , 'ccp/receivers/profileable'
    autoload :Fixtures       , 'ccp/receivers/fixtures'
  end
end
