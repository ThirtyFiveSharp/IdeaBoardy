angular.module('idea-boardy')
    .controller('CreateSectionController', [ '$scope', '$http',
        function ($scope, $http) {
            $scope.section = {};
            $scope.resetCreateSectionForm = function() {
                $scope.section = {};
            };
            $scope.create = function () {
                if(!$scope.createSectionForm.$valid) return;
                $scope.isCreateSectionFormVisible = false;
                $http.post($scope.board.sectionsLink.href, $scope.section)
                    .success(function() {
                        $scope.$emit(ScopeEvent.beginRefreshBoardSections);
                    });
            };
            $scope.cancel = function() {
                $scope.isCreateSectionFormVisible = false;
            };
            $scope.$on(ScopeEvent.createNewSection, function() {
                $scope.isCreateSectionFormVisible = true;
            });
        }
    ]);