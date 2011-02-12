module Reak
  module AST
    module Node
      module ClassMethods
        extend  Reak::Tools
        include Reak::Tools

        def grammar_for(dialect, g)
          method = smalltalk_prefix "#{dialect}Grammar:"
          rule   = respond_to?(method) ? send(method, g) : grammar(g)
          rule.set_action method(:action)
          define_rule(g, rule)
        end

        def define_rule(g, rule)
          g.set rule_name, rule
          rule_name.to_sym
        end

        def action(*args)
          line = 1
          action = smalltalk_prefix 'for:' << 'with:' * args.count
          send(action, line, *args)
        end

        def rule_name
          name[/[^:]+$/].downcase
        end

        def bootstrap_grammar(g)
          raise NotImplementedError, 'subclass responsibility'
        end

        def grammar(g)
          bootstrap_grammar(g)
        end

        smalltalk_expose 'bootstrap_grammar', 'bootstrapGrammar:'
        smalltalk_expose 'grammar',           'grammar:'

        ruby_expose 'new:',       'new'
        ruby_expose 'new:with:',  'new'
      end

      def self.append_features(base)
        base.extend ClassMethods
        super
      end
    end

    class Base < Rubinius::AST::Node
      include Node

      def bytecode(g)
        raise NotImplementedError, 'subclass responsibility'
      end
    end

    class Bucket < Base
      def self.register(*list)
        self.list.unshift(*list).uniq!
      end

      def self.grammar_for(dialect, g)
        rules = list.map { |e| e.grammar_for(dialect, g) }
        define_rule g, g.any(*rules)
      end

      def self.list
        @list ||= []
      end
    end

    class Expression < Bucket
    end

    class Primary < Bucket
      Expression.register self
    end
  end
end
