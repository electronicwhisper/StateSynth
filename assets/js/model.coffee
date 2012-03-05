ko.extenders.numeric = (target, precision) ->
  # create a writeable computed observable to intercept writes to our observable
  ko.computed({
    read: target,
    write: (newValue) ->
      parsedValue = parseInt(newValue, 0)
      target(if isNaN(parsedValue) then 0 else parsedValue)
  })


# TODO: submit patch to get this back into knockout https://github.com/SteveSanderson/knockout/blob/master/src/utils.js
ko.utils.toggleDomNodeCssClass = (node, className, shouldHaveClass) ->
  classNames = (if node.className.baseVal? then node.className.baseVal || "" else node.className || "").split(/\s+/)
  
  hasClass = ko.utils.arrayIndexOf(classNames, className) >= 0
  
  if shouldHaveClass && !hasClass
    classNames.push(className)
  else if hasClass && !shouldHaveClass
    classNames = classNames.filter (c) -> c != className
  
  if shouldHaveClass != hasClass
    if node.className.baseVal
      node.className.baseVal = classNames.join(" ")
    else
      node.className = classNames.join(" ")




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


model = {
  tempLine: ko.observable()
  tempFun: ko.observable()
}

module.exports = model