True extend [
  & aBoolean [
    <category: 'logical operations'>
    ^ aBoolean
  ]

  | aBoolean [
    <category: 'logical operations'>
    ^ true
  ]

  and: aBlock [
    <category: 'controlling'>
    ^ aBlock value
  ]

  or: aBlock [
    <category: 'controlling'>
    ^ true
  ]

  ifTrue: firstBlock ifFalse: secondBlock [
    <category: 'controlling'>
    ^ firstBlock value
  ]

  not [
    <category: 'logical operations'>
    ^ false
  ]

  printString [
    <category: 'printing'>
    ^ 'true'
  ]
]
