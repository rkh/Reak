#!/usr/bin/env rbx

# This is not the final reak executable.
# It's just here until I manage to write something new in Smalltalk.

file = __FILE__
file = File.readlink(file) while File.symlink? file
$LOAD_PATH.unshift(File.expand_path('../../lib', file))

require 'reak'
require 'pp'

evals    = []
settings = Hash.new { |h,k| h[k] = false }
options  = Rubinius::Options.new "Usage: #$0 [options] [script]", 20
syntax   = :reak

options.on( "-A", "Print the AST"          ) { settings[:ast]  = true }
options.on( "-S", "Print the S-Expression" ) { settings[:sexp] = true }
options.on( "-B", "Print the bytecode"     ) { settings[:bc]   = true }

options.on "-e", "CODE", "Execute CODE" do |e|
  evals << ['(eval)', e]
end

options.on "-v", "--version", "Show version" do
  puts "Reak #{Reak::VERSION}"
  exit 0
end

options.on "-h", "--help", "Display this help" do
  puts options
  exit 0
end

info = proc do |cond, name, &block|
  next unless settings[cond]
  puts '', " #{name} ".center(80, "=")
  block[]
  puts "-" * 80, ''
end

display = proc do |file, code|
  begin
    if settings[:ast] or settings[:sexp]
      ast = Reak::Parser.new(:reak, file).parse_string(code)
      info.call(:sexp, 'S-Expressions') { pp ast.to_sexp } 
      info.call(:ast, 'AST') { Rubinius::AST::AsciiGrapher.new(ast).print }
    end

    info.call(:bc, "Bytecode") { puts Reak::Compiler.compile_string(code, file).decode }
    p Reak.eval_smalltalk(code, file)
  rescue Exception => e
    e.render
  end
end

options.parse(ARGV).each do |file|
  evals << [file, File.read(file)]
end

if evals.empty?
  if $stdin.tty?
    require 'readline'
    loop do
      code = Readline.readline "st> "
      exit 0 unless code and code != "exit"
      display['(repl)', code]
    end
  else
    evals << ['(stdin)', STDIN.read]
  end
end

evals.each(&display)

