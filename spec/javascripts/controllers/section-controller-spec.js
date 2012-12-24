describe('SectionController', function () {
    var scope, ctrl,
        sectionUri = "http://localhost:3000/api/boards/1/sections/1",
        ideasUri = sectionUri + "/ideas",
        section = {"id":1, "name":"section1", "color":"ddffdd", "links":[
            {"rel":"self", "href":sectionUri},
            {"rel":"ideas", "href":ideasUri},
            {"rel":"immigration", "href":sectionUri + "/immigration"}
        ]};

    beforeEach(module('idea-boardy'));

    beforeEach(inject(function ($httpBackend, $rootScope, $controller) {
        $httpBackend.expectGET(sectionUri + '?embed=ideas').respond(section);
        scope = $rootScope.$new();
        scope.section = {
            "links":[
                {"rel":"section", "href":sectionUri}
            ]
        };
        ctrl = $controller('SectionController', {$scope:scope});
        $httpBackend.flush();
    }));

    afterEach(inject(function ($httpBackend) {
        $httpBackend.verifyNoOutstandingExpectation();
        $httpBackend.verifyNoOutstandingRequest();
    }));

    describe("initialize", function () {
        it("should enhance section", function () {
            expect(scope.section).toBe(section);
            expect(scope.section.selfLink).toBe(section.links[0]);
            expect(scope.section.mode).toBe("view");
            expect(scope.section.editable).toBeTruthy();
            expect(scope.section.expanded).toBeTruthy();
            expect(typeof scope.section.enable).toBe('function');
            expect(typeof scope.section.disable).toBe('function');
            expect(typeof scope.section.edit).toBe('function');
            expect(typeof scope.section.save).toBe('function');
            expect(typeof scope.section.delete).toBe('function');
            expect(typeof scope.section.createIdea).toBe('function');
            expect(typeof scope.section.addImmigrant).toBe('function');
            expect(typeof scope.section.cancel).toBe('function');
            expect(typeof scope.section.toggleExpand).toBe('function');
        });
    });

    describe("section.toggleExpand", function () {
        it("should set section.expanded to false if expanded is true", function () {
            scope.section.expanded = true;
            scope.section.toggleExpand();
            expect(scope.section.expanded).toBeFalsy();
        });

        it("should set section.expanded to true if expanded is false", function () {
            scope.section.expanded = false;
            scope.section.toggleExpand();
            expect(scope.section.expanded).toBeTruthy();
        });
    });

    describe("section.enable", function () {
        it("should set section.editable to true", function () {
            scope.section.editable = false;
            scope.section.enable();
            expect(scope.section.editable).toBeTruthy();
        });
    });

    describe("section.disable", function () {
        it("should set section.editable to false", function () {
            scope.section.editable = true;
            scope.section.disable();
            expect(scope.section.editable).toBeFalsy();
        });
    });
});