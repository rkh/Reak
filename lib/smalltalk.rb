require 'mathn'
require 'backports'
require 'reak'

module Smalltalk
  Behavior      = ::Module      unless const_defined? :Behavior
  BlockClosure  = ::Proc        unless const_defined? :BlockClosure
  Class         = ::Class       unless const_defined? :Class
  False         = ::FalseClass  unless const_defined? :False
  Float         = ::Float       unless const_defined? :Float
  FloatD        = ::Float       unless const_defined? :FloatD
  FloatE        = ::Float       unless const_defined? :FloatE
  FloatQ        = ::Float       unless const_defined? :FloatQ
  Fraction      = ::Rational    unless const_defined? :Rational
  Integer       = ::Integer     unless const_defined? :Integer
  LargeInteger  = ::Bignum      unless const_defined? :Bignum
  Object        = ::Object      unless const_defined? :Object
  Magnitude     = ::Comparable  unless const_defined? :Magnitude
  Nil           = ::NilClass    unless const_defined? :Nil
  Number        = ::Numeric     unless const_defined? :Number
  SmallInteger  = ::Fixnum      unless const_defined? :SmallInteger
  True          = ::TrueClass   unless const_defined? :True

  class Behavior
    def smalltalk_alias(from, to = from)
      alias_method Reak.prefixed_method('rubyPerform:withArgs:'), to
    end

    def smalltalk_singleton_alias(from, to = from)
      singleton_class.smalltalk_alias from, to
    end

    def smalltalk_superclass
      @smalltalk_superclass || Object
    end

    def inherit_smalltalk(base)
      @smalltalk_superclass = base
      include base unless base.is_a? Class
    end
  end

  module BlockClosure
    def call_splat(ary)
      call(*ary.to_a)
    end
  end

  module Boolean
    True.inherit_smalltalk self
    False.inherit_smalltalk self
  end

  module ClassDescription
    inherit_smalltalk Behavior
  end

  class Class
    inherit_smalltalk ClassDescription

    def smalltalk_superclass
      @smalltalk_superclass || superclass
    end
  end

  class Object
    def send_smalltalk(method, *args)
      __send__ Reak.prefixed_method(method), *args
    end

    def send_splat(method, args)
      __send__ method, *args.to_a
    end

    def respond_to_reak?(method)
      respond_to? Reak.prefixed_method(method)
    end

    smalltalk_alias 'rubyPerform:',                     'send'
    smalltalk_alias 'rubyPerform:with:',                'send'
    smalltalk_alias 'rubyPerform:with:with:',           'send'
    smalltalk_alias 'rubyPerform:with:with:with:',      'send'
    smalltalk_alias 'rubyPerform:with:with:with:with:', 'send'
    smalltalk_alias 'rubyPerform:withArgs:',            'send_splat'
  end

  module Magnitude
    def <=>(other)
      send_smalltalk :<=>, other
    end
  end

  class Number
    inherit_smalltalk Magnitude
  end

  module Ruby
    def self.all_subinstances_of_do(klass, block)
      ObjectSpace.each_object(klass, &block)
    end

    smalltalk_singleton_alias 'allSubinstancesOf:do:', 'all_subinstances_of_do'
  end

  module Valueable
    BlockClosure.inherit_smalltalk self
  end
end