module Reak
  module AST
    class Block < Rubinius::AST::Block
      include Reak::AST::Node

      def self.bootstrap_grammar(g)
        line = g.seq g.t(:expression), '.'
        g.seq g.t(g.kleene(line)), g.t(g.maybe(:expression)), g.sp
      end

      def self.action(*array)
        array.flatten!
        array << nil_literal(1) if array.empty?
        new 1, array
      end
    end
  end
end