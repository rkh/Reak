# Reak

## Compilation

The compiler is partly written in Ruby and partly in Smalltalk. Everything
that is needed to compile the Smalltalk parts of the compiler is written in
Ruby. Thus, all that can be written in Smalltalk without having a
bootstrapping Smalltalk, is written in Smalltalk.

* Load bootstrap compiler (written in Ruby)
* Compile and load kernel/alpha
* Compile and load compiler (extends bootstrap compiler, written in Smalltalk)
* Compile and load compiler again (optional, to get optimizations)
* Compile and load kernel
