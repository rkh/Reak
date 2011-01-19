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
  reak_def("=") { |other| self == other }
end

class Fixnum
  reak_alias [:+, :-, :<, :>]
end

module Smalltalk
end
