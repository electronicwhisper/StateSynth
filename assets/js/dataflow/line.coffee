makeLine = (o, from, to) ->
  o.line = {}
  o.line.from = ko.utils.wrapObservable(from)
  o.line.to = ko.utils.wrapObservable(to)
  
  o.line.d = ko.computed () ->
    f = o.line.from().positionable.center()
    t = o.line.to().positionable.center()
    
    y1 = f[1] + Math.abs(f[1]-t[1])/2
    y2 = t[1] - Math.abs(f[1]-t[1])/2
    
    "M#{f[0]},#{f[1]} C#{f[0]},#{y1} #{t[0]},#{y2} #{t[0]},#{t[1]}"
  
  o


module.exports = {
  makeLine: makeLine
}