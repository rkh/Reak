module Reak
  module AST
    class Return < Rubinius::AST::Return
      include Reak::AST::Node
      Expression.push self

      def self.bootstrap_grammar(g)
        g.seq("^", :sp, g.t(:expression))
      end

      def self.action(value)
        new 1, value
      end
    end
  end
end
