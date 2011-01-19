module Reak
  module Parser
    class Smalltalk80 < AnsiSmalltalk
      def keywords
        super << `thisContext`
      end
    end
  end
end
