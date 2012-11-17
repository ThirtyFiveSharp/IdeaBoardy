angular.module('idea-boardy')
    .controller('DeleteSectionController', ['$scope', '$http',
    function ($scope, $http) {
        $scope.section = {};
        $scope.delete = function(section) {
            $scope.isDeleteSectionDialogVisible = false;
            $http.delete(section.selfLink.href)
                .success(function() {
                    $scope.$emit(ScopeEvent.beginRefreshBoardSections)
                });
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
