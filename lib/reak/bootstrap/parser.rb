module Reak
  class Parser
    attr_accessor :dialect, :file, :line

    def initialize(dialect, file, line = 1)
      @dialect, @file, @line = dialect, file, line
    end

    def parse_file
      parse_string File.read(@file)
    end

    def parse_string(input)
      raise NotImplementedError
    end
  end
end
