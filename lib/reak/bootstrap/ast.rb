module Reak
  module AST
    require 'reak/bootstrap/ast/node'
    require 'reak/bootstrap/ast/self'

    def self.grammar_for(dialect, g = nil)
      g ||= KPeg::Grammar.new
      g
    end
  end
end
