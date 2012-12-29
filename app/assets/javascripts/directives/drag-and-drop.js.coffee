angular.module('idea-boardy')
  .directive('draggable', ->
    require: ['draggable']
    controller: ['$scope', '$attrs', '$parse', ($scope, $attrs, $parse) ->
      draggableTypeExpr = $attrs.type
      draggableModelExpr = $attrs.draggable
      @getType = -> draggableTypeExpr
      @getModel = -> $parse(draggableModelExpr)($scope)
    ]
    compile: ->
      option =
        revert: 'invalid',
        handle: '.handle',
        helper: 'clone',
        appendTo: 'body',
        opacity: 0.8
      (scope, element) -> element.draggable(option)
  )
  .directive('droppable', ['$parse', ($parse) ->
    require: 'droppable'
    controller: () ->
      handlers = {}
      @addHandler = (type, action) -> handlers[type] = action
      @canAccept = (type) ->  handlers[type]?
      @getHandler = (type) -> return handlers[type]
    compile: ->
      (scope, element, attrs, droppableCtrl) ->
        accept = (draggable) ->
          draggableElem = angular.element(draggable)
          draggableCtrl = draggableElem.controller('draggable')
          draggableType = draggableCtrl.getType() if draggableCtrl?
          droppableCtrl.canAccept draggableType
        drop = (event, ui) ->
          draggableElem = angular.element(ui.draggable)
          draggableCtrl = draggableElem.controller('draggable')
          draggableType = draggableCtrl.getType() if draggableCtrl?
          draggableModel = draggableCtrl.getModel() if draggableCtrl?
          handler = droppableCtrl.getHandler(draggableType)
          scope.$apply -> $parse(handler)(scope, {$draggableModel: draggableModel})
        option =
          activeClass: "droppable-active"
          hoverClass: "droppable-hover"
          tolerance: 'pointer'
          greedy: true
          accept: accept
          drop: drop
        element.droppable option
  ])
  .directive('draggableType', () ->
    require: '^droppable'
    compile: ->
      (scope, element, attrs, droppableCtrl) -> droppableCtrl.addHandler(attrs.draggableType, attrs.action)
  )