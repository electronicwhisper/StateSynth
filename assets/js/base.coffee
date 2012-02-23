ko.extenders.numeric = (target, precision) ->
  # create a writeable computed observable to intercept writes to our observable
  ko.computed({
    read: target,
    write: (newValue) ->
      parsedValue = parseInt(newValue, 0)
      target(if isNaN(parsedValue) then 0 else parsedValue)
  })




ko.bindingHandlers.position = {
  update: (element, valueAccessor, allBindingsAccessor, viewModel) ->
    val = ko.utils.unwrapObservable(valueAccessor())
    $(element).css({left: val[0], top: val[1]})
}
ko.bindingHandlers.size = {
  update: (element, valueAccessor, allBindingsAccessor, viewModel) ->
    val = ko.utils.unwrapObservable(valueAccessor())
    $(element).css({width: val[0], height: val[1]})
}


ko.utils.wrapObservable = (value) ->
  if ko.isObservable(value) then value else ko.observable(value)





model = {}


$ () ->
  ko.applyBindings(model)



window.model = model

window.socket = io.connect('http://localhost')












