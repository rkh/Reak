module Reak
  class Compiler < Rubinius::Compiler
    class Parser < Rubinius::Compiler::Parser
      def initialize(compiler, last)
        super
        @processor = Reak::Parser
      end

      def create
        # TODO: we totally ignore @transforms
        @parser = @processor.new(@compiler.dialect, @file, @line)
        @parser
      end
    end

    class FileParser < Parser
      stage :reak_file
      next_stage Generator

      def input(file, line = 1)
        @file = file
        @line = line
      end

      def parse
        create.parse_file
      end
    end

    class StringParser < Parser
      stage :reak_string
      next_stage Generator

      def input(string, name = "(eval)", line = 1)
        @input = string
        @file = name
        @line = line
      end

      def parse
        create.parse_string(@input)
      end
    end

    metaclass.send(:attr_accessor, :dialect)
    @dialect = :reak

    DIALECT_MAP = Hash.new { |h, k| h[k] = Class.new(self) { @dialect = k }}
    DIALECT_MAP[:reak] = self

    def self.[](dialect)
      DIALECT_MAP[dialect.to_sym]
    end

    def self.compiled_name(file)
      file + (file.suffix?(".st") ? "c"  : ".compiled.stc")
    end

    def initialize(from, to)
      super map_stage(from), map_stage(to)
    end

    def map_stage(stage)
      mapped = :"reak_#{stage}"
      Stages.include?(mapped) ? mapped : stage
    end
  end
end
