# makeHierarchical = (o) ->
#   o.hierarchical = {}
#   o.hierarchical.parent = ko.observable()
#   o.hierarchical.children = ko.observableArray()
#   o
# 
# makeParentChild = (parent, child) ->
#   prevParent = child.hierarchical.parent()
#   if prevParent != parent
#     if prevParent
#       removeParentChild(prevParent, child)
#     child.hierarchical.parent(parent)
#     parent.hierarchical.children.push(child)
# 
# removeParentChild = (parent, child) ->
#   child.hierarchical.parent(false)
#   parent.hierarchical.children.remove(child)
# 
# module.exports = {
#   makeHierarchical: makeHierarchical
#   makeParentChild: makeParentChild
#   removeParentChild: removeParentChild
# }