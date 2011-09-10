module Reak
  module AST
    require 'reak/bootstrap/ast/node'
    require 'reak/bootstrap/ast/string'
    require 'reak/bootstrap/ast/constant_access'
    require 'reak/bootstrap/ast/scoped_constant'
    require 'reak/bootstrap/ast/iter'
    require 'reak/bootstrap/ast/send'
    require 'reak/bootstrap/ast/unary_send'
    require 'reak/bootstrap/ast/keyword_send'
    require 'reak/bootstrap/ast/method_definition'
    require 'reak/bootstrap/ast/keyword_method_definition'
    require 'reak/bootstrap/ast/local_variable_access'
    require 'reak/bootstrap/ast/return'
    require 'reak/bootstrap/ast/block'

    def self.grammar_for(dialect, g = nil)
      g ||= KPeg::Grammar.new
      rules_for(dialect, g)
      Node.nodes.each { |n| n.grammar_for(dialect, g) }
      g.root = g.block
      g
    end

    def self.rules_for(dialect, g)
      g.comment     = g.seq '"', g.kleene(g.any('""', /[^"]/)), '"'
      g.one_space   = g.any(/\s+/, :comment)
      g.sp          = g.kleene :one_space
      g.sig_sp      = g.many :one_space
      g.identifier  = /[a-zA-Z][a-zA-Z0-9_]*/
    end
  end
end
