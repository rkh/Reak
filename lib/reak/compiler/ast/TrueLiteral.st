Rubinius.AST.TrueLiteral subclass: 'TrueLiteral' in: Reak.AST [
  Reak.AST.Primary unshift: self.
  self include: Reak.AST.Node.

  (self class) >> grammar: g [
    ^ g str: 'true'
  ].

  (self class) >> for: line with: aString [
    ^ self new: line
  ].
]
