module Reak
  def self.smalltalk_expose(obj, ruby, smalltalk = ruby, args = smalltalk.to_s.count(':'))
    super ruby, smalltalk, args, obj
  end

  module Tools
    extend_object Reak
    SMALLTALK_PREFIX = "st: "

    ##
    # Internally Smalltalk methods are mapped to Ruby methods with a prefix,
    # avoiding method name clashes. Internally Ruby methods names may be any
    # valid symbol (thus about any string without a null byte), but those
    # methods cannot be called directly nor defined with "def" from within
    # Ruby. The naming logic is encapsulated here.
    def smalltalk_prefix(name, check = true)
      if check and name.to_s.start_with? SMALLTALK_PREFIX
        name.to_sym
      else
        :"#{SMALLTALK_PREFIX}#{name}"
      end
    end

    ##
    # Take a Ruby method, alias it to Smalltalk method and override it with a
    # new Ruby method calling that Smalltalk method, thus avoiding a hard
    # alias and allowing overriding the method in smalltalk.
    #
    # Example:
    #
    # In Ruby:
    #
    #   class MyClass
    #     def foo(i) i + 1 end
    #
    #     Reak.smalltalk_expose MyClass, "foo", "bar:"
    #
    #     # alternative:
    #     #   extend Reak::Tools
    #     #   smalltalk_expose "foo", "bar:"
    #   end
    #
    # In Smalltalk:
    #
    #   Ruby.MyClass subclass: MyFancyClass [
    #     bar: i [ i + 2 ]
    #   ]
    #
    # In Ruby:
    #
    #   Smalltalk::MyFancyClass.new.foo 3 # => 5
    def smalltalk_expose(ruby, smalltalk = ruby, args = smalltalk.to_s.count(':'), obj = self)
      file, line = caller.first.split ':'
      smalltalk  = smalltalk_prefix(smalltalk)

      obj.send :alias_method, smalltalk, ruby
      cm = obj.dynamic_method ruby, file, line do |g|
        g.push_self
        0.upto(args - 1) { |i| g.push_local i }
        g.send smalltalk, args
        g.ret
      end

      cm.required_args = args
      cm.total_args    = args
    end
  end
end
