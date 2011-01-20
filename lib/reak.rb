require 'backports'
require 'reak/bootstrap'

module Reak
  autoload :Code,       'reak/code'
  autoload :Compiler,   'reak/compiler'
  autoload :Generator,  'reak/generator'
  autoload :Parser,     'reak/parser'
  autoload :Script,     'reak/script'
  autoload :Syntax,     'reak/syntax'

  def self.prefixed_method(name)
    "reak:#{name}"
  end
end
