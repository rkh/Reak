Namespace current: Reak.AST [
  Rubinius.AST.Self subclass: Self [
    Primary push: Self.
    Self include: Node.

    Self class >> grammar: g [
      ^ g str: 'self'
    ]

    Self class >> for: line with: aString [
      Self new: line
    ]
  ]
]
