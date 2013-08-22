module Ccp
  module Commands
    module Resolvable
      def resolve(klass)
        klass.is_a?(Class) or
          raise CommandNotFound, "expected Class or Module, but got #{klass.class}"

        if klass.ancestors.include?(Commands::Core)
          return klass # ok
        end

        if klass.must.duck?("#execute")
          # dynamically assign core
          klass.class_eval{ include Commands::Core }
          return klass
        end

        raise CommandNotFound, "#{klass} found but it misses 'execute' method"
      end
    end
  end
end
