module Reak
  module AST
    module Send
      module ClassMethods
        def receiver_rule(g)
          g.any(:unarysend, :primary)
        end

        alias argument_rule receiver_rule
      end

      def self.append_features(obj)
        obj.extend ClassMethods
        super
      end
    end
  end
end
