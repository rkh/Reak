module Reak
  module AST
    class Iter < Rubinius::AST::Iter
      include Reak::AST::Node

      def self.bootstrap_grammar(g)
        g.seq("[", g.t(:block), "]")
      end

      def self.action(body)
        new 1, nil, body
      end
    end
  end
end