Object subclass: Message [
  <category: 'Kernel'>

  | selector arguments |
  
  initialize [
    <category: 'initialize'>
    arguments := #()
  ]

  selector [
    <category: 'accessing'>
    ^ selector
  ]

  selector: aSymbol [
    <category: 'accessing'>
    selector := aSymbol
  ]

  arguments [
    <category: 'accessing'>
    ^ arguments
  ]

  arguments: anArray [
    <category: 'accessing'>
    arguments := anArray
  ]

  printString [
    <category: 'printing'>
    ^ self selector asString
  ]
]