module Reak
  module Ext
    module Module
      include Reak::Tools
      append_features ::Module

      def define_smalltalk_method(name, &block)
        define_method(smalltalk_prefix(name), &block)
      end
    end
  end
end
