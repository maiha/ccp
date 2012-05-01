module Ccp
  module Receivers
    autoload :Base           , 'ccp/receivers/base'
    autoload :Global         , 'ccp/receivers/global'
    autoload :Executable     , 'ccp/receivers/executable'
    autoload :Aroundable     , 'ccp/receivers/aroundable'
    autoload :Commentable    , 'ccp/receivers/commentable'
    autoload :Profileable    , 'ccp/receivers/profileable'
    autoload :SaveFixture    , 'ccp/receivers/save_fixture'
  end
end
