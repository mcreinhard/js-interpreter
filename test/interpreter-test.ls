should = chai.should!
var result, consoleArray

describe 'Interpreter', ->
  before ->
    window.showResult = (value) ->
      result := value
    window.printInConsole = (value) ->
      consoleArray.push value
    init!
  beforeEach ->
    result := void
    consoleArray := []

  describe 'Basics', ->
    specify 'should return literals', ->
      run '3'
      result.should.equal 3
      run '"string"'
      result.should.equal 'string'

    specify 'should log literals', ->
      run 'log(3)'
      run 'log("string")'
      consoleArray.should.deep.equal [3 "string"]

    specify 'should support operators', ->
      run '2 + 4'
      result.should.equal 6

  describe 'Variables', ->
    specify 'should support declaration', ->
      run 'var a = "foo"'
      run 'a'
      result.should.equal 'foo'

    specify 'should support assignment', ->
      run 'var a = "foo"'
      run 'a = 3'
      run 'a'
      result.should.equal 3

  describe 'Functions', ->
    specify 'should support user-defined functions', ->
      run 'var f = function(x) {return x;}'
      run 'f(5)'
      result.should.equal 5

    specify 'should access variables in the correct scope', ->
      run 'var a = 1'
      run 'var f = function() {return a;}'
      run 'var g = function() {var a = 2; return a;}'
      run 'f()'
      result.should.equal 1
      run 'g()'
      result.should.equal 2

    specify 'should handle closures correctly', ->
      run 'var f = function() {
        var count = 0;
        return function() {count = count + 1; log(count);};
      }'
      run 'var g = f()'
      run 'g(); g(); g(); g(); g()'
      consoleArray.should.deep.equal [1 2 3 4 5]



