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
          g.set rule_name, rule
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
      end

      def self.append_features(base)
        base.extend ClassMethods
        super
      end

      def self.to_class
        Reak::AST::Base
      end
    end

    def self.Node(type)
      Class.new Rubinius::AST.const_get(type) do
        def self.inherited(base)
          # intentionally not calling super, just so you know
          base.set_superclass superclass
          base.send(:include, Reak::AST::Node)
        end
      end
    end

    class Base < Rubinius::AST::Node
      include Node

      def bytecode(g)
        raise NotImplementedError, 'subclass responsibility'
      end
    end
  end
end
