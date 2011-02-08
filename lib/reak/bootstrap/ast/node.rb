module Reak
  module AST
    module Node
      module ClassMethods
        extend  Reak::Tools
        include Reak::Tools

        def grammar_for(syntax, g)
          method = smalltalk_prefix "#{syntax}Grammar:"
          respond_to?(method) ? send(method, g) : grammar(g)
        end

        def bootstrap_grammar(g)
          raise NotImplementedError, 'subclass responsibility'
        end

        def grammar(g)
          bootstrap_grammar(g)
        end

        smalltalk_expose 'bootrap_grammar', 'bootstrapGrammar:'
        smalltalk_expose 'grammar',         'grammar:'
      end

      def bytecode(g)
        raise NotImplementedError, 'subclass responsibility'
      end

      def self.append_features(base)
        base.extend ClassMethods
        super
      end
    end
  end
end
