require 'rake/clean'

CLEAN.include "**/*.rbc"

task :env do
  require "bundler/setup"
  $LOAD_PATH.unshift 'vendor/kpeg/lib'
end

desc "run specs"
task :spec => :env do
  $LOAD_PATH.unshift 'test', 'lib'
  require 'minitest/unit'
  MiniTest::Unit.autorun
  Dir.glob('test/**/*_test.rb') do |file|
    load file
  end
end

task :test => :spec