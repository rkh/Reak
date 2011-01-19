module Reak
  module Syntax
    class Variable < Node
      attr_accessor :name, :scope
      unfold

      def initialize(name, scope = :lvar)
        @name = name.to_sym
        @scope = scope
      end

      def to_sexp
        [scope, name]
      end

      def [](*)
        name
      end
    end

    class Self < Variable
      def initialize; end

      def visit(visitor)
        visitor.myself # like yourself, get it?
      end

      def to_sexp
        [:self]
      end
    end

    class Super < Self
      def to_sexp
        [:super]
      end
    end

    class Assign < Variable
      attr_accessor :value
      SCOPES = { :lvar => :lasgn }

      def initialize(var, value, scope = :lvar)
        @name  = var.name
        @value = value
        @scope = scope
      end

      def asgn_scope
        SCOPES[scope]
      end

      def to_sexp
        [asgn_scope, name, value.to_sexp]
      end
    end
  end
end
