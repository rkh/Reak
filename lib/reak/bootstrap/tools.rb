module Reak
  def self.smalltalk_expose(obj, ruby, smalltalk = ruby, args = smalltalk.to_s.count(':'))
    super ruby, smalltalk, args, obj
  end

  module Tools
    extend_object Reak
    SMALLTALK_PREFIX = "(st) "

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
    # Checks whether a method is a smalltalk method.
    #
    # Example:
    #
    #   Reak.smalltalk_method? 'foo'                        # => false
    #   Reak.smalltalk_method? Reak.smalltalk_prefix('foo') # => true
    def smalltalk_method?(name)
      name.start_with? SMALLTALK_PREFIX
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
      smalltalk = smalltalk_prefix(smalltalk)
      obj.send :alias_method, smalltalk, ruby
      obj.send :private, smalltalk
      soft_alias ruby, smalltalk, args, caller.first, obj
    end

    ##
    # Create late bound alias in Smalltalk for a Ruby method.
    #
    # This Ruby code:
    #
    #   ruby_expose 'foo:', 'foo'
    #
    # Does about the same as this Smalltalk code:
    #
    #   foo: someValue [ self rubyPerform: #foo with: someValue ]
    def ruby_expose(smalltalk, ruby = smalltalk, args = smalltalk.to_s.count(':'), obj = self)
      smalltalk = smalltalk_prefix(smalltalk)
      cm = soft_alias smalltalk, ruby, args, caller.first, obj
      obj.send :private, smalltalk
      cm
    end

    ##
    # Parses, compiles and executes given string as Smalltalk code.
    #
    # Example:
    #   Reak.eval_smalltalk "'I''m a String!'"
    def eval_smalltalk(code, file = '(file)', line = 1)
      cm       = Rubinius::Compiler.compile_eval(code, binding.variables, file, line)
      cm.scope = binding.static_scope.dup
      cm.name  = :__smalltalk__
      script   = Rubinius::CompiledMethod::Script.new(cm, file, true)
      be       = Rubinius::BlockEnvironment.new

      script.eval_binding = binding
      script.eval_source  = code
      cm.scope.script     = script

      be.under_context(binding.variables, cm)
      be.from_eval!
      be.call
    end

    private

    def soft_alias(from, to, args, location, obj)
      file, line = location.split ':'

      cm = obj.dynamic_method from.to_sym, file, line do |g|
        g.push_self
        0.upto(args - 1) { |i| g.push_local i }
        g.send to.to_sym, args, true
        g.ret
      end

      cm.required_args = args
      cm.total_args    = args

      cm
    end
  end
end
