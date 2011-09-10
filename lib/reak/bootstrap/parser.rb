module Reak
  class Parser
    class ParseError < RuntimeError
      def initialize(parser, match, file)
        super "#{file}: #{parser.expectation}"
        @file   = file
        @parser = parser
        @match  = match
      end

      attr_reader :parser, :match
    end

    attr_accessor :dialect, :file, :line

    def initialize(dialect, file, line = 1)
      @dialect, @file, @line = dialect, file, line
      @grammar = Reak::AST.grammar_for dialect
    end

    def parse_file(log = false)
      parse_string(File.read(@file), @file, log)
    end

    def parse_string(input, file = '(eval)', log = false)
      parser = KPeg::Parser.new(input, @grammar, log)
      match  = parser.parse
      raise ParseError.new(parser, match, file) if parser.failed?
      match.value if match
    end
  end
end
