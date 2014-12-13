#-----------------------------------------------------------------------------#
# layout.ls
#
# I/O in the browser
#-----------------------------------------------------------------------------#

{map, filter, Str: {take}, obj-to-pairs} = require 'prelude-ls'

# For console logging
@printInConsole = (string) !->
  $ \.console .append <| $ '<p></p>' .text string

# For displaying the result of evaluated code
@showResult = (value) ->
  $ \.result .text <| value or \undefined

renderScope = (scope) ->
  scope
  |> obj-to-pairs
  |> filter ([a, b]) -> (take 2 a) isnt '__'
  |> map ([a, b]) -> "#{a}: #{b}"
  |> (.join ', ')
  |> $ '<div class="scope"></div>' .text

$ ->
  init!
  $ \.run .on \click, ->
    $ \.code .val! |> run
    globalScope |> renderScope |> $ \body .append
