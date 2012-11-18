describe('BoardReportController', function () {

    beforeEach(module('idea-boardy'));

    describe("initialize", function () {
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

        beforeEach(inject(function (_$httpBackend_, $rootScope, $controller, params) {
            $httpBackend = _$httpBackend_;
            $httpBackend.expectGET(boardReportUri).respond(report);
            params('reportUri', boardReportUri);
            scope = $rootScope.$new();
            ctrl = $controller('BoardReportController', {$scope:scope});
        }));

        it("should retrieve report of given board", function () {
            $httpBackend.flush();
            expect(scope.report).toBe(report);
        });
    });

});