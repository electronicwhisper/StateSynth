module.exports = {
  socket: io.connect('http://localhost')
  init: () ->
    
    model = require("model")
    window.debugModel = model
    
    require("draggable").init()
    
    model.arduino = require("arduino").arduino
    
    
    # dummy data
    do ->
      makeFun = require("dataflow").makeFun
      makeParam = require("dataflow").makeParam
      makeConnection = require("dataflow").makeConnection
      
      
      model.funs = ko.observableArray()
      model.connections = ko.observableArray()
      
      
      do ->
        p = makeParam({})
        f = makeFun({}, [], [p])
        ko.computed () ->
          pin = model.arduino.pins()[14]
          if pin
            p.param.value(pin.value())
        model.funs.push(f)
      
      do ->
        p = makeParam({})
        f = makeFun({}, [p], [])
        ko.computed () ->
          pin = model.arduino.pins()[3]
          if pin
            pin.value(p.param.value())
        model.funs.push(f)
      
      
      # f1 = makeFun({}, [makeParam({})], [makeParam({}), makeParam({})])
      # f2 = makeFun({}, [makeParam({})], [makeParam({})])
      # f3 = makeFun({}, [makeParam({}), makeParam({})], [makeParam({})])
      # 
      # c1 = makeConnection({}, f1.fun.outputParams()[0], f2.fun.inputParams()[0])
      # c2 = makeConnection({}, f2.fun.outputParams()[0], f3.fun.inputParams()[0])
      # c3 = makeConnection({}, f1.fun.outputParams()[1], f3.fun.inputParams()[1])
      # 
      # f1.fun.outputParams()[0].param.value("hello")
      # 
      # model.funs.push(f1)
      # model.funs.push(f2)
      # model.funs.push(f3)
      # 
      # model.connections.push(c1)
      # model.connections.push(c2)
      # model.connections.push(c3)
    
    ko.applyBindings(model)
}