require File.expand_path('../../test_helper', __FILE__)
MiniTest::Unit.autorun if $0 == __FILE__

class ASTStringTest < MiniTest::Unit::TestCase
  include LiteralTest

  def literal
    Reak::AST::String
  end

  parses "'foo'"
  parses_not "'foo"
end