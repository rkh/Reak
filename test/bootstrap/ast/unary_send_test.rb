require File.expand_path('../../test_helper', __FILE__)
MiniTest::Unit.autorun if $0 == __FILE__

class ASTUnarySendTest < MiniTest::Unit::TestCase
  include LiteralTest
  literal Reak::AST::UnarySend

  evaluates("Class class") do |return_value|
    assert_equal Class.singleton_class, return_value
  end

  evaluates("Class class class") do |return_value|
    assert_equal Class.singleton_class.singleton_class, return_value
  end
end
