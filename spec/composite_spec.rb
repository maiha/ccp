require "spec_helper"

describe Ccp::Commands::Composite do
  module Breadcrumbing
    BREADCRUMBS = []

    def this
      "%s#%s" % [self.class.name, caller[0].to_s.scan(/`(.*?)'/).first]
    end

    def breadcrumbs
      BREADCRUMBS
    end
  end

  class Cmd1
    include Ccp::Commands::Core
    include Breadcrumbing

    def execute
      breadcrumbs << this
      data[:foo] = []
    end

    def post
      breadcrumbs << this
    end
  end

  class Cmd2
    include Ccp::Commands::Core
    include Breadcrumbing

    def pre
      breadcrumbs << this
    end

    def execute
      breadcrumbs << this
      data[:foo] << "cmd2"
    end

    def post
      breadcrumbs << this
    end
  end

  class Cmd3
    include Ccp::Commands::Core
    include Breadcrumbing

    def pre
      breadcrumbs << this
    end

    def execute
      breadcrumbs << this
      data[:foo] << "cmd3"
    end
  end

  class Program
    include Ccp::Commands::Composite

    command Cmd1
    command Cmd2
    command Cmd3
  end

  subject { Program.new }

  it { should be_kind_of(Ccp::Commands::Core) }

  it "should call sub commands's {pre,execute,post} in declared order" do
    Breadcrumbing::BREADCRUMBS.clear
    subject.execute
    Breadcrumbing::BREADCRUMBS.should ==
      ["Cmd1#execute", "Cmd1#post", "Cmd2#pre", "Cmd2#execute", "Cmd2#post", "Cmd3#pre", "Cmd3#execute"]
  end

  it "should share same data storage in each sub commands" do
    subject.execute
    subject.data[:foo].should == ["cmd2", "cmd3"]
  end
end
