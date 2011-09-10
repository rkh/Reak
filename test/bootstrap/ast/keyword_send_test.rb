require File.expand_path('../../test_helper', __FILE__)
MiniTest::Unit.autorun if $0 == __FILE__

class ASTKeywordSendTest < MiniTest::Unit::TestCase
  include LiteralTest
  literal Reak::AST::KeywordSend

  module Something
    @value = nil

    def self.value
      @value
    end

    def self.set_value(value)
      @value = value
      "ok"
    end

    def self.concat(a, b)
      a + b
    end

    Reak.smalltalk_expose singleton_class, 'set_value', 'setValue:'
    Reak.smalltalk_expose singleton_class, 'concat',    'to:add:'
  end

  parses "'foo' equals: 'bar'", "Something a: Something b: Something c: Something"
  parses_not "'foo' equals:", "Something a: Something b: c: Something"

  parses <<-Smalltalk
    Something
      a: Something
      b: Something
      c: Something
  Smalltalk

  parses <<-Smalltalk
    Something a: Something
      b: Something c: Something
  Smalltalk

  parses <<-Smalltalk
    Something a:
    Something
      b:
    Something c: Something
  Smalltalk

  evaluates("ASTKeywordSendTest.Something setValue: 'foo'") do |return_value|
    assert_equal "ok", return_value
    assert_equal "foo", Something.value
  end

  evaluates("ASTKeywordSendTest.Something to: 'foo' add: 'bar'") do |return_value|
    assert_equal "foobar", return_value
  end

  evaluates("Class class class rubyPerform: 'class'") do |return_value|
    assert_equal Class, return_value
  end
end
