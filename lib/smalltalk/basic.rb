module Smalltalk
  Nil   = ::NilClass    unless const_defined? :Nil
  True  = ::TrueClass   unless const_defined? :True
  False = ::FalseClass  unless const_defined? :False

  module Boolean
    append_features True
    append_features False
  end
end
