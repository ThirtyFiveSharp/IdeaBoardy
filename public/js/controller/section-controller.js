angular.module('idea-boardy')
    .controller('SectionController', ['$scope', '$http',
        function ($scope, $http) {
            $http.get($scope.section.links.getLink('ideas').href)
                .success(function (ideas) {
                    $scope.ideas = ideas;
                });
        }
    ]);