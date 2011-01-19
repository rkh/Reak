require 'parslet'

module Reak
  ##
  # Collection of PEG grammars for different Smalltalk dialects.
  # Included dialects and their inheritance:
  #
  #   AnsiSmalltalk
  #    \- Smalltalk80
  #       |- GnuSmalltalk
  #       |  \- ReakSmalltalk (default)
  #       |- Squeak
  #       |  \- Pharo
  #       \- SmalltalkInterchangeFormat
  #
  # The implementations are not 100% correct. For instance, the AnsiSmalltalk parser makes decissions that are clearly
  # marked implementation specific in the specs. However, I tried to move everything that is not part of AnsiSmalltalk
  # into Smalltalk80.
  #
  # See also:
  # * http://wiki.squeak.org/squeak/uploads/172/standard_v1_9-indexed.pdf
  # * http://chronos-st.blogspot.com/2007/12/smalltalk-in-one-page.html
  # * http://www.fit.vutbr.cz/study/courses/OMP/public/software/sqcdrom2/Squeak_Swiki/409.html
  module Parser
    autoload :AnsiSmalltalk,  'reak/parser/ansi_smalltalk'
    autoload :Smalltalk80,    'reak/parser/smalltalk80'
    autoload :GnuSmalltalk,   'reak/parser/gnu_smalltalk'
    autoload :ReakSmalltalk,  'reak/parser/reak_smalltalk'
    autoload :Transformer,    'reak/parser/transformer'

    def self.new(syntax = :reak, *args)
      case syntax.to_sym
      when :ansi      then AnsiSmalltalk.new(*args)
      when :reak, nil then ReakSmalltalk.new(*args)
      when :gst, :gnu then GnuSmalltalk.new(*args)
      else fail "unkown syntax #{syntax.inspect}"
      end
    end
  end
end
