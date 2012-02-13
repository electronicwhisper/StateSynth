express = require('express')

firmata = require('firmata')

app = express.createServer()
app.use(express.static(__dirname + '/public'))
app.use require('connect-assets')()
app.set('view options', {layout: false})



app.get '/', (req, res) ->
  res.render('index.jade')


app.listen(3000)



io = require('socket.io').listen(app)
io.set('log level', 1)

board = null

getSerialPorts = (callback) ->
  require('child_process').exec('ls /dev | grep usb', (err, stdout, stderr) ->
    ports = stdout.slice(0, -1).split("\n")
    ports = ports.map (s) -> "/dev/"+s
    callback(ports)
  )

getSerialPorts (ports) ->
  port = ports[0]
  console.log port
  board = new firmata.Board port, () ->
    updatePins()
    updateValues()


updatePins = () ->
  io.sockets.emit("pins", board.pins)


updateValuesTime = 100
updateValues = () ->
  io.sockets.emit("values", board.pins.map (pin) -> pin.value)
  setTimeout(updateValues, updateValuesTime)


io.sockets.on 'connection', (socket) ->
  socket.emit("pins", board.pins)
  
  socket.on 'pinMode', (args...) ->
    console.log("pinMode!", args)
    board.pinMode(args...)
  socket.on 'digitalWrite', (args...) ->
    console.log("digitalWrite!", args)
    board.digitalWrite(args...)
  socket.on 'analogWrite', (args...) -> board.analogWrite(args...)

