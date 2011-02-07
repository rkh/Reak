require File.expand_path('../../test_helper', __FILE__)
require 'reak/bootstrap/tools'
MiniTest::Unit.autorun if $0 == __FILE__

class SmalltalkExposeTest < MiniTest::Unit::TestCase
  def setup
    @class = Class.new
    @class.metaclass.send(:public, :define_method)
    @class.define_method(:foo) { 10 }
    Reak.smalltalk_expose @class, :foo
    @instance = @class.new
  end

  def test_smalltalk_expose
    assert_equal 10, @instance.foo
    assert_equal 10, @instance.send(Reak.smalltalk_prefix(:foo))
  end

  def test_smalltalk_expose_overriding
    @class.define_method(Reak.smalltalk_prefix(:foo)) { 20 }
    assert_equal 20, @instance.foo
  end

  def test_smalltalk_expose_subclass
    subclass = Class.new @class
    assert_equal 10, subclass.new.foo
    assert_equal 10, subclass.new.send(Reak.smalltalk_prefix(:foo))
  end

  def test_smalltalk_expose_subclass_overriding
    subclass = Class.new @class
    subclass.define_method(Reak.smalltalk_prefix(:foo)) { 20 }
    assert_equal 10, @instance.foo
    assert_equal 20, subclass.new.foo
  end

  def test_smalltalk_expose_arguments
    @class.define_method(:bar_blah) { |x, y| x + y }
    Reak.smalltalk_expose @class, :bar_blah, 'bar:blah:'
    subclass = Class.new @class
    assert_equal 3, subclass.new.bar_blah(2, 1)
    subclass.define_method(Reak.smalltalk_prefix('bar:blah:')) { |x, y| x - y }
    assert_equal 1, subclass.new.bar_blah(2, 1)
  end

  def test_smalltalk_expose_implicit
    @class.extend Reak::Tools
    @class.define_method(:bar) { 42 }
    @class.smalltalk_expose :bar
    assert_equal 42, @instance.send(Reak.smalltalk_prefix(:bar))
  end
end
