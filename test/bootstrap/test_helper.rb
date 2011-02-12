require 'minitest/unit'
require 'reak'

module LiteralTest
  module ClassMethods
    def parses(*strings)
      strings.each do |string|
        define_method("test_parses_#{string}") do
          parser = KPeg::Parser.new string, grammar
          parser.parse
          assert(!parser.failed?) { parser.error_expectation }
        end
      end
    end

    def parses_not(*strings)
      strings.each do |string|
        define_method("test_parses_#{string}") do
          parser = KPeg::Parser.new string, grammar
          parser.parse
          assert parser.failed?, "expected #{literal.inspect} not to parse #{string.inspect}"
        end
      end
    end
  end

  def assert(cond, *a)
    if a.empty? and block_given? and not cond
      super cond, yield
    else
      super
    end
  end

  def grammar
    @grammar ||= grammar_for :reak
  end

  def grammar_for(dialect, g = nil)
    g ||= KPeg::Grammar.new
    Reak::AST::Expression.grammar_for(dialect, g)
    g.root = g.send(literal.rule_name)
    g
  end 

  def self.append_features(base)
    base.extend ClassMethods
    super
  end
end
