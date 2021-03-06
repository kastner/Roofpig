#= require three.min
#= require ../../app/assets/javascripts/roofpig/Layer.js.coffee

describe "Layer", ->
  it "#shift", ->
    expect(Layer.F.shift('L', 1)).to.equal('U')
    expect(Layer.F.shift('L', 2)).to.equal('R')
    expect(Layer.F.shift('L', 3)).to.equal('D')

    expect(Layer.F.shift('F', 1)).to.equal('F')
    expect(Layer.F.shift('Q', 1)).to.be.null
    expect(-> Layer.F.shift('F', 0)).to.throw(Error)

