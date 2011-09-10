Rubinius.AST.Self subclass: 'Self' in: Reak.AST [
  Reak.AST.Primary unshift: Reak.AST.Self.
  Reak.AST.Self include: Reak.AST.Node.

  (Reak.AST.Self class) >> grammar: g [
    ^ g str: 'self'
  ].

  (Reak.AST.Self class) >> for: line with: aString [
    ^ Rubinius.AST.Self new: line
  ].
]
