angular.module('idea-boardy')
    .controller('DeleteSectionController', ['$scope', '$http', '$route',
    function ($scope, $http, $route) {
        $scope.section = {};
        $scope.delete = function(section) {
            $scope.isDeleteSectionDialogVisible = false;
            $http.delete(section.selfLink.href).success($route.reload);
        };
        $scope.close = function() {
            $scope.isDeleteSectionDialogVisible = false;
        };
        $scope.$on(ScopeEvent.deleteSection, function(event, section) {
            $scope.section = section;
            $scope.isDeleteSectionDialogVisible = true;
        });
    }
]);
