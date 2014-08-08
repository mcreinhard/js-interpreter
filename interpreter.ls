{map, listsToObj} = require 'prelude-ls'

globalScope = __parent__: null

@init = ->
  globalScope.log =
    __type__: \NativeFunction
    __value__: printInConsole

apply = (f, args) -->
  switch f?.__type__
  | \NativeFunction => f.__value__ ...args
  | \DefinedFunction =>
    newScope = f.__scope__ with
      (lists-to-obj f.__params__, args) <<< __parent__: f.__scope__
    evaluate newScope, f.__body__
  | _ =>
    printInConsole "TypeError: #{typeof f} is not a function"
    return void

evaluate = (scope, expr) -->
  switch expr.type
  | "Literal" => expr.value
  | "Identifier" => scope[expr.name]
  | "CallExpression" =>
    (apply evaluate(scope, expr.callee)) . map (evaluate scope) <| expr.arguments
  | "BinaryExpression" =>
    switch expr.operator
    | "+" => evaluate(scope, expr.left) + evaluate(scope, expr.right)
    | _ => void
  | "FunctionExpression" =>
    __type__: "DefinedFunction"
    __params__: expr.params.map (.name)
    __body__: expr.body
    __scope__: scope
  | "BlockStatement" =>
    for statement in expr.body
      switch statement.type
      | "ReturnStatement" => return evaluate scope, statement.argument
      | _ => evaluate scope, statement
  | "VariableDeclaration" =>
    for declaration in expr.declarations
      scope[declaration.id.name] = if declaration.init?
        evaluate scope, declaration.init
      else
        void
    return void
  | "AssignmentExpression" =>
    switch expr.operator
    | "=" => setVariable(scope, expr.left.name, evaluate(scope, expr.right))
  | "ExpressionStatement" =>
    evaluate(scope, expr.expression)

setVariable = (scope, name, value) ->
  if scope.hasOwnProperty(name) or not scope.__parent__?
    scope[name] = value
  else
    setVariable(scope.__parent__, name, value)

@run = (code) ->
  console.log parsedCode = esprima.parse code
  for statement in parsedCode.body
    showResult evaluate globalScope, statement
