describe('IdeaController', function () {
    var scope, ctrl,
        ideaUri = 'http://localhost:3000/api/boards/1/sections/1/ideas/1',
        ideaTagsUri = ideaUri + '/tags',
        idea = {
            "id":1,
            "content":"idea content",
            "vote":3,
            "links":[
                {"rel":"self", "href":ideaUri},
                {"rel":"tags", "href":ideaTagsUri}
            ]
        };

    beforeEach(module('idea-boardy'));

    beforeEach(inject(function ($rootScope, $controller) {
        $rootScope.idea = idea;
        scope = $rootScope.$new();
        ctrl = $controller('IdeaController', {$scope:scope});
    }));

    describe("initialize", function () {
        it("should enhance idea", function () {
            var addVoteFn = scope.idea.addVote;
            expect(addVoteFn).not.toBe(null);
            expect(typeof addVoteFn).toBe('function');
        });
    });

});