module Reak
  module AST
    class ScopedConstant < Rubinius::AST::ScopedConstant
      include Reak::AST::Node
      Primary.insert_before self, ConstantAccess

      def self.bootstrap_grammar(g)
        g.seq :constantaccess, g.many(g.seq('.', g.t(:constantaccess)))
      end

      def self.action(*parents)
        parents.flatten.inject do |parent, const|
          new 1, parent, const.name
        end
      end
    end
  end
end
