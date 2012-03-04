
makePositionable = (o, position=[0,0], size=[0,0]) ->
  o.positionable = {}
  
  o.positionable.parent = ko.observable()
  o.positionable.position = ko.utils.wrapObservable(position)
  o.positionable.size = ko.utils.wrapObservable(size)
  o.positionable.children = ko.observableArray()
  
  o.positionable.absolutePosition = ko.computed () ->
    acc = [0, 0]
    i = o
    while i
      acc = [acc[0] + i.positionable.position()[0], acc[1] + i.positionable.position()[1]]
      i = i.positionable.parent()
    acc
  o.positionable.center = ko.computed () ->
    p = o.positionable.absolutePosition()
    [p[0] + o.positionable.size()[0]/2, p[1] + o.positionable.size()[1]/2]
  
  o

makeParentChild = (parent, child) ->
  prevParent = child.positionable.parent()
  if prevParent != parent
    if prevParent
      # console.log "had to do this", prevParent, parent
      removeParentChild(child)
    
    # preserve absolute position
    pos = child.positionable.absolutePosition()
    parentPos = parent.positionable.absolutePosition()
    
    child.positionable.parent(parent)
    parent.positionable.children.push(child)
    
    child.positionable.position([pos[0] - parentPos[0], pos[1] - parentPos[1]])

removeParentChild = (child) ->
  parent = child.positionable.parent()
  if parent
    # preserve absolute position
    pos = child.positionable.absolutePosition()
    
    child.positionable.parent(false)
    parent.positionable.children.remove(child)
    
    child.positionable.position(pos)

ko.bindingHandlers.positionable = {
  init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
    ko.computed () ->
      pos = viewModel.positionable.position()
      $(element).css({left: pos[0], top: pos[1]})
    ko.computed () ->
      size = viewModel.positionable.size()
      $(element).css({width: size[0], height: size[1]})
}

ko.bindingHandlers.ellipse = {
  init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
    ko.computed () ->
      size = viewModel.positionable.size()
      $(element).css({"border-radius": "#{size[0] / 2}px / #{size[1] / 2}px"})
}

# ko.bindingHandlers.ellipse = {
#   init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
#     ko.computed () ->
#       pos = viewModel.positionable.position()
#       size = viewModel.positionable.size()
#       attr = {};
#       attr.rx = size[0]/2;
#       attr.ry = size[1]/2;
#       attr.cx = pos[0] + attr.rx;
#       attr.cy = pos[1] + attr.ry;
#       $(element).attr(attr)
# }

module.exports = {
  makePositionable: makePositionable
  makeParentChild: makeParentChild
  removeParentChild: removeParentChild
}