

dragging = ko.observable(false)


module.exports = {
  dragging: dragging
  startDrag: (target, e, cleanup) ->
    pos = target.positionable.position()
    offset = [e.clientX - pos[0], e.clientY - pos[1]]
    dragging({
      target: target
      offset: offset
      cleanup: cleanup
    })
    
  init: () ->
    $(document).mousemove (e) ->
      if dragging()
        newPos = [e.clientX - dragging().offset[0], e.clientY - dragging().offset[1]]
        dragging().target.positionable.position(newPos)
    $(document).mouseup (e) ->
      if dragging()
        if dragging().cleanup then dragging().cleanup()
        dragging(false)
}