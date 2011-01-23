Object extend [
  <category: 'Kernel'>

  = anObject [
    <category: 'comparing'>
    ^ self rubyPerform: #== with: anObject
  ]

  == anObject [
    <category: 'comparing'>
    ^ self rubyPerform: #'equal?' with: anObject
  ]

  ~= anObject [
    <category: 'comparing'>
    ^ (self = anObject) not
  ]

  ~~ anObject [
    <category: 'comparing'>
    ^ (self == anObject) not
  ]

  class [
    <category: 'class membership'>
    ^ self rubyPerform: #class
  ]

  copy [
    <category: 'copying'>
    ^ self rubyPerform: #dup
  ]

  doesNotUnderstand: aMessage [
    <category: 'error handling'>
    self error: self printString, ' does not understand message ', aMessage selector
  ]

  error: aString [
    <category: 'error handling'>
    self rubyPerform: #raise with: (aString rubyPerform: #'to_s')
  ]

  halt [
    <category:'error handling'>
    self error: 'halt'
  ]

  hash [
    <category: 'comparing'>
    ^ self rubyPerform: #hash
  ]

  identityHash [
    <category: 'comparing'>
    ^ self rubyPerform: #'object_id'
  ]

  initialize [
    <category: 'initialize'>
  ]

  isKindOf: aClass [
    <category: 'class membership'>
    ^ self rubyPerform: #'kind_of?' with: aClass
  ]

  isMemberOf: aClass [
    <category: 'class membership'>
    ^ self class = aClass
  ]

  isNil [
    <category: 'testing'>
    ^ false
  ]

  notNil [
    <category: 'testing'>
    ^ true
  ]

  notYetImplemented [
    <category: 'error handling'>
    self error: 'not yet implemented'
  ]

  perform: aSelector [
    <category: 'message handling'>
    (aSelector respondsTo: #selector)
      ifTrue: [ ^ self perform: aSelector selector withArguments: aSelector arguments ]
      ifFalse: [ ^ self rubyPerform: #'send_smalltalk' with: aSymbol ]
  ]

  perform: aSymbol with: anObject [
    <category: 'message handling'>
    ^ self rubyPerform: #'send_smalltalk' with: aSymbol with: anObject
  ]

  perform: aSymbol with: firstObject with: secondObject [
    <category: 'message handling'>
    ^ self rubyPerform: #'send_smalltalk' with: aSymbol with: firstObject with: secondObject
  ]

  perform: aSymbol with: firstObject with: secondObject with: thirdObject [
    <category: 'message handling'>
    ^ self rubyPerform: #'send_smalltalk' with: aSymbol with: firstObject with: secondObject with: thirdObject
  ]

  perform: aSymbol withArguments: anArray [
    <category: 'message handling'>
    ^ self rubyPerform: #'send_smalltalk' withArguments: { aSymbol }, anArray asArray
  ]

  printOn: aStream [
    <category: 'printing'>
    self printString do: [ :each | aStream nextPut: each ]
  ]

  printString [
    <category: 'printing'>
    (#($A $E $I $O $U) includes: self class name first)
      ifTrue: [ ^ 'an ', self class name ]
      ifFalse: [ ^ 'a ', self class name ]
  ]

  respondsTo: aSymbol [
    <category: 'class membership'>
    ^ self rubyPerform: #'respond_to_smalltalk?' with: aSymbol
  ]

  subclassResponsibility [
    <category: 'error handling'>
    self error: 'subclass responsibility'
  ]

  yourself [
    <category: 'accessing'>
    ^ self
  ]
]
