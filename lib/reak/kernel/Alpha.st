" Some initial methods we need. "
Reak on: Object     as: 'rubyPerform:'                expose: 'send'.
Reak on: Object     as: 'rubyPerform:with:'           expose: 'send'.
Reak on: Object     as: 'rubyPerform:with:with:'      expose: 'send'.
Reak on: Object     as: 'rubyPerform:with:with:with:' expose: 'send'.
Reak on: Module     as: 'defineMethod:'               expose: 'define_smalltalk_method'.
Reak on: Module     as: 'extend:'                     expose: 'extend_object'.
Reak on: Module     as: 'include:'                    expose: 'include'.
Reak on: Class      as: 'new'                         expose: 'new'.
Reak on: Class      as: 'new:'                        expose: 'new'.
Reak on: Class      as: 'subclass:'                   expose: 'subclass'.
Reak on: Class      as: 'subclass:in:'                expose: 'subclass'.
Reak on: Reak.Tools as: 'as:expose:'                  expose: 'ruby_expose'.

" These will be replaced with better implementations later. "
Reak on: Module as: 'class' expose: 'singleton_class'.

" Setting up code loading "
Reak on: (Reak.CodeLoader class) as: 'run:' expose: 'run'.
(Reak class) >> run: aFile [ ^ Reak.CodeLoader run: aFile ].

Reak run: 'compiler/KPeg'.
Reak run: 'compiler/ast/Self'.
