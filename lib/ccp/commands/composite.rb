module Ccp
  module Commands
    module Composite
      def self.included(base)
        super
        base.class_eval do
          extend ClassMethods
          extend Executable::ClassMethods
        end
      end

      CommandClass = Struct.new(:klass, :args, :cond) unless defined?(CommandClass)
      class CommandClass
        def inspect
          name = klass.name.split(/Commands::/,2).last
          "<%s args=%s cond=%s>" % [name, args.inspect, cond.inspect]
        end

        def to_s
          inspect
        end
      end

      ######################################################################
      ### Class Methods

      module ClassMethods
        include Resolvable

        def prepend_command(klass, *args, &block)
          commands.unshift CommandClass.new(resolve(klass), args, block)
        end

        def append_command(klass, *args, &block)
          klass = resolve(klass)
          if commands.find{|cc| cc.klass == klass and cc.args == args}
            # ignore: already added
          else
            commands << CommandClass.new(klass, args, block)
          end
        end

        def command(*args)
          append_command(*args)
        end

        def commands
          @commands ||= []
        end
      end

      ######################################################################
      ### Instance Methods

      include Core
      include Enumerable

      ######################################################################
      ### Enumerable

      def commands
        @commands ||= build_commands.must(Array)
      end

      ######################################################################
      ### Commands

      def execute
        commands.each do |c|
          c.receiver.execute(c)
        end
      end

      def receiver=(value)
        super
        commands.each{|c| c.receiver = value}
      end

      private
        def build_commands
          array = self.class.commands.select{|c| c.cond.nil? or instance_eval(&c.cond)}
          cmds  = array.map{|c|
            c = c.klass.new(*c.args)
            c.receiver = receiver
            c
          }
        end
    end
  end
end
