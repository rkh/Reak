require File.expand_path('../../test_helper', __FILE__)
MiniTest::Unit.autorun if $0 == __FILE__

class ASTConstantAccessTest < MiniTest::Unit::TestCase
  include LiteralTest
  literal Reak::AST::ConstantAccess

  parses "Foo", "Bar", "Object"
  parses_not "::Foo"
  evaluates("Object") { |c| assert_equal Object, c }
end
