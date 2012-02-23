



makeFunUI = (fun) ->
  


makeParamUI = (param) ->
  



makeLine = (o, from, to) ->
  o.line.pathD = ko.computed () ->
    f = ko.utils.unwrapObservable(o.connection.from).positionable.center()
    t = ko.utils.unwrapObservable(o.connection.to).positionable.center()
    "M#{f[0]},#{f[1]} C#{f[0]},#{(f[1]+t[1])/2} #{t[0]},#{(f[1]+t[1])/2} #{t[0]},#{t[1]}"
  o


makeConnectionUI = (o) ->
  makeLine(o, o.connection.from, o.connection.to)