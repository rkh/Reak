module Reak
  module AST
    class LocalVariableAccess < Rubinius::AST::LocalVariableAccess
      include Reak::AST::Node
      Primary.push self

      def self.bootstrap_grammar(g)
        g.t /[a-z][a-zA-Z0-9_]*/
      end

      def self.action(value)
        new 1, value.to_sym
      end
    end
  end
end
