# Plan is to move everything in here to Smalltalk.
# Therefore this file is intentionally kept ugly, so I'll stay annoyed by its existence.

class Module
  def reak_alias(reak_name, ruby_name = nil)
    Array(reak_name).each do |reak|
      ruby = ruby_name || reak
      alias_method "reak:#{reak}", ruby
    end
  end

  def reak_def(name, &block)
    define_method("reak:#{name}", &block)
  end
end

module DoesNotUnderstand
  def method_missing(name, *args)
    if name.to_s =~ /\Areak:(.*)\Z/
      reak_send "doesNotUnderstand:", Smalltalk::FailedMessage.new(name, args)
    else
      super
    end
  end
end

class Object
  include DoesNotUnderstand

  def reak_send(name, *args)
    __send__ "reak:#{name}", *args
  end

  reak_alias [:class, :hash]
  reak_alias :isNil, :nil?
  reak_alias "isKindOf:", :kind_of?
  reak_alias :copy, :dup
  reak_alias ["perform:", "perform:with:", "perform:with:with:", "perform:with:with:with:"], :reak_send
  reak_alias ["rubyPerform:", "rubyPerform:with:", "rubyPerform:with:with:", "rubyPerform:with:with:with:"], :__send__
  reak_alias :==, :equal?
  reak_alias :identityHash, :object_id

  reak_def("=") { |other| self == other }
  reak_def("~=") { |other| not reak_send("=", other) }
  reak_def("~~") { |other| not reak_send("==", other) }
  reak_def("printString") { "a RubyObject(#{inspect})" }
  reak_def("yourself") { self }
  reak_def("printOn:") { fail "not yet implemented" }
  reak_def("isMemberOf:") { |klass| self.class == klass }

  reak_def("respondTo:") { |name| respond_to? "reak:#{name}" }
  reak_def("notNil") { not reak_send("isNil") }

  reak_def("doesNotUnderstand:") do |msg|
    raise NameError, "Does not understand Smalltalk method #{msg}"
  end
end

class Fixnum
  reak_alias [:+, :-, :<, :>]
  reak_alias :printString, :inspect
end

module Boolean
  append_features FalseClass
  append_features TrueClass
  reak_alias :printString, :inspect
end

class NilClass
  reak_alias :printString, :inspect
  reak_alias :isNil, :nil?
end

class Symbol
  reak_def("printString") do
    str = inspect[1..-1]
    if str[0] == ?"
      "#'#{str[1..-2].gsub("'", "''")}'"
    else
      "##{str}"
    end
  end
end

module Smalltalk
  class Collection
    attr_accessor :raw
    def initialize(raw)
      @raw = raw
    end

    def to_a
      raw.to_a
    end
  end

  class SequenceableCollection < Collection
    reak_def(:printString) do
      "a #{self.class.name[/[^:]+\Z/]}(#{inner_inspect})"
    end

    def inner_inspect
      @raw.map { |e| e.reak_send(:printString) }.join " "
    end
  end

  class ArrayedCollection < SequenceableCollection
  end

  class Array < ArrayedCollection
    def self.from_array(ary)
      Rubinius::Tuple[*ary]
    end

    reak_def(:printString) do
      "#(#{inner_inspect})"
    end
  end

  class FailedMessage
    attr_accessor :selector, :arguments

    def initialize(selector, arguments)
      @selector = selector
      @arguments = Smalltalk::Array.from_array arguments
    end

    reak_alias [:selector, :arguments]
    alias to_s selector
  end

  class ScaledDecimal
    attr_accessor :value, :scale
    def initialize(value, scale)
      @value = value
      @scale = scale
    end

    reak_def(:printString) do
      str = value.to_s
      major, minor = str[0..-(scale+1)], str[-scale..-1]
      "#{major}.#{minor}s#{scale}"
    end
  end
end
