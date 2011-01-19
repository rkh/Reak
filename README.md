Smalltalk implementation running on Rubinius.

**WARNING: Not usable, yet.**

Status:

* Parser is nearly complete (ANSI Smalltalk is complete, but no syntax for class/method definition yet)
* Compiler is incomplete
* Standard library and core classes are near to non-existent

Example usage:

    ~/Workspace/reak (git: master) ☃〠 bin/reak
    st> 1 - (2 - 1) > -1
    true
    st> 1 > 2 ifTrue: [ self halt ] ifFalse: [ nil isNil respondTo: #doesNotUnderstand: ]
    true
    st> 1 rubyPerform: #to_s
    a RubyObject("1")

This implementation is not image based nor does it have a built-in IDE. So, if
you are looking for a classic Smalltalk, you might better be looking somewhere
else. Also, it is rather experimental at the moment.

Parts of the compiler have been stolen from, I mean inspired by Brian Ford's
[Poison](https://github.com/brixen/poison).
