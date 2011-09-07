module Reak
  module AST
    module MethodDefinition
      module ClassMethods
        def receiver_rule(g)
          g.maybe(g.seq g.t(super), :sp, g.str('>>'))
        end

        def argument_rule(g)
          :identifier
        end
      end

      def self.append_features(object)
        ClassMethods.extend_object(object)
        super
      end
    end
  end
end
