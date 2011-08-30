require File.expand_path('../../test_helper', __FILE__)
MiniTest::Unit.autorun if $0 == __FILE__

class ASTScopedConstantTest < MiniTest::Unit::TestCase
  include LiteralTest
  literal Reak::AST::ScopedConstant

  parses "Foo.Bar", "Bar.Baz", "Object.Array"
  parses_not "Foo::Bar"
  evaluates("Reak.AST") { |c| assert_equal Reak::AST, c }
end
