Boolean extend [
  <category: 'Kernel'>

  & aBoolean [
    <category: 'logical operations'>
    self subclassResponsibility
  ]

  | aBoolean [
    <category: 'logical operations'>
    self subclassResponsibility
  ]

  and: aBlock [
    <category: 'controlling'>
    self subclassResponsibility
  ]

  and: firstBlock and: secondBlock [
    <category: 'controlling'>
    ^ (self and: aBlock) and: secondBlock
  ]

  and: firstBlock and: secondBlock and: thirdBlock [
    <category: 'controlling'>
    ^ ((self and: aBlock) and: secondBlock) and: thirdBlock
  ]

  and: firstBlock and: secondBlock and: thirdBlock and: fourthBlock [
    <category: 'controlling'>
    ^ (((self and: aBlock) and: secondBlock) and: thirdBlock) fourthBlock
  ]

  or: aBlock [
    <category: 'controlling'>
    self subclassResponsibility
  ]

  or: firstBlock or: secondBlock [
    <category: 'controlling'>
    ^ (self or: aBlock) or: secondBlock
  ]

  or: firstBlock or: secondBlock or: thirdBlock [
    <category: 'controlling'>
    ^ ((self or: aBlock) or: secondBlock) or: thirdBlock
  ]

  or: firstBlock or: secondBlock or: thirdBlock or: fourthBlock [
    <category: 'controlling'>
    ^ (((self or: aBlock) or: secondBlock) or: thirdBlock) fourthBlock
  ]

  eqv: aBoolean [
    <category: 'logical operations'>
    ^ self == aBoolean
  ]

  ifTrue: firstBlock ifFalse: secondBlock [
    <category: 'controlling'>
    self subclassResponsibility
  ]

  ifFalse: aBlock [
    <category: 'controlling'>
    ^ self ifTrue: [ nil ] ifFalse: aBlock
  ]

  ifFalse: firstBlock ifTrue: secondBlock [
    <category: 'controlling'>
    ^ self ifTrue: secondBlock ifFalse: firstBlock
  ]

  ifTrue: aBlock [
    <category: 'controlling'>
    ^ self ifTrue: aBlock ifFalse: [ nil ]
  ]

  not [
    <category: 'logical operations'>
    self subclassResponsibility
  ]

  xor: aBoolean [
    <category: 'controlling'>
    ^ aBoolean eqv: self not
  ]
]
