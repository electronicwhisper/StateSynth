init = () ->
  
  clickPos = [0, 0]
  $("body").on("contextmenu", (e) ->
    clickPos = [e.clientX, e.clientY]
  )
  
  
  $.contextMenu({
    selector: ".state"
    zIndex: 1000
    items: {
      activate: {name: "Activate", callback: () ->
        o = ko.dataFor(this[0])
        o.state.active(true)
      }
      deactivate: {name: "Deactivate", callback: () ->
        o = ko.dataFor(this[0])
        o.state.active(false)
      }
      make: {name: "Make", items: {
        state: {name: "State", callback: () ->
          o = ko.dataFor(this[0])
          s = require("../dataflow").makeState({})
          s.positionable.position(clickPos)
          o.state.states.push(s)
        }
      }}
      debug: {name: "Debug", callback: () ->
        o = ko.dataFor(this[0])
        window.debug = o
        console.log o
      }
    }
  })
  
  $.contextMenu({
    selector: ".fun"
    zIndex: 1000
    items: {
      debug: {name: "Debug", callback: () ->
        o = ko.dataFor(this[0])
        window.debug = o
        console.log o
      }
    }
  })
  
  $.contextMenu({
    selector: ".connection"
    zIndex: 1000
    items: {
      debug: {name: "Debug", callback: () ->
        o = ko.dataFor(this[0])
        window.debug = o
        console.log o
      }
    }
  })


module.exports = {
  init: init
}