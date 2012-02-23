
model.ui = {
  dragging: ko.observable()
  startDrag: (target, e) ->
    pos = target.positionable.position()
    offset = [e.clientX - pos[0], e.clientY - pos[1]]
    model.ui.dragging({
      target: target,
      offset: offset
    })
}


$(document).mousemove (e) ->
  if (model.ui.dragging())
    newPos = [e.clientX - model.ui.dragging().offset[0], e.clientY - model.ui.dragging().offset[1]]
    model.ui.dragging().target.positionable.position(newPos)
$(document).mouseup (e) ->
  model.ui.dragging(false)