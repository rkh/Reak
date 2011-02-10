module Reak
  module AST
    require 'reak/bootstrap/ast/node'
    require 'reak/bootstrap/ast/self'

    def self.grammar_for(dialect, g = nil)
      g ||= KPeg::Grammar.new
      Self.grammar_for(dialect, g)
      g.root = g.self
      g
    end
  end
end
