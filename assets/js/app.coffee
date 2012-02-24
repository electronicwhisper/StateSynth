module.exports = {
  socket: io.connect('http://localhost')
  init: () ->
    
    model = require("model")
    window.debugModel = model
    
    require("draggable").init()
    
    
    # dummy data
    do ->
      makeFun = require("dataflow").makeFun
      makeConnection = require("dataflow").makeConnection
      
      model.funs = ko.observableArray()
      model.connections = ko.observableArray()
      
      f1 = makeFun({}, [{}], [{}, {}])
      f2 = makeFun({}, [{}], [{}])
      f3 = makeFun({}, [{}, {}], [{}])
      
      c1 = makeConnection({}, f1.fun.outputParams[0], f2.fun.inputParams[0])
      c2 = makeConnection({}, f2.fun.outputParams[0], f3.fun.inputParams[0])
      c3 = makeConnection({}, f1.fun.outputParams[1], f3.fun.inputParams[1])
      
      model.funs.push(f1)
      model.funs.push(f2)
      model.funs.push(f3)
      
      model.connections.push(c1)
      model.connections.push(c2)
      model.connections.push(c3)
    
    ko.applyBindings(model)
}