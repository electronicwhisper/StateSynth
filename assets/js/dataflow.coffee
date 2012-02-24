uiConfig = {
  paramSpacing: 20
  paramSize: [6, 6]
}


makePositionable = require("positionable").makePositionable

draggable = require("draggable")


makeFun = (o, inputParamTypes, outputParamTypes) ->
  makePositionable(o, [Math.round(Math.random()*600), Math.round(Math.random()*600)], [300, 100])
  
  o.fun = {}
  o.fun.inputParams = []
  o.fun.outputParams = []
  
  mp = (isInput) ->
    a = if isInput then o.fun.inputParams else o.fun.outputParams
    (type, i) ->
      p = makeParam({}, type)
      p.param.isInput(isInput)
      pos = ko.computed () ->
        [i*uiConfig.paramSpacing, if isInput then 0 else o.positionable.size()[1]-uiConfig.paramSize[1]]
      o.positionable.makeChild(p, pos, uiConfig.paramSize)
      a.push(p)
  
  inputParamTypes.forEach mp(true)
  outputParamTypes.forEach mp(false)
  
  
  o.fun.startDrag = (target, e) ->
    draggable.startDrag(target, e)
  
  o




makeParam = (o, type) ->
  o.param = {}
  o.param.isInput = ko.observable()
  o.param.type = ko.observable(type)
  o.param.value = ko.observable()
  
  o.param.startDrag = (target, e) ->
    placeholder = makePositionable({}, [e.clientX, e.clientY])
    placeholder.origin = o
    from = if o.param.isInput() then placeholder else o
    to = if o.param.isInput() then o else placeholder
    placeholderConnection = makeConnection({}, from, to)
    
    require("model").connections.push(placeholderConnection)
    
    draggable.startDrag placeholder, e, () ->
      require("model").connections.remove(placeholderConnection)
  
  o.param.stopDrag = (target, e) ->
    originParam = draggable.dragging()?.target.origin
    if originParam && originParam.param.isInput() != o.param.isInput()
      from = if originParam.param.isInput() then o else originParam
      to = if originParam.param.isInput() then originParam else o
      c = makeConnection({}, from, to)
      require("model").connections.push(c)
  
  o


makeConnection = (o, from, to) ->
  o.connection = {}
  o.connection.from = ko.observable(from)
  o.connection.to = ko.observable(to)
  
  o.connection.pathD = ko.computed () ->
    f = o.connection.from().positionable.center()
    t = o.connection.to().positionable.center()
    
    y1 = f[1] + Math.abs(f[1]-t[1])/2
    y2 = t[1] - Math.abs(f[1]-t[1])/2
    
    "M#{f[0]},#{f[1]} C#{f[0]},#{y1} #{t[0]},#{y2} #{t[0]},#{t[1]}"
  
  o



module.exports = {
  makeFun: makeFun
  makeConnection: makeConnection
}