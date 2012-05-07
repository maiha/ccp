require "spec_helper"
require 'fileutils'

######################################################################
### Why means ACL

describe Ccp::Commands::Composite do
  describe ".execute" do
    FIXTURE_ROOT = "tmp/fixtures"

    before do
      FileUtils.rm_rf(FIXTURE_ROOT.to_s)
    end

    def created_fixtures
      Dir.chdir(FIXTURE_ROOT){Dir["*/read.json"].map{|i| File.dirname(i)}.sort}
    rescue Errno::ENOENT
      []
    end

    def self.execute(opts = {}, &block)
      context "(#{opts.inspect})" do
        expected = block.call
        it "should create #{expected.inspect}" do
          Program.execute({:breadcrumbs=>[]}.merge(opts))
          created_fixtures.should == expected
        end
      end
    end

    ######################################################################
    ### fixture_save

    # nop when :save is not given
    execute() do
      []
    end

    # nop when :save is false
    execute(:fixture_save => false) do
      []
    end

    execute(:fixture_save => true) do
      ["cmd1", "cmd2", "cmd3", "program"]
    end

    ######################################################################
    ### accepts

    execute(:fixture_save => 'Cmd2') do
      ["cmd2"]
    end

    execute(:fixture_save => ['Cmd2']) do
      ["cmd2"]
    end

    execute(:fixture_save => ['Cmd2', 'Cmd3']) do
      ["cmd2", "cmd3"]
    end

    # no match
    execute(:fixture_save => ['CmdX']) do
      []
    end

    ######################################################################
    ### excepts

    execute(:fixture_save => ['!Cmd1']) do
      ["cmd2", "cmd3", "program"]
    end

    execute(:fixture_save => ['!Cmd2', '!Program']) do
      ["cmd1", "cmd3"]
    end

    ######################################################################
    ### accepts & excepts

    # :accept has a higher priority
    execute(:fixture_save => ['Cmd1','!Cmd2']) do
      ['cmd1']
    end

    # :accept is used even if settings are conflicted
    execute(:fixture_save => ['Cmd1','!Cmd1']) do
      ['cmd1']
    end
  end
end
