angular.module('idea-boardy-services')
  .factory('autoUpdater', ['$window','$http', ($window, $http) ->
    registedUpdater = {}
    running = true
    unregisterUpdater = (uri) -> delete registedUpdater[uri]
    intervalMilliSec = 15000
    update = () ->
      _.each(registedUpdater, (updater) -> updater.update() if updater.couldUpdate()) if running
      $window.setTimeout(update, intervalMilliSec)

    handler = $window.setTimeout(update, intervalMilliSec)

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
      if not couldUpdate?
        registedUpdater[uri] = {update: updateFunc, couldUpdate: () -> true}
      else
        registedUpdater[uri] = {update: updateFunc, couldUpdate: couldUpdate}

  ])