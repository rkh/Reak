require File.expand_path('../../spec_helper', __FILE__)

describe Reak::Parser::AnsiSmalltalk do
  before { @parser = Reak::Parser::AnsiSmalltalk.new }

  describe "space" do
    subject { @parser.space }
    it { should parse(" ") }
    it { should parse("\n") }
    it { should parse("\t") }
    it { should parse(" \n\t \n") }
    it { should_not parse("") }
    it { should_not parse("x") }
    it { should_not parse(" x ") }
  end

  describe "space?" do
    subject { @parser.space? }
    it { should parse(" ") }
    it { should parse("\n") }
    it { should parse("\t") }
    it { should parse(" \n\t \n") }
    it { should parse("") }
    it { should_not parse("x") }
    it { should_not parse(" x ") }
  end

  describe "comment" do
    subject { @parser.comment }
    it { should parse('""') }
    it { should parse('" foo "') }
    it { should parse('"\'"') }
    it { should parse('""""') }
    it { should_not parse('"""') }
    it { should_not parse('"') }
    it { should_not parse('foo') }
    it { should_not parse('') }
    it { should_not parse('""foo""') }
    it { should_not parse(' "" ') }
  end

  describe "separator" do
    subject { @parser.separator }
    it { should parse(' ') }
    it { should parse("\t") }
    it { should parse("\n\t ") }
    it { should parse('"foo"') }
    it { should parse(' "foo" "bar" ') }
    it { should_not parse('') }
  end

  describe "separator?" do
    subject { @parser.separator? }
    it { should parse('') }
    it { should parse(' ') }
    it { should parse("\t") }
    it { should parse("\n\t ") }
    it { should parse('"foo"') }
    it { should parse(' "foo" "bar" ') }
  end

  describe "reserved_identifier" do
    subject { @parser.reserved_identifier }
    %w[true false nil self super].each do |keyword|
      it { should parse(keyword) }
      it { should_not parse(keyword.upcase) }
      it { should_not parse(keyword + " ") }
    end
    it { should_not parse("") }
    it { should_not parse(" ") }
    it { should_not parse("ifTrue:") }
  end

  describe "identifier" do
    subject { @parser.identifier }
    it { should parse('true') }
    it { should parse('foo') }
    it { should parse('no1') }
    it { should parse('OK') }
    it { should_not parse('') }
  end
  
  describe "capital_identifier" do
    subject { @parser.capital_identifier }
    it { should parse('Foo') }
    it { should_not parse('foo') }
  end
  
  describe "bindable_identifier" do
    subject { @parser.bindable_identifier }
    it { should parse('frue') }
    it { should parse('False') }
    it { should parse('no1') }
    it { should_not parse('false') }
    it { should_not parse('123') }
    it { should_not parse('true') }
  end

  describe "radix" do
    subject { @parser.radix }
    it { should parse('7r1') }
    it { should parse('16rb') }
    it { should parse('19r4f4') }
    it { should_not parse('4r') }
    it { should_not parse('r5') }
  end

  describe "integer" do
    subject { @parser.integer }
    it { should parse('5') }
    it { should parse('1478721382371823712831') }
    it { should parse('01') }
    it { should parse('7r1') }
    it { should parse('16rb') }
    it { should parse('19r4f4') }
    it { should_not parse('5.1') }
    it { should_not parse('4r') }
    it { should_not parse('r5') }
    it { should_not parse('1e2') }
  end

  describe "float" do
    subject { @parser.float }
    it { should parse('1.0') }
    it { should parse('1e1') }
    it { should parse('1q1') }
    it { should parse('1d1') }
    it { should parse('1.0e1') }
    it { should parse('-1e1') }
    it { should parse('1e-1') }
    it { should parse('-1e-1') }
    it { should_not parse('1q1.0') }
    it { should_not parse('1.0d1.0') }
    it { should_not parse('1') }
    it { should_not parse('1.') }
    it { should_not parse('.5') }
    it { should_not parse('') }
    it { should_not parse('e') }
    it { should_not parse('1e1e1') }
  end

  describe "scaled_decimal" do
    subject { @parser.scaled_decimal }
    it { should parse('5s1') }
    it { should parse('5.0s9') }
    it { should parse('-3.712s12') }
    it { should_not parse('5s1.0') }
    it { should_not parse('1.') }
    it { should_not parse('.5') }
    it { should_not parse('') }
    it { should_not parse('e') }
    it { should_not parse('1e1e1') }
  end

  describe "number" do
    subject { @parser.number }
    it { should parse('1.0') }
    it { should parse('1e1') }
    it { should parse('1q1') }
    it { should parse('1d1') }
    it { should parse('1.0e1') }
    it { should parse('-1e1') }
    it { should parse('1e-1') }
    it { should parse('-1e-1') }
    it { should parse('5') }
    it { should parse('1478721382371823712831') }
    it { should parse('01') }
    it { should parse('7r1') }
    it { should parse('16rb') }
    it { should parse('19r4f4') }
    it { should parse('5s1') }
    it { should parse('5.0s9') }
    it { should parse('-3.712s12') }
    it { should_not parse('1q1.0') }
    it { should_not parse('1.0d1.0') }
    it { should_not parse('5s1.0') }
    it { should_not parse('false') }
    it { should_not parse('4r') }
    it { should_not parse('r5') }
    it { should_not parse('1.') }
    it { should_not parse('.5') }
    it { should_not parse('') }
    it { should_not parse('e') }
    it { should_not parse('1e1e1') }
  end

  describe "string" do
    subject { @parser.string }
    it { should parse("''") }
    it { should parse("' foo '") }
    it { should parse("'\"'") }
    it { should parse("''''") }
    it { should_not parse("'''") }
    it { should_not parse("'") }
    it { should_not parse("foo") }
    it { should_not parse("") }
    it { should_not parse("''foo''") }
    it { should_not parse(" '' ") }
  end
  
  describe "binary_selector" do
    subject { @parser.binary_selector }
    it { should parse('+') }
    it { should parse('-') }
    it { should parse('--@') }
    it { should_not parse('@-') }
    it { should_not parse('x') }
    it { should_not parse('') }
  end

  describe "keyword" do
    subject { @parser.keyword }
    it { should parse('ifTrue:') }
    it { should_not parse('ifTrue') }
    it { should_not parse('') }
    it { should_not parse(':') }
  end

  describe "symbol_constant" do
    subject { @parser.symbol_constant }
    it { should parse('#foo') }
    it { should parse('#----') }
    it { should parse('#\' \'') }
    it { should parse('#foo:bar:') }
    it { should_not parse('#') }
    it { should_not parse('#foo:bar') }
    it { should_not parse('#9') }
  end

  describe "character_constant" do
    subject { @parser.character_constant }
    it { should parse('$f') }
    it { should parse('$ ') }
    it { should parse('$\'') }
    it { should parse('$$') }
    it { should parse('$"') }
    it { should_not parse('$ff') }
    it { should_not parse('$') }
    it { should_not parse('') }
  end

  describe "array_constant" do
    subject { @parser.array_constant }
    it { should parse('#()') }
    it { should parse('#( )') }
    it { should parse('#(\'ok\' 1 2 3 5r4 9.7 "foo" bar #bar)') }
    it { should parse('#((1 2) 3 #(4 5))') }
    it { should parse('#($a7$b3$c)') }
    it { should_not parse('') }
  end

  describe "literal" do
    subject { @parser.literal }
    it { should parse('#()') }
    it { should parse('#( )') }
    it { should parse('#(\'ok\' 1 2 3 5r4 9.7 "foo" bar #bar)') }
    it { should parse('#((1 2) 3 #(4 5))') }
    it { should parse('#($a7$b3$c)') }
    it { should parse('$f') }
    it { should parse('$ ') }
    it { should parse('$\'') }
    it { should parse('$$') }
    it { should parse('$"') }
    it { should parse('#foo') }
    it { should parse('#----') }
    it { should parse('#\' \'') }
    it { should parse('#foo:bar:') }
    it { should parse('1.0') }
    it { should parse('1e1') }
    it { should parse('1q1') }
    it { should parse('1d1') }
    it { should parse('1.0e1') }
    it { should parse('-1e1') }
    it { should parse('1e-1') }
    it { should parse('-1e-1') }
    it { should parse('5') }
    it { should parse('1478721382371823712831') }
    it { should parse('01') }
    it { should parse('7r1') }
    it { should parse('16rb') }
    it { should parse('19r4f4') }
    it { should parse('5s1') }
    it { should parse('5.0s9') }
    it { should parse('-3.712s12') }
    it { should_not parse('1.0d1.0') }
    it { should_not parse('1q1.0') }
    it { should_not parse('5s1.0') }
    it { should_not parse('4r') }
    it { should_not parse('r5') }
    it { should_not parse('1.') }
    it { should_not parse('.5') }
    it { should_not parse('') }
    it { should_not parse('e') }
    it { should_not parse('1e1e1') }
    it { should_not parse('+') }
    it { should_not parse('-') }
    it { should_not parse('--@') }
    it { should_not parse('ifTrue:') }
    it { should_not parse(':') }
    it { should_not parse('#') }
    it { should_not parse('#foo:bar') }
    it { should_not parse('#9') }
    it { should_not parse('$ff') }
    it { should_not parse('$') }
    it { should_not parse('') }
  end

  describe "variable_name" do
    subject { @parser.variable_name }
    it { should parse('frue') }
    it { should parse('False') }
    it { should parse('no1') }
    it { should_not parse('false') }
    it { should_not parse('123') }
    it { should_not parse('true') }
  end

  describe "primary" do
    subject { @parser.primary }
    pending
  end

  describe "assignment" do
    subject { @parser.assignment }
    it { should parse('foo _') }
    it { should parse('foo:=') }
    it { should parse("Foo\n:=") }
    it { should parse('b :=') }
    it { should_not parse('_') }
    it { should_not parse(' :=') }
    it { should_not parse('_ _') }
    it { should_not parse('foo') }
  end

  describe "message_expression" do
    subject { @parser.message_expression }
    it { should parse('foo bar') }
    it { should parse('foo bar: blah') }
    it { should parse('foo - bar') }
  end
  
  describe "keyword_expression" do
    subject { @parser.keyword_expression }
    it { should parse('obj foo: bar') }
    it { should parse('obj foo: bar blah: blubb') }
    it { should parse('1 + 2 ifFalse: 10') }
    it { should_not parse('obj') }
    it { should_not parse('foo: bar') }
    it { should_not parse('obj foo:') }
    it { should_not parse('foo bar') }
  end
  
  describe "binary_object" do
    subject { @parser.binary_object }
    it { should parse('true') }
    it { should parse('1 + 2') }
    it { should_not parse('') }
  end

  describe "binary_expression" do
    subject { @parser.binary_expression }
    it { should parse('foo - bar') }
    it { should parse('2 + 3') }
    it { should parse('#(1 2) << 2') }
    it { should parse('foo bar - bar') }
    it { should parse('foo - foo bar') }
    it { should parse('foo -> bar') }
    it { should_not parse('') }
    it { should_not parse('foo ++') }
    it { should_not parse('- 3') }
  end

  describe "unary_object" do
    subject { @parser.unary_object }
    it { should parse('$f') }
    it { should parse('foo') }
  end

  describe "unary_expression" do
    subject { @parser.unary_expression }
    it { should parse('$fclass') }
    it { should parse('$f class') }
    it { should parse('foo bar') }
    it { should_not parse('') }
  end

  describe "unary_send" do
    subject { @parser.unary_send }
    it { should parse('foo') }
    it { should_not parse('') }
  end

  describe "cascaded_message_expression" do
    subject { @parser.cascaded_message_expression }
    it { should parse('foo bar; yourself') }
    it { should parse('foo bar; blah: 10') }
    it { should parse('foo bar; foo: 10; bar: 20') }
    it { should parse('foo bar; become: #awesome ohyeah; yourself') }
  end
  
  describe "brace_expression" do
    subject { @parser.brace_expression }
    it { should parse('{ }') }
    it { should parse('{ 10 }') }
    it { should parse('{ foo bar; yourself. 3 + 4. }') }
    it { should_not parse('') }
  end

  describe "expression" do
    subject { @parser.expression }
    it { should parse('42') }
    it { should parse('foo') }
    it { should parse('foo bar') }
    it { should parse('(nil isNil) ifFalse: [self halt; yourself]') }
    it { should parse('1 + 2 ifFalse: 10') }
    it { should parse('true & false not & (nil isNil) ifFalse: [self halt; yourself]') }
    it { should parse('b := 10') }
    it { should parse('self size + super size + super class GlobalVariable') }
    it { should parse('b := self size + super size + super class GlobalVariable') }
    it { should_not parse('') }
  end

  describe "expressions" do
    subject { @parser.expressions }
    it { should parse('foo. bar.') }
    it { should parse('10. 20. 30.') }
    it { should parse('') }
    it { should parse('foo bar: 20.') }
    it { should parse('foo') }
    it { should parse('foo. bar') }
    it { should parse('true.') }
    it { should_not parse('foo. ^ bar') }
  end

  describe "statements" do
    subject { @parser.statements }
    it { should parse('') }
    it { should parse('foo.') }
    it { should parse('foo. bar') }
    it { should parse('foo. bar.') }
    it { should parse('true.') }
    it { should parse('^ x.') }
    it { pending; should parse('foo bar: blah. ^ false') }
  end

  describe "block_arguments" do
    subject { @parser.block_arguments }
    it { should parse(':foo |') }
    it { should_not parse('') }
  end

  describe "locals" do
    subject { @parser.locals }
    it { should parse('|foo|') }
    it { should parse('|foo bar|') }
    it { should parse('| foo |') }
    it { should parse('| foo bar |') }
    it { should_not parse('|foo,bar|') }
    it { should_not parse('foo bar') }
    it { should_not parse('|foo') }
    it { should_not parse('') }
  end
  
  describe "block" do
    subject { @parser.block }
    it { should parse('[ ]') }
    it { should parse('[ foo ]') }
    it { should parse('[ :foo | foo + 3. ]') }
    it { should parse('[ |foo| foo ]') }
    it { should parse('[|foo| foo ]') }
    it { should parse('[ :foo | |bar| foo + bar ]') }
    it { should parse('[:f||b|]') }
    it { should parse('[ ^ true become: false ]') }
    it do
      should parse <<-Smalltalk.strip
        [ :some | |a b c|
          "A method to illustrate some syntax"
          true & false not & (nil isNil) ifFalse: [self halt; yourself].
          b := self size + super size + super class GlobalVariable.
          (#($a #a 'a' 1 1.0) addAll: { some . 1.2e10 . 2r101 })
            do: [:each | Transcript
              show: (each class name);
              show: (each printString);
              show: ' '].
          ^ x < y
        ]
      Smalltalk
    end
    it { should_not parse('[||foo| ]') }
    it { should_not parse('') }
  end

  describe "method_header" do
    subject { @parser.method_header }
    it { should parse('foo') }
    it { should parse('~+~ other') }
    it { should parse('foo: aFoo bar: aBar') }
    it { should_not parse('foo: true') }
    it { should_not parse('foo: aFoo bar') }
    it { should_not parse('') }
  end
end
