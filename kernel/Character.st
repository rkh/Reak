Magnitude subclass: Character [
  <category: 'Kernel'>

  | codePoint |

  CharacterMap := Array new: 256.

  Character class >> initialize [
    <category: 'initializing'>
    0 to: 255 do: [ :codePoint |
      CharacterMap
        at: codePoint + 1
        put: (self new codePoint: anInteger; yourself) ]
  ]

  Character class >> codePoint: anInteger [
    <category: 'instance creation'>
    ^ CharacterMap at: anInteger + 1
  ]

  Character class >> cr [
    <category: 'instance creation'>
    ^ Character codePoint: 13
  ]

  Character class >> lf [
    <category: 'instance creation'>
    ^ Character codePoint: 10
  ]

  Character class >> space [
    <category: 'instance creation'>
    ^ Character codePoint: 32
  ]

  Character class >> tab [
    <category: 'instance creation'>
    ^ Character codePoint: 9
  ]

  = anObject [
    <category: 'comparing'>
    (anObject respondTo: #codePoint)
      ifTrue: [ ^ self codePoint = anObject codePoint ]
      ifFalse: [ ^ false ]
  ]

  <=> aCharacter [
    <category 'comparing'>
    ^ self codePoint <=> aCharacter codePoint
  ]

  asLowecase [
    <category: 'converting'>
    self isUppercase
      ifTrue: [ ^ self transposeFrom: $A to: $a ]
      ifFalse: [ ^ self ]
  ]

  asString [
    <category: 'converting'>
    ^ String with: self
  ]

  asUpercase [
    <category: 'converting'>
    self isLowercase
      ifTrue: [ ^ self transposeFrom: $a to: $A ]
      ifFalse: [ ^ self ]
  ]

  between: firstCharacter and: secondCharacter [
    <category: 'comparing'>
    ^ firstCharacter <= self and: [ secondCharacter >= self ]
  ]

  codePoint: anInteger [
    <category: 'accessing'>
    codePoint := anInteger
  ]

  codePoint [
    <category: 'accessing'>
    ^ codePoint
  ]

  isAlphaNumeric [
    <category: 'testing'>
    ^ self isDigit | self isLetter
  ]

  isDigit [
    <category: 'testing'>
    ^ self between: $0 and: $9
  ]

  isLetter [
    <category: 'testing'>
    ^ self between: $A and: $z
  ]

  isLowercase [
    <category: 'testing'>
    ^ self between: $A and: $Z
  ]

  isUppercase [
    <category: 'testing'>
    ^ self between: $a and: $z
  ]

  transposeFrom: firstCharacter to: secondCharacter [
    <category: 'converting'>
    ^ Character codePoint:
      (self codePoint - firstCharacter codePoint) + secondCharacter codePoint
  ]
]
