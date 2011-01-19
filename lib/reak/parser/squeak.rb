module Reak
  module Parser
    class Squeak < Smalltalk80
      def keywords
        super << `homeContext`
      end
    end
  end
end
