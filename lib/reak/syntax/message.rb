module Reak
  module Syntax
    class Message < Node
      attr_accessor :args, :selector

      def initialize(selector, args = nil)
        @selector = selector
        @args = Array(args)
      end

      def to_sexp
        [:message, selector].concat args.map { |e| e.to_sexp }
      end

      def arity
        args.size
      end

      def visit(visitor)
        args.each { |a| a.visit visitor }
        visitor.call_method self
      end
    end

    class MessageKey < Message
      alias key selector

      def arg
        args.first
      end

      def visit(visitor)
        fails "should not get here"
      end
    end
  end
end
