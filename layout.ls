@printInConsole = (string) !->
  $ \.console .append <| $ '<p></p>' .text string

@showResult = (value) ->
  $ \.result .text <| value or \undefined

$ ->
  init!
  $ \.run .on \click, ->
    run <| $ \.code .val!

