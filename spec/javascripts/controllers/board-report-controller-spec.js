describe('BoardReportController', function () {
    var scope, ctrl, $httpBackend,
        boardUri = 'http://localhost:3000/boards/1',
        boardReportUri = boardUri + "/report",
        report = {"name":"board report", "description":"board report description", "sections":[
            {"name":"Well", "ideas":[
                {"content":"something well 1", "vote":3},
                {"content":"something well 2", "vote":1}
            ]},
            {"name":"Less Well", "ideas":[
                {"content":"something less well", "vote":2}
            ]}
        ], "links":[
            {"rel":"self", "href":boardReportUri},
            {"rel":"board", "href":boardUri}
        ]};

    beforeEach(module('idea-boardy'));

    beforeEach(inject(function (_$httpBackend_, $rootScope, $controller, params) {
        params('uri', boardReportUri);
        $httpBackend = _$httpBackend_;
        $httpBackend.expectGET(boardReportUri).respond(report);
        scope = $rootScope.$new();
        ctrl = $controller('BoardReportController', {$scope:scope});
        $httpBackend.flush();
    }));

    describe("initialize", function () {
        it("should retrieve report of given board", function () {
            expect(scope.report).toBe(report);
        });
        it("should expose function goToBoard() to scope", function () {
            expect(angular.isFunction(scope.goToBoard)).toBeTruthy();
        });
    });

    describe("goToBoard", function () {
        it("should go to board page", inject(function ($location) {
            $location.path('/reports');
            scope.goToBoard();
            expect($location.path()).toEqual('/board');
            expect($location.search()).toEqual({uri: boardUri});
        }));
    });

});