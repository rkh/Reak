module Reak
  module AST
    class Block < Rubinius::AST::Block
      include Reak::AST::Node

      def self.bootstrap_grammar(g)
        line = g.seq g.t(:expression), '.'
        g.seq g.t(g.kleene(line)), g.t(g.maybe(:expression)), g.sp
      end

      def self.action(*array)
        new 1, array.flatten
      end
    end
  end
end