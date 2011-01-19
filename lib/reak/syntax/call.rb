module Reak
  module Syntax
    class Call < Node
      attr_accessor :message, :reciever
      unfold

      def self.new(*args)
        return super if self != Call or args.size != 2
        reciever, message = args
        # Other messages we may override:
        #   to:do: == basicAt: basicSize
        #   to:by:do: timesRepeat: basicAt:put: basicNew:
        case message.selector
        when 'ifTrue:', 'ifTrue:ifFalse:'
          Branch.new(reciever, message.args[0], message.args[1])
        when 'ifFalse:', 'ifFalse:ifTrue:'
          Branch.new(reciever, message.args[1], message.args[0])
        when 'and:'
          And.new(reciever, message.args[0])
        when 'or:'
          Or.new(reciever, message.args[0])
        else
          Super === reciever ? SuperCall.new(reciever, message) : super
        end
      end

      def initialize(reciever, message)
        @message = message
        @reciever = reciever
      end

      def to_sexp
        [:call, reciever.to_sexp, message.to_sexp]
      end

      def visit(visitor)
        reciever.visit visitor
        message.visit visitor
      end
    end

    class SuperCall < Call
      def to_sexp
        [:super_call, message.to_sexp]
      end
    end

    class Branch < Call
      attr_accessor :condition, :positive, :negative

      def self.new(condition, positive, negative)
        positive =  positive.unclosure if positive
        negative = negative.unclosure if negative
        case condition
        when TrueKind  then positive ? positive : NilKind.new
        when FalseKind then negative ? negative : NilKind.new
        else super(condition, positive, negative)
        end
      end

      def initialize(condition, positive, negative)
        @condition  = condition
        @positive   = positive
        @negative   = negative
      end

      def to_sexp
        [:if, condition.to_sexp, (positive.to_sexp if positive), (negative.to_sexp if negative)]
      end
    end

    class And < Call
      attr_accessor :first, :second

      def self.new(first, second)
        case [self, first.class]
        when [And, TrueKind], [Or, FalseKind] then second.unclosure
        when [And, FalseKind], [Or, TrueKind] then first
        else super
        end
      end

      def initialize(first, second)
        @first  = first
        @second = second.unclosure if second
      end

      def to_sexp
        [:and, (first.to_sexp if first), (second.to_sexp if second)]
      end
    end

    class Or < And
      def to_sexp
        [:or, first.to_sexp, second.to_sexp]
      end
    end

    class Cascade < Call
      alias messages message
      def self.new(reciever, messages)
        return super unless Super === reciever or Self === reciever
        Body.new nil, messages.map { |m| Call.new(reciever, m) }
      end

      def to_sexp
        [:cascade, reciever.to_sexp].concat messages.map { |m| m.to_sexp }
      end
    end
  end
end
