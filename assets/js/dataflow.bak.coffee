# makeUniqueId = (() ->
#     id = 0
#     return () ->
#       id += 1
#       id
#   )()



uiConfig = {
  paramSpacing: 20
  paramSize: [4, 4]
}



model.funs = ko.observableArray()
model.connections = ko.observableArray()


makeFun = (inputParamTypes, outputParamTypes) ->
  fun = {
    inputParams: []
    outputParams: []
    ui: {
      position: ko.observable([Math.round(Math.random()*600), Math.round(Math.random()*600)])
      size: ko.observable([300, 100])
    }
    # TODO needs html body, subscription/thing to remove to stop it
    remove: () ->
      # TODO
  }
  
  mp = (isInput) ->
    a = if isInput then fun.inputParams else fun.outputParams
    (type, i) ->
      p = makeParam(type)
      p.isInput(isInput)
      p.ui.position = ko.computed () ->
        [i*uiConfig.paramSpacing, if isInput then 0 else fun.ui.size()[1]-uiConfig.paramSize[1]]
      p.ui.absolutePosition = ko.computed () ->
        [fun.ui.position()[0] + p.ui.position()[0], fun.ui.position()[1] + p.ui.position()[1]]
      a.push(p)
      
  
  inputParamTypes.forEach mp(true)
  
  outputParamTypes.forEach mp(false)
  
  
  model.funs.push fun
  fun




makeParam = (type) ->
  param = {
    type: ko.observable(type)
    isInput: ko.observable()
    value: ko.observable()
    ui: {
      startDrag: (target, e) ->
        placeholder = makeParamPlaceholder([e.clientX, e.clientY])
        placeholder.isInput(!param.isInput())
        placeholder.position = ko.observable([e.clientX, e.clientY])
        if param.isInput() then makeConnection(placeholder, param) else makeConnection(param, placeholder)
    }
    remove: () ->
      # TODO
  }
  param



makeParamPlaceholder = (initialPosition) ->
  paramPlaceholder = {
    ui: {
      position: ko.observable(initialPosition)
    }
  }
  paramPlaceholder.ui.absolutePosition = ko.computed () -> paramPlaceholder.ui.position()
  paramPlaceholder
makeConnectionPlaceholder = (inputParam, outputParam) ->
  connectionPlaceholder = {ui: {}}
  connectionPlaceholder.ui.pathD = ko.computed () ->
    input = connection.inputParam().ui.absolutePosition().map (x, i) -> x+uiConfig.paramSize[i]/2
    output = connection.outputParam().ui.absolutePosition().map (x, i) -> x+uiConfig.paramSize[i]/2
    "M#{input[0]},#{input[1]} C#{input[0]},#{(input[1]+output[1])/2} #{output[0]},#{(input[1]+output[1])/2} #{output[0]},#{output[1]}"

makeConnection = (inputParam, outputParam) ->
  subscription = inputParam.value.subscribe (newValue) ->
    outputParam.value(newValue)
  connection = {
    inputParam: ko.observable(inputParam)
    outputParam: ko.observable(outputParam)
    remove: () ->
      subscription.dispose()
      connections.remove connection
    ui: {}
  }
  connection.ui.pathD = ko.computed () ->
    input = connection.inputParam().ui.absolutePosition().map (x, i) -> x+uiConfig.paramSize[i]/2
    output = connection.outputParam().ui.absolutePosition().map (x, i) -> x+uiConfig.paramSize[i]/2
    "M#{input[0]},#{input[1]} C#{input[0]},#{(input[1]+output[1])/2} #{output[0]},#{(input[1]+output[1])/2} #{output[0]},#{output[1]}"
  
  model.connections.push connection
  connection



window.makeFun = makeFun
window.makeConnection = makeConnection

# p1 = makeParam({}, true)
# p2 = makeParam({}, false)
# c = makeConnection(p1, p2)

f1 = makeFun([{}], [{}, {}])
f2 = makeFun([{}], [{}])
f3 = makeFun([{}, {}], [{}])

makeConnection(f1.outputParams[0], f2.inputParams[0])
makeConnection(f2.outputParams[0], f3.inputParams[0])
makeConnection(f1.outputParams[1], f3.inputParams[1])