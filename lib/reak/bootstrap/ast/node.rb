module Reak
  module AST
    module Node
      module ClassMethods
        extend  Reak::Tools
        include Reak::Tools

        def grammar_for(dialect, g)
          method = smalltalk_prefix "#{dialect}Grammar:"
          rule   = respond_to?(method) ? send(method, g) : grammar(g)
          set_action(rule)
          define_rule(g, rule)
        end

        def nil_literal(line)
          if Reak::AST.const_defined? :NilLiteral
            literal = Reak::AST::NilLiteral
          else
            literal = Rubinius::AST::NilLiteral
          end
          literal.new(line)
        end

        def set_action(rule)
          rule.set_action method(:action)
        end

        def define_rule(g, rule)
          g.set rule_name.to_s, rule
          rule_name
        end

        def action(*args)
          line = 1
          action = smalltalk_prefix 'for:' << 'with:' * args.count
          send(action, line, *args)
        end

        def rule_name
          name[/[^:]+$/].downcase.to_sym
        end

        def bootstrap_grammar(g)
          raise NotImplementedError, 'subclass responsibility'
        end

        def grammar(g)
          bootstrap_grammar(g)
        end

        def inherited(subclass)
          Node.nodes << subclass
          super
        end

        smalltalk_expose 'bootstrap_grammar', 'bootstrapGrammar:'
        smalltalk_expose 'grammar',           'grammar:'
        smalltalk_expose 'grammar_for',       'grammar:for:'

        ruby_expose 'new:',       'new'
        ruby_expose 'new:with:',  'new'
      end

      def nil_literal(line)
        self.class.nil_literal(line)
      end

      metaclass.send(:attr_accessor, :nodes)
      self.nodes ||= []

      def self.append_features(base)
        nodes << base
        base.extend ClassMethods
        base.metaclass.extend Reak::Tools
        super
      end
    end

    class Base < Rubinius::AST::Node
      include Node

      def self.grammar_for(*)
        super unless self == Base
      end

      def self.bytecode(g)
        raise NotImplementedError, 'subclass responsibility'
      end
    end

    class Bucket < Base
      def self.unshift(*nodes)
        list.unshift(*nodes).uniq!
      end

      def self.push(*nodes)
        list.push(*nodes).uniq!
      end

      def self.insert_before(node, before)
        list.insert list.index(before), node
      end

      def self.insert_after(node, after)
        list.insert list.index(after) + 1, node
      end

      def self.grammar_for(dialect, g)
        return if self == Bucket
        super
      end

      def self.bootstrap_grammar(g)
        g.any(*list.map { |e| e.rule_name })
      end

      def self.set_action(*)
      end

      def self.list
        @list ||= []
      end

      class << self
        smalltalk_expose 'unshift',       'unshift:'
        smalltalk_expose 'push',          'push:'
        smalltalk_expose 'insert_before', 'insert:before:'
      end
    end

    class Expression < Bucket
      def self.bootstrap_grammar(g)
        g.seq :sp, g.t(super), :sp
      end
    end

    class Primary < Bucket
      Expression.push self
    end
  end
end
