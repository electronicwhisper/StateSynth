
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
      removeParentChild(prevParent, child)
    child.positionable.parent(parent)
    parent.positionable.children.push(child)

removeParentChild = (parent, child) ->
  child.positionable.parent(false)
  parent.positionable.children.remove(child)

ko.bindingHandlers.positionable = {
  init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
    ko.computed () ->
      pos = viewModel.positionable.position()
      $(element).css({left: pos[0], top: pos[1]})
    ko.computed () ->
      size = viewModel.positionable.size()
      $(element).css({width: size[0], height: size[1]})
}

module.exports = {
  makePositionable: makePositionable
  makeParentChild: makeParentChild
  removeParentChild: removeParentChild
}