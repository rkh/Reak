module Reak
  module AST
    class String < Rubinius::AST::StringLiteral
      include Reak::AST::Node
      Primary.register self

      def self.bootstrap_grammar(g)
        not_quote = g.many(g.any(g.str("''"), /[^']/)) { |*a| a.join }
        g.seq("'", g.t(not_quote), "'")
      end

      def self.action(line, value)
        new line, value
      end
    end
  end
end