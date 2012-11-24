describe('BoardController', function () {
    var scope, ctrl, $httpBackend,
        boardUri = 'http://localhost:3000/boards/1',
        sectionsLinkUri = boardUri + "/sections",
        reportUri = boardUri + "/report",
        board = {"id":1, "name":"tiger retro", "description":"tiger retro for iteration 29", "links":[
            {"rel":"self", "href":boardUri},
            {"rel":"sections", "href":sectionsLinkUri},
            {"rel":"report", "href":reportUri}
        ]},
        sections = [];

    beforeEach(module('idea-boardy'));

    beforeEach(inject(function (_$httpBackend_, $rootScope, $controller, params) {
        params('boardUri', boardUri);
        $httpBackend = _$httpBackend_;
        $httpBackend.expectGET(boardUri).respond(board);
        $httpBackend.expectGET(sectionsLinkUri).respond(sections);
        scope = $rootScope.$new();
        scope.idea = board;
        ctrl = $controller('BoardController', {$scope:scope});
        $httpBackend.flush();
    }));

    afterEach((function() {
        $httpBackend.verifyNoOutstandingExpectation();
        $httpBackend.verifyNoOutstandingRequest();
    }));

    describe("initialize", function () {
        it("should enhance board", function () {
            expect(scope.board).toBe(board);
            expect(scope.board.selfLink).toBe(board.links[0]);
            expect(scope.board.sectionsLink).toBe(board.links[1]);
            expect(scope.board.reportLink).toBe(board.links[2]);
            expect(scope.board.mode).toBe('view');
            expect(typeof scope.board.edit).toBe('function');
            expect(typeof scope.board.delete).toBe('function');
            expect(typeof scope.board.cancel).toBe('function');
        });
    });

    describe("goToReport", function () {
        it("should go to report", inject(function(params, $location) {
            scope.goToReport(scope.board);
            expect(params('reportUri')).toBe(reportUri);
            expect($location.path()).toBe('/report');
            expect($location.search().reportUri).toBe(reportUri);
        }));
    });
});