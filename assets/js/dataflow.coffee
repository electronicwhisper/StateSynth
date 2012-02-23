uiConfig = {
  paramSpacing: 20
  paramSize: [4, 4]
}



model.funs = ko.observableArray()
model.connections = ko.observableArray()



makeFun = (o, inputParamTypes, outputParamTypes) ->
  makePositionable(o, [Math.round(Math.random()*600), Math.round(Math.random()*600)], [300, 100])
  
  o.fun = {}
  o.fun.inputParams = []
  o.fun.outputParams = []
  
  mp = (isInput) ->
    a = if isInput then o.fun.inputParams else o.fun.outputParams
    (type, i) ->
      p = makeParam({}, type)
      pos = ko.computed () ->
        [i*uiConfig.paramSpacing, if isInput then 0 else o.positionable.size()[1]-uiConfig.paramSize[1]]
      o.positionable.makeChild(p, pos, uiConfig.paramSize)
      a.push(p)
  
  inputParamTypes.forEach mp(true)
  outputParamTypes.forEach mp(false)
  
  model.funs.push(o)
  
  o




makeParam = (o, type) ->
  o.param = {}
  o.param.type = ko.observable(type)
  o.param.value = ko.observable()
  
  o


makeConnection = (o, from, to) ->
  o.connection = {}
  o.connection.from = ko.observable(from)
  o.connection.to = ko.observable(to)
  
  o.connection.pathD = ko.computed () ->
    f = o.connection.from().positionable.center()
    t = o.connection.to().positionable.center()
    "M#{f[0]},#{f[1]} C#{f[0]},#{(f[1]+t[1])/2} #{t[0]},#{(f[1]+t[1])/2} #{t[0]},#{t[1]}"
  
  model.connections.push(o)
  
  o



f1 = makeFun({}, [{}], [{}, {}])
f2 = makeFun({}, [{}], [{}])
f3 = makeFun({}, [{}, {}], [{}])

makeConnection({}, f1.fun.outputParams[0], f2.fun.inputParams[0])
makeConnection({}, f2.fun.outputParams[0], f3.fun.inputParams[0])
makeConnection({}, f1.fun.outputParams[1], f3.fun.inputParams[1])