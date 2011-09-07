class Module
  include Reak::Tools
  extend Reak::Tools

  def define_smalltalk_method(name, &block)
    define_method(smalltalk_prefix(name), &block)
  end
end
