$:.push File.expand_path("../lib", __FILE__)
require "reak/version"

Gem::Specification.new do |s|
  s.name        = "reak"
  s.version     = Reak::VERSION
  s.platform    = Gem::Platform.new ['universal', 'rubinius', '2.0']
  s.author      = "Konstantin Haase"
  s.email       = "k.haase@finn.de"
  s.homepage    = "http://rkh.github.com/reak"
  s.summary     = "Smalltalk on Rubinius"
  s.description = "ANSI Smalltalk implementation for Rubinius"

  s.add_dependency "kpeg"
  s.add_development_dependency "minitest", "~> 2.5"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
