describe('events', function () {
    var expectEvents = {
        editSection:'editSection',
        sectionEditingFinished:'sectionEditingFinished',
        sectionDeleted:'sectionDeleted',
        ideaDeleted:'ideaDeleted',
        ideaMerged:'ideaMerged',
        ideaEmigrated:'ideaEmigrated',
        tagCreated:'tagCreated'
    };

    beforeEach(module('idea-boardy'));

    it('should return given event', inject(function (events) {
        expect(events.editSection).toBe(expectEvents.editSection);
        expect(events.sectionEditingFinished).toBe(expectEvents.sectionEditingFinished);
        expect(events.sectionDeleted).toBe(expectEvents.sectionDeleted);
        expect(events.ideaDeleted).toBe(expectEvents.ideaDeleted);
        expect(events.ideaMerged).toBe(expectEvents.ideaMerged);
        expect(events.ideaEmigrated).toBe(expectEvents.ideaEmigrated);
        expect(events.tagCreated).toBe(expectEvents.tagCreated);
    }));

});