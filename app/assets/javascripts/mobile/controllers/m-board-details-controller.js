angular.module('m-idea-boardy')
    .controller('MBoardDetailsController', ['$scope', '$http', 'config', 'params',
    function ($scope, $http, config, params) {
        $scope.initialize = function () {
            var boardUri = config.shortenUrlEntryPoint + "/" + params('shortenUrlCode');
            $http.get(boardUri, {params:{embed:"sections"}})
                .success(function (board) {
                    $scope.board = board;
                    $scope.sections = [];
                    _.each($scope.board.sections, function (section, index) {
                        $http.get(section.links.getLink('self').href, {params:{embed:"ideas"}})
                            .success(function (section) {
                                $scope.sections[index] = section;
                            });
                    });
                });
        };
        $scope.vote = function(idea, section) {
            $http.post(idea.links.getLink('vote').href).success(function() {
                $http.get(section.links.getLink('self').href, {params:{embed:"ideas"}})
                    .success(function (section1) {
                        section.ideas = section1.ideas;
                    });
            });
        };
    }
]);