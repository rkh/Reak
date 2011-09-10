module Reak
  module AST
    class KeywordMethodDefinition < KeywordSend
      include MethodDefinition
      Expression.unshift self

      def self.action(receiver, method_and_args, iter)
        receiver = Rubinius::AST::Self.new(1) if receiver == []
        super(receiver, method_and_args, iter)
      end

      def initialize(line, receiver, name, arguments, block = nil)
        raise SyntaxError, 'expected block for method definition' unless block
        block.body.array << Rubinius::AST::Self.new(1)
        super(line, receiver, smalltalk_prefix('defineMethod:'), [string(line, name)], block)

        if arguments.count > 0
          arguments.map! do |var|
            Rubinius::AST::LocalVariableAssignment.new(line, var.to_sym, nil)
          end

          arglist = Rubinius::AST::ArrayLiteral.new(line, arguments)

          real_args               = block.arguments
          real_args.splat_index   = nil
          real_args.required_args = arguments.count
          real_args.arity         = arguments.count
          real_args.prelude       = arguments.count > 1 ? :multi : :single
          real_args.arguments     = Rubinius::AST::MultipleAssignment.new(line, arglist, nil, nil)
        end
      end
    end
  end
end
