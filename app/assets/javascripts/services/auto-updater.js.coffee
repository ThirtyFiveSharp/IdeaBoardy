angular.module('idea-boardy')
  .factory('autoUpdater', ['$window','$http', ($window, $http) ->
    registedUpdater = {}
    running = true
    unregisterUpdater = (uri) -> delete registedUpdater[uri]
    update = () ->
      canUpdate = running && _.reduce(registedUpdater, ((can, updater) -> can && updater? && updater.couldUpdate()), true)
      _.each(registedUpdater, (updater)-> updater.update()) if canUpdate

    handler = $window.setInterval(update, 15000)

    resume: () ->
      running = true
      undefined

    pause: () ->
      running = false
      undefined

    unregister: (uri) ->
      unregisterUpdater(uri)

    getUpdater: (uri) -> registedUpdater[uri]

    isRunning: () -> running

    clear: () ->
      uris = _.map(registedUpdater, (obj, uri) -> uri)
      _.each(uris, (uri) -> unregisterUpdater(uri))

    register: (uri, updateFunc, couldUpdate) ->
      if !couldUpdate?
        registedUpdater[uri] = {update: updateFunc, couldUpdate: () -> true}
      else
        registedUpdater[uri] = {update: updateFunc, couldUpdate: couldUpdate}

  ])