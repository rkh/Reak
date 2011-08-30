require File.expand_path('../../test_helper', __FILE__)
MiniTest::Unit.autorun if $0 == __FILE__

class ASTBlockTest < MiniTest::Unit::TestCase
  include LiteralTest
  literal Reak::AST::Block

  parses "'foo'", "'foo'. Bar.", "Foo. Bar."
  parses_not "Foo.. Bar.", "'foo' 'bar'"

  evaluates("'foo'. Reak.AST") do |return_value|
    assert_equal Reak::AST, return_value
  end

  evaluates("'foo'. Reak.AST.") do |return_value|
    assert_equal Reak::AST, return_value
  end

  evaluates("Reak.AST.") do |return_value|
    assert_equal Reak::AST, return_value
  end
end
