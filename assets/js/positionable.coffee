
_makePositionable = (o, initialParent, position=[0,0], size=[0,0]) ->
  parent = ko.observable(initialParent)
  
  o.positionable = {}
  
  o.positionable.parent = ko.computed () -> parent() # read only
  o.positionable.position = ko.utils.wrapObservable(position)
  o.positionable.size = ko.utils.wrapObservable(size)
  o.positionable.children = ko.observableArray() # TODO: should be read only
  o.positionable.makeChild = (oChild, position, size) ->
    _makePositionable(oChild, o, position, size)
    o.positionable.children.push(oChild)
  o.positionable.removeChild = (oChild) ->
    # TODO
  o.positionable.ownChild = (oChild) ->
    # TODO
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

makePositionable = (o, position, size) ->
  _makePositionable(o, false, position, size)


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
}