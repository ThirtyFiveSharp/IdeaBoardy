describe('BoardController', function () {
    var scope, ctrl, $httpBackend, paramsService, locationService,
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

    beforeEach(inject(function (_$httpBackend_, $rootScope, $controller, params, $location) {
        paramsService = params;
        paramsService('boardUri', boardUri);
        locationService = $location;
        $httpBackend = _$httpBackend_;
        $httpBackend.expectGET(boardUri).respond(board);
        $httpBackend.expectGET(sectionsLinkUri).respond(sections);
        scope = $rootScope.$new();
        scope.idea = board;
        ctrl = $controller('BoardController', {$scope:scope});
    }));

    afterEach((function() {
        $httpBackend.verifyNoOutstandingExpectation();
        $httpBackend.verifyNoOutstandingRequest();
    }));

    describe("initialize", function () {
        it("should enhance board", function () {
            $httpBackend.flush();
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
        it("should go to report", function() {
            $httpBackend.flush();
            scope.goToReport(scope.board);
            expect(paramsService('reportUri')).toBe(reportUri);
            expect(locationService.path()).toBe('/boards/' + board.id + '/report');
            expect(locationService.search().reportUri).toBe(reportUri);
        });
    });
});