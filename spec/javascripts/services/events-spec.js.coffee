describe 'events', ->
  expectEvents =
    editSection: 'editSection'
    sectionEditingFinished: 'sectionEditingFinished'
    sectionDeleted: 'sectionDeleted'
    ideaDeleted: 'ideaDeleted'
    ideaMerged: 'ideaMerged'
    ideaEmigrated: 'ideaEmigrated'
    tagCreated: 'tagCreated'
    querableTargetChanged: 'querableTargetChanged'

  beforeEach(module('idea-boardy-services'))

  it 'should return given event', inject((events) ->
    expect(events.editSection).toBe(expectEvents.editSection)
    expect(events.sectionEditingFinished).toBe(expectEvents.sectionEditingFinished)
    expect(events.sectionDeleted).toBe(expectEvents.sectionDeleted)
    expect(events.ideaDeleted).toBe(expectEvents.ideaDeleted)
    expect(events.ideaMerged).toBe(expectEvents.ideaMerged)
    expect(events.ideaEmigrated).toBe(expectEvents.ideaEmigrated)
    expect(events.tagCreated).toBe(expectEvents.tagCreated)
    expect(events.querableTargetChanged).toBe(expectEvents.querableTargetChanged)
  )
