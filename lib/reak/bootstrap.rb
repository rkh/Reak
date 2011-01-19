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

class Object
  reak_alias :class
  reak_def("=") { |other| self == other }
  reak_def("printString") { "a RubyObject(#{inspect})" }

  def reak_send(name, *args)
    __send__ "reak:#{name}", *args
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
  end

  class SequenceableCollection < Collection
  end

  class ArrayedCollection < Array
  end

  class Array < ArrayedCollection
  end
end
