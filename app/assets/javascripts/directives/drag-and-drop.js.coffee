angular.module('idea-boardy')
  .directive('draggable', ['autoUpdater', (autoUpdater)->
    require: ['draggable']
    controller: ['$scope', '$attrs', '$parse'
      ($scope, $attrs, $parse) ->
        draggableTypeExpr = $attrs.type
        draggableModelExpr = $attrs.draggable
        @getType = -> draggableTypeExpr
        @getModel = -> $parse(draggableModelExpr)($scope)
    ]
    link: (scope, element) ->
      options =
        revert: 'invalid',
        handle: '.handle',
        helper: 'clone',
        appendTo: 'body',
        opacity: 0.8,
        start : () -> autoUpdater.pause()
        stop : () -> autoUpdater.resume()
      element.draggable(options)
  ])
  .directive('droppable', ['$parse', ($parse) ->
    require: 'droppable'
    controller: () ->
      handlers = {}
      @addHandler = (type, action) -> handlers[type] = action
      @canAccept = (type) ->  handlers[type]?
      @getHandler = (type) -> handlers[type]
    link: (scope, element, attrs, droppableCtrl) ->
      options =
        activeClass: 'droppable-active'
        hoverClass: 'droppable-hover'
        tolerance: 'pointer'
        greedy: true
        accept: (draggable) ->
          draggableElem = angular.element(draggable)
          draggableCtrl = draggableElem.controller('draggable')
          draggableType = draggableCtrl.getType() if draggableCtrl?
          droppableCtrl.canAccept draggableType
        drop: (event, ui) ->
          draggableElem = angular.element(ui.draggable)
          draggableCtrl = draggableElem.controller('draggable')
          draggableType = draggableCtrl.getType() if draggableCtrl?
          draggableModel = draggableCtrl.getModel() if draggableCtrl?
          handler = droppableCtrl.getHandler(draggableType)
          scope.$apply -> $parse(handler)(scope, {$draggableModel: draggableModel, $event: event})
      element.droppable options
  ])
  .directive('draggableType', () ->
    require: '^droppable'
    link: (scope, element, attrs, droppableCtrl) -> droppableCtrl.addHandler(attrs.draggableType, attrs.action)
  )