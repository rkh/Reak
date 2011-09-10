module Reak
  module AST
    class KeywordSend < Rubinius::AST::SendWithArguments
      include Reak::AST::Node
      include Reak::AST::Send
      Expression.unshift self

      def self.method_and_args(*pairs)
        pairs.inject(['', []]) { |(m,a), (k,v)| [m << "#{k}:", a << v] }
      end

      def self.bootstrap_grammar(g)
        key_value_pair = g.seq(g.t(:identifier), ":", :sp, g.t(argument_rule(g)), :sp) { |k,v| [k, v] }
        keyword_send_args = g.many(key_value_pair) { |*p| method_and_args(*p) }
        g.seq g.t(receiver_rule(g)), :sp, g.t(keyword_send_args), g.t(g.maybe(:iter))
      end

      def self.action(receiver, method_and_args, iter)
        method, args = method_and_args
        new(1, receiver, method, args, *iter)
      end

      def initialize(line, receiver, name, arguments, block = nil)
        super line, receiver, Reak.smalltalk_prefix(name), nil, true
        @block = block
        @arguments.array.concat arguments
      end

      class << self
        smalltalk_expose :receiver_rule, 'receiverRule:'
      end
    end
  end
end
