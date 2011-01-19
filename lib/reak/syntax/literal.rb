module Reak
  module Syntax
    class Literal < Node
      attr_accessor :value
      unfold

      def self.reuse(multiple = false)
        if multiple
          @reuse = {}
          def self.new(arg)
            @reuse[arg] ||= super
          end
        else
          def self.new
            @singleton ||= super
          end
        end
      end

      def to_i
        value.to_i
      end

      def to_s
        value.to_s
      end

      def to_f
        value.to_f
      end

      def to_sym
        value.to_sym
      end

      def initialize(value)
        @value = value
      end

      def to_sexp
        [:lit, @value]
      end

      def visit(visitor)
        visitor.literal self
      end

      def unclosure
        self
      end
    end

    class NilKind < Literal
      reuse

      def initialize
        super nil
      end

      def visit(visitor)
        visitor.nil_kind self
      end
    end

    class TrueKind < Literal
      reuse

      def initialize
        super true
      end

      def visit(visitor)
        visitor.true_kind self
      end
    end

    class FalseKind < Literal
      reuse

      def initialize
        super false
      end

      def visit(visitor)
        visitor.false_kind self
      end
    end

    class Integer < Literal
      def initialize(value, radix = 10)
        radix = radix.to_i
        prefix = radix < 0 ? -1 : 1
        super radix == 10 ? value.to_i : value.to_s.to_inum(radix * prefix, true)
        @value *= prefix
      end

      def to_f
        to_i.to_f
      end
    end

    class Symbol < Literal
      reuse :multiple

      def initialize(value)
        super value.to_sym
      end
    end

    class Float < Literal
      def initialize(value)
        super value.to_f
      end
    end

    class Character < Literal
      reuse :multiple

      def initialize(value)
        super value.to_sym
      end

      def to_sexp
        [:char, @value]
      end
    end

    class Array < Literal
      alias to_a value
      alias values value

      def visit(visitor)
        visitor.array self
      end

      def initialize(values)
        super Array(values).select { |v| Node === v }
      end

      def to_sexp
        [:array].concat values.map { |v| v.to_sexp }
      end
    end

    class String < Literal
      def initialize(value)
        super value.to_s
      end
    end
    
    class ScaledDecimal < Literal
      attr_accessor :scale

      def initialize(major, minor, scale)
        @scale = scale.to_i
        super(major.to_i * (10 ** @scale) + minor.ljust(@scale, '0')[0,@scale].to_i)
      end

      def visit(visitor)
        visitor.scaled_decimal self
      end

      def to_sexp
        [:scaled_decimal, value, scale]
      end
    end
  end
end