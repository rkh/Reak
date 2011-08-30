require 'minitest/unit'
require 'reak'

module LiteralTest
  module ClassMethods
    def parses(*strings)
      strings.each { |str| define_method("test_parses_#{str}") { parses(str) }}
    end

    def parses_not(*strings)
      strings.each do |str|
        define_method("test_parses_#{str}") do
          assert_raises(Reak::Parser::ParseError) { parses(str) }
        end
      end
    end

    def evaluates(string, &block)
      define_method("test_evaluates_#{string}") do
        instance_exec(Reak.eval_smalltalk(string), &block)
      end
    end

    def literal(literal)
      define_method(:literal) { literal }
    end
  end

  def parses(string)
    parser = Reak::Parser.new(:reak, "parses #{string.inspect}")
    assert parser.parse_string(string)
  end

  def assert(cond, *a)
    if a.empty? and block_given? and not cond
      super cond, yield
    else
      super
    end
  end

  def self.append_features(base)
    base.extend ClassMethods
    super
  end
end
