angular.module('idea-boardy')
  .directive('queryableScope', [()->
    controller: ['$parse', '$attrs', '$element', ($parse, $attrs, $element)->
      targets = {}
      @addTarget = (identity, matcher, matchHandler, unMatchHandler, reset) ->
        target =
          matcher: matcher
          matchHandler: matchHandler
          unMatchHandler: unMatchHandler
          reset: reset
        targets[identity] = target
      @removeTarget = (identity) ->
        targets[identity] = null
      match = (keyword, targetKey) ->
        return unless targetKey? and targets[targetKey]?
        target = targets[targetKey]
        if target.matcher(keyword) then target.matchHandler() else target.unMatchHandler()
      reset = -> targets[targetKey].reset() for targetKey of targets when targetKey and targets[targetKey]?
      @query = (keyword) ->
        return reset() unless keyword
        match keyword, target for target of targets
    ]
  ])
  .directive('querier', ['events', (events) ->
    require: '^queryableScope'
    compile: -> (scope, element, attrs, queryableScopeCtrl) ->
      scope.$watch attrs.ngModel, (keyword) -> queryableScopeCtrl.query(keyword)
      scope.$on events.querableTargetChanged, -> scope[attrs.ngModel] = ""
  ])
  .directive('queryable', ['$parse', 'events', ($parse, events) ->
    require: '^queryableScope'
    compile: -> (scope, element, attrs, queryableScopeCtrl) ->
      modelExpr = attrs.queryable
      lookupKeys = attrs.lookupKeys.split(",")
      matcher = (keyword) ->
        model = $parse(modelExpr)(scope)
        regexp = new RegExp(keyword, 'gi')
        _.any lookupKeys, (lookupKey) ->
          value = if typeof(model[lookupKey]) is "function" then model[lookupKey]() else model[lookupKey].toString()
          value.match(regexp)
      showElement = -> element.parent().show()
      hideElement = -> element.parent().hide()
      queryableScopeCtrl.addTarget(scope.$id, matcher, showElement, hideElement, showElement)
      scope.$emit(events.querableTargetChanged)
      scope.$on '$destroy', ->
        queryableScopeCtrl.removeTarget(scope.$id)
        scope.$emit(events.querableTargetChanged)
  ])