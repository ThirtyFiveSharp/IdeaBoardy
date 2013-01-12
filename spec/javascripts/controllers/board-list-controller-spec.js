describe('BoardListController', function() {
    var scope,
        boardsUri = "/api/boards",
        boards = [
            {name: 'board 1', shortenUrlCode: 'shortenUrlCode'},
            {name: 'board 2', id: 2, links: [{rel: 'board', href: 'boardUri'}]}
        ];

    beforeEach(module('idea-boardy'));
    beforeEach(inject(function($rootScope, $controller, $httpBackend) {
        scope = $rootScope.$new();
        $httpBackend.expectGET(boardsUri).respond(boards);
        $controller('BoardListController', {$scope: scope});
        $httpBackend.flush();
    }));
    afterEach(inject(function($httpBackend) {
        $httpBackend.verifyNoOutstandingExpectation();
        $httpBackend.verifyNoOutstandingRequest();
    }));

    describe('when initialized', function() {
        it('should expose loaded board list to scope', function() {
            expect(scope.boards.length).toBe(2);
            expect(scope.boards[0]).toEqual(boards[0]);
            expect(scope.boards[1]).toEqual(boards[1]);
        });
        it('should expose function goToBoard to scope', function() {
            expect(angular.isFunction(scope.goToBoard)).toBeTruthy();
        });
        it('should expose function showCreateBoardDialog to scope', function() {
            expect(angular.isFunction(scope.showCreateBoardDialog)).toBeTruthy();
        });
    });

    describe('goToBoard(board)', function(){
        it('should go to the given board page', inject(function($location) {
            var boardToGo = scope.boards[1];
            scope.goToBoard(boardToGo);
            expect($location.path()).toEqual('/board/' + boardToGo.shortenUrlCode);
        }));
    });
});