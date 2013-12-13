require "spec_helper"
require 'fileutils'

######################################################################
### What means targets

describe Cmd1 do
  describe ".execute" do
    FIXTURE_PATH = Pathname("tmp/fixtures/cmd1")

    before do
      FileUtils.rm_rf(FIXTURE_PATH.to_s)
    end

    def created_keys
      path = FIXTURE_PATH + "stub.msgpack"
      Ccp::Persistent::Dir.new(path, :msgpack).read.keys.sort
    rescue Errno::ENOENT
      []
    end

    def self.execute(opts = {}, &block)
      context "(#{opts.inspect})" do
        expected = block.call
        it "should create #{expected.inspect}" do
          Cmd1.execute({:breadcrumbs=>[]}.merge(opts))
          created_keys.should == expected
        end
      end
    end

    ######################################################################
    ### fixture_save

    # nop when :save is not given
    execute() do
      []
    end

    execute(:fixture_save => true) do
      ["breadcrumbs"]
    end

    ######################################################################
    ### accepts

    execute(:fixture_save => true, :fixture_keys => true) do
      ["breadcrumbs"]
    end

    execute(:fixture_save => true, :fixture_keys => ['x']) do
      []
    end

    ######################################################################
    ### excepts

    execute(:fixture_save => true, :fixture_keys => ['!breadcrumbs']) do
      []
    end

    execute(:fixture_save => true, :fixture_keys => ['!breadcrumbsXXX']) do
      ["breadcrumbs"]
    end

    ######################################################################
    ### accepts & excepts

    execute(:fixture_save => true, :fixture_keys => ['xxx', '!breadcrumbs']) do
      []
    end

    execute(:fixture_save => true, :fixture_keys => ['xxx', '!xxx']) do
      []
    end

    execute(:fixture_save => true, :fixture_keys => ['breadcrumbs', '!xxx']) do
      ["breadcrumbs"]
    end

    execute(:fixture_save => true, :fixture_keys => ['breadcrumbs', '!breadcrumbs']) do
      ["breadcrumbs"]
    end
  end
end
