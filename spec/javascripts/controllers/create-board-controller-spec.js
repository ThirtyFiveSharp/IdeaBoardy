describe("CreateBoardController", function () {
    var scope, ctrl;

    beforeEach(module('idea-boardy'));

    beforeEach(inject(function ($rootScope, $controller) {
        scope = $rootScope.$new();
        scope.dialog = {
            context:{}
        };
        ctrl = $controller('CreateBoardController', {$scope:scope});
    }));

    describe("addSection", function () {
        it("should set default color", inject(function (color) {
            var sections = scope.dialog.context.sectionsToCreate = [];
            for(var i=0; i<12; i++)   {
                scope.addSection();
                expect(sections[i].color).toBe(color(i));
            }
        }));
    });
});