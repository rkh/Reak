require File.expand_path('../../test_helper', __FILE__)
MiniTest::Unit.autorun if $0 == __FILE__

class ASTStringTest < MiniTest::Unit::TestCase
  include LiteralTest
  literal Reak::AST::String

  parses "'foo'", "' '", "''", "' foo '", "'\"'", "''''",  "''' foo '''", "'\n'"
  parses_not "'foo", "'''", "'", "foo", "''foo''"

  evaluates("'foo'")      { |str| assert_equal 'foo',     str }
  evaluates("'it''s ok'") { |str| assert_equal "it's ok", str }
  evaluates("'\\n'")      { |str| assert_equal "\\n",     str }
end
