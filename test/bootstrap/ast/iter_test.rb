require File.expand_path('../../test_helper', __FILE__)
MiniTest::Unit.autorun if $0 == __FILE__

class ASTIterTest < MiniTest::Unit::TestCase
  include LiteralTest
  literal Reak::AST::Iter

  module Something
    @value = nil

    def self.value
      @value
    end

    def self.set_value(value)
      @value = value
      yield
    end

    Reak.smalltalk_expose singleton_class, 'set_value', 'setValue:'
  end

  parses "'foo' bar: 'baz' [ 'blah' ]"

  evaluates("ASTIterTest.Something setValue: 'foo' [ ^ 'ok' ]") do |return_value|
     assert_equal "ok", return_value
     assert_equal "foo", Something.value
  end
end
