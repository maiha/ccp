module Breadcrumbing
  def this
    "%s#%s" % [self.class.name, caller[0].to_s.scan(/`(.*?)'/).first]
  end
end

class Cmd1
  include Ccp::Commands::Core
  include Breadcrumbing

  def before
    data[:breadcrumbs] << this
  end

  def execute
    data[:breadcrumbs] << this
  end

  def after
    data[:breadcrumbs] << this
  end
end

class Cmd2 < Cmd1; end
class Cmd3 < Cmd1; end
class Cmd4 < Cmd1; end

class Program
  include Ccp::Commands::Composite
  include Breadcrumbing

  command Cmd1
  command Cmd2
  command Cmd3

  def before
    data[:breadcrumbs] << this
  end

  def after
    data[:breadcrumbs] << this
  end
end

class Cmd23
  include Ccp::Commands::Composite
  include Breadcrumbing

  command Cmd2
  command Cmd3

  def before
    data[:breadcrumbs] << this
  end

  def execute
    data[:breadcrumbs] << this + ":start"
    super
    data[:breadcrumbs] << this + ":end"
  end

  def after
    data[:breadcrumbs] << this
  end
end

class CompositeProgram
  include Ccp::Commands::Composite
  include Breadcrumbing

  command Cmd1
  command Cmd23
  command Cmd4

  def before
    data[:breadcrumbs] << this
  end

  def after
    data[:breadcrumbs] << this
  end
end

class CompositeInvoker < Ccp::Invokers::Base
  include Breadcrumbing

  command Cmd1
  command Cmd23
  command Cmd4

  def before
    data[:breadcrumbs] << this
  end

  def after
    data[:breadcrumbs] << this
    super
  end
end
