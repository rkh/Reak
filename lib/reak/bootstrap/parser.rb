module Reak
  class Parser
    class ParseError < RuntimeError
      def initialize(parser, match)
        super parser.error_expectation
        @parser = parser
        @match = match
      end

      attr_reader :parser, :match
    end

    attr_accessor :dialect, :file, :line

    def initialize(dialect, file, line = 1)
      @dialect, @file, @line = dialect, file, line
      @grammar = Reak::AST.grammar_for dialect
    end

    def parse_file
      parse_string File.read(@file)
    end

    def parse_string(input)
      parser = KPeg::Parser.new(input, @grammar)
      match  = parser.parse
      raise ParseError.new(parser, match) if parser.failed?
      match.value if match
    end
  end
end
