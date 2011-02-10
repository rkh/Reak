module Reak
  module AST
    class Self < Node :Self
      def self.bootstrap_grammar(g)
        g.str("self")
      end

      def self.action(line, *)
        new line
      end
    end
  end
end