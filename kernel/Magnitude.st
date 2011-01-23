Magnitude extend [
  <=> aMagnitude [
    " Single method to override in subclasses for comparing magnitudes.
      Return values mean:
            |   >   |   >=  |   <   |   <=  |   =   |
        ----|-------|-------|-------|-------|-------|
         -1 | false | false | true  | true  | false |
          0 | false | true  | false | true  | true  |
          1 | true  | true  | false | false | false |
        nil | error | error | error | error | false |"
    <category: 'comparing'>
    self subclassResponsibility
  ]

  < aMagnitude [
    <category: 'comparing'>
    ^ (self <=> aMagnitude) == -1
  ]

  <= aMagnitude [
    <category: 'comparing'>
    ^ (self <=> aMagnitude) < 1
  ]

  > aMagnitude [
    <category: 'comparing'>
    ^ (self <=> aMagnitude) == 1
  ]

  >= aMagnitude [
    <category: 'comparing'>
    ^ (self <=> aMagnitude) > -1
  ]

  = aMagnitude [
    <category: 'comparing'>
    ^ (self <=> aMagnitude) == 0
  ]

  between: min and: max [
    <category: 'comparing'>
    ^ self >= min and: [ self <= max ]
  ]

  max: aMagnitude [
    <category: 'comparing'>
    ^ self > aMagnitude ifTrue: [ self ] ifFalse: [ aMagnitude ]
  ]

  min: aMagnitude [
    <category: 'comparing'>
    ^ self < aMagnitude ifTrue: [ self ] ifFalse: [ aMagnitude ]
  ]
]