BlockClosure extend [
  argumentCount [
    <category: 'accessing'>
    | arity |
    arity := self rubyPerform: #arity.
    arity < 0
      ifTrue: [ ^ -1 - arity ]
      ifFalse: [ arity ]
  ]

  valueWithArguments: anArray [
    <category: 'evaluating'>
    ^ self rubyPerform: #'call_splat' with: anArray
  ]

  value [
    <category: 'evaluating'>
    ^ self rubyPerform: #'call'
  ]

  value: anObject [
    <category: 'evaluating'>
    ^ self rubyPerform: #'call' with: anObject
  ]

  value: firstObject value: secondObject [
    <category: 'evaluating'>
    ^ self rubyPerform: #'call' with: anObject with: secondObject
  ]

  ensure: aBlock [
    <category: 'error handling'>
    ^ self notYetImplemented
  ]

  ifCurtailed: aBlock [
    <category: 'error handling'>
    ^ self notYetImplemented
  ]

  on: exception do: handlerAction [
    <category: 'error handling'>
    ^ self notYetImplemented
  ]
]