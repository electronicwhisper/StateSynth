ko.extenders.numeric = (target, precision) ->
  # create a writeable computed observable to intercept writes to our observable
  ko.computed({
    read: target,
    write: (newValue) ->
      parsedValue = parseInt(newValue, 0)
      target(if isNaN(parsedValue) then 0 else parsedValue)
  })








model = {
  pins: ko.observableArray()
  pinModes: [
    {
      number: 0
      name: "Digital Input"
      range: [0, 1]
      writeable: false
    },
    {
      number: 1
      name: "Digital Output"
      range: [0, 1]
      writeable: "digitalWrite"
    },
    {
      number: 2
      name: "Analog Input"
      range: [0, 1024]
      writeable: false
    },
    {
      number: 3
      name: "PWM Output"
      range: [0, 255]
      writeable: "analogWrite"
    },
    {
      number: 4
      name: "Servo Output"
      range: [0, 1]
      writeable: true
    },
    {
      number: 5
      name: "Serial Communication"
      range: [0, 0]
      writeable: false
    }
  ]
}

pinModeReadable = (num) -> model.pinModes[num]




makePin = (pinNumber) ->
  pin = {
    analogChannel: ko.observable()
    _mode: ko.observable()
    _supportedModes: ko.observable()
    value: ko.observable().extend({ numeric: 0 })
    pinNumber: pinNumber
  }
  
  pin.name = ko.computed () ->
    if pin.analogChannel() == 127 then pinNumber else "A"+pin.analogChannel()
  
  pin.mode = ko.computed({
    read: () -> model.pinModes[pin._mode()] || model.pinModes[5]
    write: (newMode) ->
      if newMode
        pin._mode(newMode.number)
        console.log("pinMode", pinNumber, pin._mode())
        socket.emit("pinMode", pinNumber, pin._mode())
  })
  pin.supportedModes = ko.computed () -> (pin._supportedModes() || []).map (modeNum) -> model.pinModes[modeNum]
  
  # listen for changing value, send to server
  ko.computed () ->
    if pin.mode().writeable
      if pin.value()?
        console.log("send to server", pin.mode(), pin.value())
        socket.emit(pin.mode().writeable, pin.pinNumber, pin.value())
  
  # pin.modeReadable = ko.computed () -> model.pinModes[pin.mode()]?.name
  # pin.modeReadable = ko.computed () -> "asdf"
  
  pin



makePinIfNeeded = (pinNumber) ->
  if pinNumber >= model.pins().length
    model.pins.push(makePin(pinNumber))


socket = io.connect('http://localhost');

socket.on "pins", (pins) ->
  for pin, i in pins
    makePinIfNeeded(i)
    
    p = model.pins()[i]
    p.value(pin.value)
    p._mode(pin.mode)
    p.analogChannel(pin.analogChannel)
    p._supportedModes(pin.supportedModes)

socket.on "values", (values) ->
  for value, i in values
    makePinIfNeeded(i)
    
    p = model.pins()[i]
    if !p.value()? || !p.mode().writeable
      p.value(value)








$ () ->
  ko.applyBindings(model);

window.model = model