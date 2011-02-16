module Reak
  module AST
    require 'reak/bootstrap/ast/node'
    require 'reak/bootstrap/ast/string'
    require 'reak/bootstrap/ast/constant_access'
    require 'reak/bootstrap/ast/scoped_constant'
    require 'reak/bootstrap/ast/keyword_send'

    def self.grammar_for(dialect, g = nil)
      g ||= KPeg::Grammar.new
      rules_for(dialect, g)
      g.root = g.expression
      Node.nodes.each { |n| n.grammar_for(dialect, g) }
      g
    end

    def self.rules_for(dialect, g)
      g.sp = g.kleene g.any(" ", "\n")
      g.sig_sp = g.many g.any(" ", "\n")
      g.identifier = /[a-zA-Z][a-zA-Z0-9_]*/
    end
  end
end
