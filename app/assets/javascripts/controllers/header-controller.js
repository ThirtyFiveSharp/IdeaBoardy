angular.module('idea-boardy')
    .controller('HeaderController', ['$scope', '$location',
    function ($scope, $location) {
        $scope.goToHomePage = function() {
            $location.path('/');
        };
    }
]);

