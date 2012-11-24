describe('events', function() {
    var expectEvents = {
            editSection:'editSection',
            cancelEditSection:'cancelEditSection',
            sectionDeleted:'sectionDeleted',
            ideaDeleted:'ideaDeleted',
            ideaMerged:'ideaMerged',
            ideaEmigrated:'ideaEmigrated'
        };

    beforeEach(module('idea-boardy'));

    it('should return given event', inject(function(events) {
        expect(events.editSection).toBe(expectEvents.editSection);
        expect(events.cancelEditSection).toBe(expectEvents.cancelEditSection);
        expect(events.sectionDeleted).toBe(expectEvents.sectionDeleted);
        expect(events.ideaDeleted).toBe(expectEvents.ideaDeleted);
        expect(events.ideaMerged).toBe(expectEvents.ideaMerged);
        expect(events.ideaEmigrated).toBe(expectEvents.ideaEmigrated);
    }));

});