Class extend [
  <category: 'Kernel'>

  new [
    <category: 'instance creation'>
    ^ self rubyPerform: #new; initialize; yourself
  ]
]