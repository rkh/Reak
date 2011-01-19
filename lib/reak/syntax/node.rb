module Reak
  module Syntax
    class Node
      def self.unfold
        define_method(:unfold?) { true }
      end

      def unclosure
        Call.new self, Message.new('value')
      end

      def nested_unclosure
        self
      end

      def to_sexp
      end

      def unfold?
        false
      end

      def graph
        Rubinius::AST::AsciiGrapher.new(self, Node).print
      end

      def visit(visitor)
        raise NotImplementedError, "Don't know how to visit #{self.inspect}"
      end
      
      def pretty_print(pp)
        pp.text sprintf('#<%s ', self.class.name)
        pp.nest(1) do
          pp.seplist(instance_variables) do |var|
            pp.text "#{var}="
            pp.pp instance_variable_get(var)
          end
        end
        pp.text ">"
      end   
    end
  end
end