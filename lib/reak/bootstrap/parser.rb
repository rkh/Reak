module Reak
  class Parser
    attr_accessor :file, :line

    def initialize(file, line = 1)
      @file, @line = file, line
    end

    def parse_file
      parse_string File.read(@file)
    end

    def parse_string(input)
      raise NotImplementedError
    end
  end
end
