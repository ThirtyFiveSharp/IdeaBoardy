describe 'auto updater', ->

  beforeEach(module('idea-boardy-services'))

  it 'should register an updater', inject (autoUpdater) ->
    updaterName = "uri1"
    autoUpdater.register(updaterName, () -> "abc")
    expect(autoUpdater.getUpdater(updaterName).update()).toBe("abc")

  it 'should unregister an existed updater', inject (autoUpdater) ->
    updaterName = "uri1"
    autoUpdater.register(updaterName, () -> "abc")
    autoUpdater.unregister(updaterName)
    expect(autoUpdater.getUpdater(updaterName)).toBeUndefined()

  it 'should clear all updaters', inject (autoUpdater) ->
    updaterName = "uri1"
    updaterName2 = "uri2"
    autoUpdater.register(updaterName, () -> "abc")
    autoUpdater.register(updaterName2, () -> "abc")
    autoUpdater.clear()
    expect(autoUpdater.getUpdater(updaterName)).toBeUndefined()
    expect(autoUpdater.getUpdater(updaterName2)).toBeUndefined()

  it 'should pause and resume updaters', inject (autoUpdater) ->
    expect(autoUpdater.isRunning()).toBeTruthy()
    autoUpdater.pause()
    expect(autoUpdater.isRunning()).toBeFalsy()
    autoUpdater.resume()
    expect(autoUpdater.isRunning()).toBeTruthy()
