module Smalltalk
  Object = ::Object unless const_defined? :Object
  class Object
    def send_reak(method, *args)
      __send__ Reak.prefixed_method(method), *args
    end

    def send_splat(method, args)
      __send__ method, *args.to_a
    end

    def respond_to_reak?(method)
      respond_to? Reak.prefixed_method(method)
    end

    0.upto(4) do |i|
      name = 'rubyPerform:' << ('with:'*i)
      alias_method Reak.prefixed_method(name), '__send__'
    end

    alias_method Reak.prefixed_method('rubyPerform:withArgs:'), 'send_splat'
  end
end
