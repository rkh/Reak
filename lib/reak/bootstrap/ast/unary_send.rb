module Reak
  module AST
    class UnarySend < Rubinius::AST::Send
      include Reak::AST::Node
      include Reak::AST::Send
      Expression.unshift self

      def self.bootstrap_grammar(g)
        g.seq g.t(receiver_rule(g)), :sp, g.t(:identifier), g.notp(':'), g.t(g.maybe(:iter))
      end

      def self.action(receiver, method, iter)
        new(1, receiver, method, *iter)
      end

      def initialize(line, reciever, name, block = nil)
        super(line, reciever, Reak.smalltalk_prefix(name), true)
        @block = block
      end
    end
  end
end
