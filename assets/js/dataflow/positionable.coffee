uiConfig = {
  paramSpacing: 20
  paramSize: [6, 6]
}


makePositionable = require("../positionable").makePositionable

makeFunPositionable = (o) ->
  makePositionable(o, [Math.round(Math.random()*600), Math.round(Math.random()*600)], [300, 100])
  
  # make params children of the fun
  ko.computed () ->
    o.fun.params().forEach (p) -> require("positionable").makeParentChild(o, p)
  
  # position the params
  ko.computed () ->
    positionParam = (isInput) ->
      (param, i) ->
        param.positionable.position([i*uiConfig.paramSpacing, if isInput then 0 else o.positionable.size()[1] - uiConfig.paramSize[1]])
    o.fun.inputParams().forEach positionParam(true)
    o.fun.outputParams().forEach positionParam(false)

makeParamPositionable = (o) ->
  makePositionable(o, [0,0], uiConfig.paramSize)

module.exports = {
  makeFunPositionable: makeFunPositionable
  makeParamPositionable: makeParamPositionable
}