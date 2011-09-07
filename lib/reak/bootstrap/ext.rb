class Module
  include Reak::Tools
  extend Reak::Tools

  def define_smalltalk_method(name, &block)
    puts name
    define_method(smalltalk_prefix(name), &block)
  end
end
