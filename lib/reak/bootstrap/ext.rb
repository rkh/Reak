module Reak
  module Ext
    module Module
      include Reak::Tools
      append_features ::Module

      def define_smalltalk_method(name, &block)
        define_method(smalltalk_prefix(name), &block)
      end
    end

    module Class
      append_features ::Class

      def subclass(name = nil, container = Object, &block)
        subclass = ::Class.new(self)
        container.const_set(name, subclass) if name
        subclass.class_eval(&block) if block
        subclass
      end
    end
  end
end
