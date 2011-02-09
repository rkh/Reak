require 'rake/clean'

CLEAN.include "**/*.rbc"

task :bundle do
  require "bundler/setup"
end

desc "run specs"
task :spec => :bundle do
  $LOAD_PATH.unshift 'test', 'lib'
  require 'minitest/unit'
  MiniTest::Unit.autorun
  Dir.glob('test/**/*_test.rb') do |file|    
    load file
  end
end

task :test => :spec