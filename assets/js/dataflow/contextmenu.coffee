init = () ->
  
  $.contextMenu({
    selector: ".state"
    items: {
      check: {name: "Check", callback: () ->
        o = ko.dataFor(this[0])
        console.log o
      }
    }
  })
  
  $.contextMenu({
    selector: ".fun"
    items: {
      check: {name: "Check", callback: () ->
        o = ko.dataFor(this[0])
        console.log o
      }
    }
  })


module.exports = {
  init: init
}