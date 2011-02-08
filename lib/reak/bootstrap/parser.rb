module Reak
  class Parser
    attr_accessor :file, :line

    def initialize(grammar, file, line = 1)
      @grammar, @file, @line = grammar, file, line
    end

    def parse_file
      parse_string File.read(@file)
    end

    def parse_string(input)
      raise NotImplementedError
    end
  end
end
