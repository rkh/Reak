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

  hash [
    <category: 'comparing'>
    ^ self rubyPerform: #hash
  ]

  identityHash [
    <category: 'comparing'>
    ^ self rubyPerform: #'object_id'
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

  perform: aSymbol [
    <category: 'message handling'>
    ^ self rubyPerform: #'send_reak' with: aSymbol
  ]

  perform: aSymbol with: anObject [
    <category: 'message handling'>
    ^ self rubyPerform: #'send_reak' with: aSymbol with: anObject
  ]

  perform: aSymbol with: firstObject with: secondObject [
    <category: 'message handling'>
    ^ self rubyPerform: #'send_reak' with: aSymbol with: firstObject with: secondObject
  ]

  perform: aSymbol with: firstObject with: secondObject with: thirdObject [
    <category: 'message handling'>
    ^ self rubyPerform: #'send_reak' with: aSymbol with: firstObject with: secondObject with: thirdObject
  ]

  perform: aSymbol withArguments: anArray [
    <category: 'message handling'>
    ^ self rubyPerform: #'send_reak' withArguments: { aSymbol }, anArray asArray
  ]

  printOn: aStream [
    <category: 'printing'>
    self shouldBeImplemented
  ]

  printString [
    <category: 'printing'>
    (#($A $E $I $O $U) includes: self class name first)
      ifTrue: [ ^ 'an ', self class name ]
      ifFalse: [ ^ 'a ', self class name ]
  ]

  respondsTo: aSymbol [
    <category: 'class membership'>
    ^ self rubyPerform: #'respond_to_reak?' with: aSymbol
  ]

  yourself [
    <category: 'accessing'>
    ^ self
  ]
]
