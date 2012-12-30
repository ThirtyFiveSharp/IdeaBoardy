angular.module('idea-boardy')
  .directive('queryable', [()->
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
      match = (keyWord, targetKey) ->
        return unless targetKey? and targets[targetKey]?
        target = targets[targetKey]
        if target.matcher(keyWord) then target.matchHandler() else target.unMatchHandler()
      reset = -> targets[target].reset() for target of targets when target and targets[target]?
      @query = (keyWord) ->
        return reset() unless keyWord
        match keyWord, target for target of targets
    ]
  ])
  .directive('querier', ['events', (events) ->
    require: '^queryable'
    compile: -> (scope, element, attrs, queryableCtrl) ->
      scope.$watch attrs.ngModel, (keyWord) -> queryableCtrl.query(keyWord)
      scope.$on events.querableTargetChanged, -> scope[attrs.ngModel] = ""
  ])
  .directive('queryableTarget', ['$parse', 'events', ($parse, events) ->
    require: '^queryable'
    compile: -> (scope, element, attrs, queryableCtrl) ->
      modelExpr = attrs.queryableTarget
      lookupKeys = attrs.lookupKeys.split(",")
      matcher = (keyWord) ->
        model = $parse(modelExpr)(scope)
        regexp = new RegExp(keyWord, 'gi')
        _.any lookupKeys, (lookupKey) ->
          value = if typeof(model[lookupKey]) is "function" then model[lookupKey]() else model[lookupKey].toString()
          value.match(regexp)
      showElement = -> element.parent().show()
      hideElement = -> element.parent().hide()
      queryableCtrl.addTarget(scope.$id, matcher, showElement, hideElement, showElement)
      scope.$emit(events.querableTargetChanged)
      scope.$on '$destroy', ->
        queryableCtrl.removeTarget(scope.$id)
        scope.$emit(events.querableTargetChanged)
  ])