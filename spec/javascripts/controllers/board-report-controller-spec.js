describe('BoardReportController', function () {
    var scope, ctrl, $httpBackend,
        shortenUrlCode = "shortenUrlCode",
        boardUri = 'http://localhost:3000/api/boards/1',
        sectionsLinkUri = boardUri + "/sections",
        tagsLinkUri = boardUri + "/tags",
        invitationUri = "http://localhost:3000/emails/invitation",
        section1Uri = "http://localhost:3000/api/sections/1",
        section2Uri = "http://localhost:3000/api/sections/2",
        board = {
            "id":1,
            "name":"tiger retro",
            "description":"tiger retro for iteration 29",
            "shortenUrlCode": "shortenUrlCode",
            "sections":[
                {"id":1, "name":"Well", "color":"ddffdd", "links":[
                    {"rel":"self", "href":"http://localhost:3000/api/sections/1"},
                    {"rel":"ideas", "href":"http://localhost:3000/api/sections/1/ideas"},
                    {"rel":"immigration", "href":"http://localhost:3000/api/sections/1/immigration"}
                ]},
                {"id":2, "name":"Less Well", "color":"ddffdd", "links":[
                    {"rel":"self", "href":"http://localhost:3000/api/sections/2"},
                    {"rel":"ideas", "href":"http://localhost:3000/api/sections/2/ideas"},
                    {"rel":"immigration", "href":"http://localhost:3000/api/sections/2/immigration"}
                ]}
            ],
            "links":[
                {"rel":"self", "href":boardUri},
                {"rel":"sections", "href":sectionsLinkUri},
                {"rel":"tags", "href":tagsLinkUri},
                {"rel":"invitation", "href":invitationUri}
            ]
        },
        sections = [
            {"id":1, "name":"Well", "color":"ddffdd", "links":[
                {"rel":"self", "href":section1Uri},
                {"rel":"ideas", "href":section1Uri + "/ideas"},
                {"rel":"immigration", "href":section1Uri + "/immigration"}
            ], "ideas":[
                {"id":1, "content":"velocity is more stable", "vote":0, "tags":[], "links":[
                    {"rel":"self", "href":"http://localhost:3000/api/ideas/1"},
                    {"rel":"vote", "href":"http://localhost:3000/api/ideas/1/vote"},
                    {"rel":"merging", "href":"http://localhost:3000/api/ideas/1/merging"},
                    {"rel":"tags", "href":"http://localhost:3000/api/ideas/1/tags"}
                ]}
            ]},
            {"id":2, "name":"Less Well", "color":"ddffdd", "links":[
                {"rel":"self", "href":section2Uri},
                {"rel":"ideas", "href":section2Uri + "/ideas"},
                {"rel":"immigration", "href":section2Uri + "/immigration"}
            ], "ideas":[]}
        ];

    beforeEach(module('idea-boardy'));

    beforeEach(inject(function (_$httpBackend_, $rootScope, $controller, config, params) {
        params('shortenUrlCode', shortenUrlCode);
        $httpBackend = _$httpBackend_;
        $httpBackend.expectGET(config.shortenUrlEntryPoint + '/' + shortenUrlCode + "?embed=sections").respond(board);
        $httpBackend.expectGET(section1Uri + "?embed=ideas").respond(sections[0]);
        $httpBackend.expectGET(section2Uri + "?embed=ideas").respond(sections[1]);
        scope = $rootScope.$new();
        ctrl = $controller('BoardReportController', {$scope:scope});
        $httpBackend.flush();
    }));

    afterEach((function () {
        $httpBackend.verifyNoOutstandingExpectation();
        $httpBackend.verifyNoOutstandingRequest();
    }));

    describe("initialize", function () {
        it("should retrieve report of given board", function () {
            expect(scope.board).toBe(board);
            expect(scope.sections[0]).toBe(sections[0]);
            expect(scope.sections[1]).toBe(sections[1]);
        });
        it("should expose function goToBoard() to scope", function () {
            expect(angular.isFunction(scope.goToBoard)).toBeTruthy();
        });
    });

    describe("goToBoard", function () {
        it("should go to board page", inject(function ($location) {
            $location.path('/reports');
            scope.goToBoard();
            expect($location.path()).toEqual('/board/' + scope.board.shortenUrlCode);
        }));
    });

    describe("tagCloud", function () {
        it("should initialize an empty tag cloud model", inject(function ($location) {
            expect(scope.shouldShowTagCloud).toEqual(false);
            expect(scope.tagCloud).toEqual([{name:"Loading...", weight:"0"}]);
        }));
    });
});