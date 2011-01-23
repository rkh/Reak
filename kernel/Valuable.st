Valuable extend [
  argumentCount [
    <category: 'accessing'>
    self subclassResponsibility
  ]

  valueWithArguments: anArray [
    <category: 'evaluating'>
    self subclassResponsibility
  ]

  value [
    <category: 'evaluating'>
    self subclassResponsibility
  ]

  whileFalse [
    <category: 'evaluating'>
    self value ifFalse: [ self whileFalse ]
  ]

  whileTrue [
    <category: 'evaluating'>
    self value ifTrue: [ self whileTrue ]
  ]

  whileFalse: aBlock [
    <category: 'evaluating'>
    self value ifFalse: [ self whileFalse: (aBlock value; yourself) ]
  ]

  whileTrue: aBlock [
    <category: 'evaluating'>
    self value ifTrue: [ self whileTrue: (aBlock value; yourself) ]
  ]
]