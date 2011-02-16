module Reak
  module AST
    class Block < Rubinius::AST::Block
      include Reak::AST::Node

      def self.bootstrap_grammar(g)
        line = g.seq g.t(:expression), '.'
        g.seq g.kleene(line), g.maybe(:expression)
      end

      def self.action(*array)
        new 1, array.flatten
      end
    end
  end
end