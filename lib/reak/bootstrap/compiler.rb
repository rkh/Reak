module Reak
  class Compiler < Rubinius::Compiler
    module Reakify
      Rubinius::Compiler::Stage.extend self

      def new(compiler, *args, &block)
        if compiler.is_a? Reak::Compiler and name =~ /^Rubinius::Compiler::([^:]+)$/
          const = Reak::Compiler.const_get($1)
          return const.new(compiler, *args, &block) if const != self
        end
        super
      end
    end

    class Parser < Rubinius::Compiler::Parser
      def initialize(compiler, last)
        super
        @compiler  = compiler
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
      next_stage Rubinius::Compiler::Generator

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
      next_stage Rubinius::Compiler::Generator

      def input(string, name = "(eval)", line = 1)
        @input = string
        @file = name
        @line = line
      end

      def parse
        create.parse_string(@input)
      end
    end

    class EvalParser < StringParser
      stage :reak_eval
      next_stage Rubinius::Compiler::Generator

      def should_cache?
        @output.should_cache?
      end
    end

    class Writer < Rubinius::Compiler::Writer
      def initialize(compiler, last)
        super
        @signature = Reak::Signature
      end
    end

    singleton_class.send(:attr_accessor, :dialect)
    @dialect = :reak

    DIALECT_MAP = Hash.new { |h, k| h[k] = Class.new(self) { @dialect = k }}
    DIALECT_MAP[:reak] = self

    def self.[](dialect)
      DIALECT_MAP[dialect.to_sym]
    end

    def dialect
      self.class.dialect
    end
  end
end
