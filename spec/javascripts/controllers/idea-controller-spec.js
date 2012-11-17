describe('IdeaController', function () {

    beforeEach(module('idea-boardy'));

    describe("initialize", function () {
        var scope, ctrl, $httpBackend,
            ideaUri = 'http://localhost:3000/boards/1/sections/1/ideas/1',
            ideaRef = {"id":1, "content":"idea content", "vote":3, "links":[
                {"rel":"idea", "href":ideaUri}
            ]};

        beforeEach(inject(function (_$httpBackend_, $rootScope, $controller) {
            $httpBackend = _$httpBackend_;
            $httpBackend.expectGET(ideaUri).respond(ideaRef);
            scope = $rootScope.$new();
            scope.idea = ideaRef;
            ctrl = $controller('IdeaController', {$scope:scope});
        }));

        it("should enhance idea", function () {
            $httpBackend.flush();
            var addVoteFn = scope.idea.addVote;
            expect(addVoteFn).not.toBe(null);
            expect(typeof addVoteFn).toBe('function');
        });
    });

});