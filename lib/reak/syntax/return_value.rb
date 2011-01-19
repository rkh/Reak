module Reak
  module Syntax
    class ReturnValue < Node
      attr_accessor :expression

      def initialize(expression)
        @expression = expression
      end

      def to_sexp
        [:return, @expression.to_sexp]
      end

      def visit(visitor)
        visitor.return self
      end
    end
  end
end
