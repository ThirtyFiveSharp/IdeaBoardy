angular.module('idea-boardy')
    .controller('IdeaController', ['$scope', '$http',
        function ($scope, $http) {
            $http.get($scope.section.links.getLink('section').href).success(function (section) {
                $http.get(section.links.getLink('ideas').href).success(function (ideas) {
                    $scope.ideas = ideas;
                });
            });
        }
    ]);