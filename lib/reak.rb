require 'kpeg'

module Reak
  # set up ruby stuff
  require 'reak/version'
  require 'reak/signature'
  require 'reak/bootstrap/tools'
  require 'reak/bootstrap/parser'
  require 'reak/bootstrap/ast'
  require 'reak/bootstrap/compiler'
  require 'reak/bootstrap/codeloader'
  require 'reak/bootstrap/ext'

  # kick off smalltalk runtime
  CodeLoader.load_paths << File.expand_path('../reak', __FILE__)
  CodeLoader.run('kernel/Alpha')
end
