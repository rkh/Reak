Behavior extend [
  <category: 'Kernel'>

  allInstances [
    <category: 'accessing'>
    | allInstances |
    allInstances := Set new.
    self allInstancesDo: [ :each | allInstancesDo add: each ].
    ^ allInstances
  ]

  allInstancesDo: aBlock [
    <category: 'accessing'>
    self allSubInstancesDo: [ :each |
      (each isMemberOf: self) ifTrue: [ aBlock value: each ]]
  ]

  allSubclasses [
    <category: 'accessing'>
    | allSubclasses |
    allSubclasses := Set new.
    self allSubclassesDo: [ :each | allSubclasses add: each ]
    ^ allSubclasses
  ]

  allSubclassesDo: aBlock [
    <category: 'accessing'>
    self subclassesDo: [ :each |
      aBlock value: each.
      each allSubInstancesDo: aBlock ]
  ]

  allSubInstances [
    <category: 'accessing'>
    | allSubInstances |
    allSubInstances := Set new.
    self allSubInstancesDo: [ :each | allSubInstancesDo add: each ].
    ^ allSubInstances
  ]

  allSubInstancesDo: aBlock [
    <category: 'accessing'>
    Ruby allSubInstancesOf: self do: aBlock
  ]

  allSuperclasses [
    <category: 'accessing'>
    | allSuperclasses |
    allSuperclasses := Set new.
    self allSuperclassesDo: [ :each | allSuperclasses add: each ]
    ^ allSuperclasses
  ]

  allSuperclassesDo: aBlock [
    <category: 'accessing'>
    aBlock value: self superclass.
    self superclass allSuperclassesDo: aBlock
  ]

  subclasses [
    <category: 'accessing'>
    | subclasses |
    subclasses := Set new.
    self subclassesDo: [ :each | subclasses add: each ]
    ^ subclasses
  ]

  subclassesDo: aBlock [
    Behavior allSubInstancesDo: [ :each |
      each superclass = self ifTrue: [ aBlock value: each ]]
  ]
]
