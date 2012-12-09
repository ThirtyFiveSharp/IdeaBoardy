describe('IdeaController', function () {

    beforeEach(module('idea-boardy'));

    describe("initialize", function () {
        var scope, ctrl, $httpBackend,
            ideaUri = 'http://localhost:3000/api/boards/1/sections/1/ideas/1',
            ideaTagsUri = ideaUri + '/tags',
            ideaRef = {
                "links":[
                    {"rel":"idea", "href":ideaUri}
                ]
            },
            idea = {
                "id":1,
                "content":"idea content",
                "vote":3,
                "links":[
                    {"rel":"self", "href":ideaUri},
                    {"rel":"tags", "href":ideaTagsUri}
                ]
            };

        beforeEach(inject(function (_$httpBackend_, $rootScope, $controller) {
            $httpBackend = _$httpBackend_;
            $httpBackend.expectGET(ideaUri).respond(idea);
            $httpBackend.expectGET(ideaTagsUri).respond([]);
            scope = $rootScope.$new();
            scope.idea = ideaRef;
            ctrl = $controller('IdeaController', {$scope:scope});
            $httpBackend.flush();
        }));

        it("should enhance idea", function () {
            var addVoteFn = scope.idea.addVote;
            expect(addVoteFn).not.toBe(null);
            expect(typeof addVoteFn).toBe('function');
        });
    });

});