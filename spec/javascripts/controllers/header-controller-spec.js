describe('HeaderController', function() {
    var scope;

    beforeEach(module('idea-boardy'));
    beforeEach(inject(function($rootScope, $controller, $httpBackend) {
        scope = $rootScope.$new();
        $controller('HeaderController', {$scope: scope});
    }));

    describe('when initialized', function() {
        it('should expose function goToHomePage to scope', function() {
            expect(angular.isFunction(scope.goToHomePage)).toBeTruthy();
        });
   });

    describe('goToHomePage()', function(){
        it('should go to home page', inject(function($location) {
            scope.goToHomePage();
            expect($location.path()).toEqual('/');
        }));
    });
});