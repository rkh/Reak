module Reak
  module Syntax
    class Closure < Node
      attr_accessor :args, :statements
      unfold

      def initialize(args, body)
        @args = Array(args)
        @body = body
      end

      def to_sexp
        [:closure, [:arglist, *args], @body.to_sexp]
      end

      def unclosure
        args.empty? ? @body.nested_unclosure : super
      end
    end
  end
end
