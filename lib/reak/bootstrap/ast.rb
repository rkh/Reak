module Reak
  module AST
    require 'reak/bootstrap/ast/node'
    require 'reak/bootstrap/ast/string'

    def self.grammar_for(dialect, g = nil)
      g ||= KPeg::Grammar.new
      Expression.grammar_for(dialect, g)
      g.root = g.expression
      g
    end
  end
end
