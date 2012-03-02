uiConfig = {
  paramSpacing: 20
  paramSize: [6, 6]
}


makePositionable = require("positionable").makePositionable

draggable = require("draggable")


makeFun = (o, inputParams=[], outputParams=[]) ->
  o.fun = {}
  o.fun.inputParams = ko.observableArray(inputParams)
  o.fun.outputParams = ko.observableArray(outputParams)
  
  o.fun.inputParams().forEach (p) -> p.param.isInput(true)
  o.fun.outputParams().forEach (p) -> p.param.isInput(false)
  
  o.fun.params = ko.computed () ->
    o.fun.inputParams().concat(o.fun.outputParams())
  
  require("dataflow/positionable").makeFunPositionable(o)
  
  
  
  o.fun.startDrag = (target, e) ->
    draggable.startDrag(target, e)
  
  o




makeParam = (o, type) ->
  o.param = {}
  o.param.isInput = ko.observable()
  o.param.type = ko.observable(type)
  o.param.value = ko.observable()
  
  require("dataflow/positionable").makeParamPositionable(o)
  
  o.param.startDrag = (target, e) ->
    placeholder = makePositionable({}, [e.clientX, e.clientY])
    placeholder.origin = o
    from = if o.param.isInput() then placeholder else o
    to = if o.param.isInput() then o else placeholder
    placeholderLine = require("dataflow/line").makeLine({}, from, to)
    require("model").tempLine(placeholderLine)
    
    draggable.startDrag placeholder, e, () ->
      require("model").tempLine(false)
      # TODO: cleanup placeholder, placeholderLine
  
  o.param.stopDrag = (target, e) ->
    originParam = draggable.dragging()?.target.origin
    if originParam && originParam.param.isInput() != o.param.isInput()
      from = if originParam.param.isInput() then o else originParam
      to = if originParam.param.isInput() then originParam else o
      c = makeConnection({}, from, to)
      require("model").connections.push(c)
      # TODO: if there's already a connection, don't make a new one
  
  o


makeConnection = (o, from, to) ->
  o.connection = {}
  o.connection.from = ko.observable(from)
  o.connection.to = ko.observable(to)
  
  require("dataflow/line").makeLine(o, o.connection.from, o.connection.to)
  
  ko.computed () ->
    to.param.value(from.param.value())
  
  o



makeState = (o) ->
  o.state = {}
  o.state.states = ko.observableArray()
  o.state.funs = ko.observableArray()
  
  require("dataflow/positionable").makeStatePositionable(o)
  
  o.state.startDrag = (target, e) ->
    draggable.startDrag(target, e)
  
  o


module.exports = {
  makeState: makeState
  makeFun: makeFun
  makeParam: makeParam
  makeConnection: makeConnection
}