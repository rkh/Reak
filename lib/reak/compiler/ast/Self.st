Namespace current: Reak.AST [
  Rubinius.AST.Self subclass: Self [
    Primary register: Self.
    Self include: Node.

    Self class >> bootstrapGrammar: g [
      ^ g str: 'self'
    ]

    Self class >> for: line with: aString [
      Self new: line
    ]
  ]
]
