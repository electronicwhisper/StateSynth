init = () ->
  
  $.contextMenu({
    selector: ".state"
    items: {
      activate: {name: "Activate", callback: () ->
        o = ko.dataFor(this[0])
        o.state.active(true)
      }
      deactivate: {name: "Deactivate", callback: () ->
        o = ko.dataFor(this[0])
        o.state.active(false)
      }
      debug: {name: "Debug", callback: () ->
        o = ko.dataFor(this[0])
        window.debug = o
        console.log o
      }
    }
  })
  
  $.contextMenu({
    selector: ".fun"
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