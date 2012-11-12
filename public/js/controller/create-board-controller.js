angular.module('idea-boardy')
    .controller('CreateBoardController', ['$scope', '$route', '$http', '$timeout',
        function ($scope, $route, $http, $timeout) {
            $scope.board = {};
            $scope.sections = [];
            $scope.create = function () {
                if (!$scope.createBoardForm.$valid) return;
                $scope.isCreateBoardDialogVisible = false;
                var board = $scope.board, sections = $scope.sections;
                $http.post('/boards', board).success(function (createdBoard, status, headers) {
                    var createdBoardUri = headers('location');
                    $http.get(createdBoardUri).success(function (createdBoard) {
                        var sectionsLink = createdBoard.links.getLink('sections');
                        _.each(sections, function (section) {
                            $http.post(sectionsLink.href, section);
                        });
                        $route.reload();
                    });
                });
            };
            $scope.cancel = function() {
                $scope.isCreateBoardDialogVisible = false;
            };
            $scope.resetCreateBoardForm = function() {
                $scope.board = {};
                $scope.sections = [];
            };
            $scope.addSection = function () {
                $scope.sections.push({});
            };
            $scope.removeSection = function (index) {
                $scope.sections[index].name = "(to be removed)";
                $timeout(function () {
                    $scope.sections.splice(index, 1);
                });
            };
            $scope.$on(ScopeEvent.createNewBoard, function() {
                $scope.isCreateBoardDialogVisible = true;
            });
        }
    ]);
