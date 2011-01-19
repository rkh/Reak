require 'reak/bootstrap'

module Reak
  class Compiler
    class Wrapper
      undef send
      def initialize(g)
        @g = g
      end

      def method_missing(m,*a)
        puts "g.#{m}(#{a.inspect[1..-2]})"
        @g.__send__(m, *a)
      end
    end

    attr_reader :generator
    alias g generator

    def initialize
      @generator = Generator.new #Wrapper.new Generator.new
      super
    end

    def compile(ast)
      ast = Reak::Parser.new.parse(ast) unless ast.kind_of? Syntax::Node

      g.name = :call
      g.file = :"(reak)"
      g.set_line 1

      g.required_args = 0
      g.total_args = 0
      g.splat_index = nil

      g.local_count = 0
      g.local_names = []

      ast.visit self

      g.ret
      g.close

      g.encode
      cm = g.package Rubinius::CompiledMethod
      puts cm.decode if $DEBUG

      code = Reak::Code.new
      ss = Rubinius::StaticScope.new Object
      Rubinius.attach_method g.name, cm, ss, code

      code
    end

    def literal(node)
      g.push_literal node.value
    end

    def call_method(node)
      g.smalltalk_send(node.selector, node.arity)
    end

    def nil_kind(node)
      g.push :nil
    end

    def constant(name)
      g.push_const :"Smalltalk"
      g.find_const name
    end

    def array(node)
      constant :Array
      node.values.each { |v| v.visit self }
      g.make_tuple node.values.size
      g.send :new, 1
    end

    def myself
      g.push_self
    end

    def true_kind(node)
      g.push :true
    end

    def false_kind(node)
      g.push :false
    end

    def return(node)
      node.visit self
      g.ret
    end

    def scaled_decimal(node)
      constant :ScaledDecimal
      g.push_literal node.value
      g.push_literal node.scale
      g.send :new, 2
    end

    def branch(condition, positive, negative)
      done = g.new_label
      else_label = g.new_label

      condition.visit self
      g.gif else_label

      positive.visit self
      g.goto done

      else_label.set!
      negative.visit self

      done.set!
    end
  end
end
