False extend [
  <category: 'Kernel'>

  & aBoolean [
    <category: 'logical operations'>
    ^ false
  ]

  | aBoolean [
    <category: 'logical operations'>
    ^ aBoolean
  ]

  and: aBlock [
    <category: 'controlling'>
    ^ false
  ]

  or: aBlock [
    <category: 'controlling'>
    ^ aBlock value
  ]

  ifTrue: firstBlock ifFalse: secondBlock [
    <category: 'controlling'>
    ^ secondBlock value
  ]

  not [
    <category: 'logical operations'>
    ^ true
  ]

  printString [
    <category: 'printing'>
    ^ 'false'
  ]
]
