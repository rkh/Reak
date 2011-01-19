module Reak
  module Syntax
    class Body < Node
      attr_accessor :locals, :statements

      def initialize(locals, statements)
        @locals = Array(locals)
        @statements = Expression === statements ? statements.expressions : Array(statements)
      end

      def nested_unclosure
        if locals.empty? and statements.length < 2
          statements.first
        else
          super
        end
      end

      def to_sexp
        [:block, [:locals, *locals]].concat @statements.map { |s| s.to_sexp }
      end
    end
  end
end
