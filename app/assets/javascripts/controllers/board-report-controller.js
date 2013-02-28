angular.module('idea-boardy')
    .controller('BoardReportController', ['$scope', '$http', '$location', 'config', 'params', 'dialog', 'autoUpdater',
    function ($scope, $http, $location, config, params, dialog, autoUpdater) {
        var shareDialog = dialog('shareDialog');
        refreshBoards();
        $scope.showShareDialog = function () {
            shareDialog.open({boardToShare:$scope.board, recipients:[{}]});
        };
        $scope.goToBoard = function () {
            $location.path('/board/' + $scope.board.shortenUrlCode);
        };
        $scope.shouldShowTagCloud = false;
        $scope.tagCloud = [{name:"Loading...", weight:"0"}];
        $scope.showTagCloud = function () {
            $scope.shouldShowTagCloud = !$scope.shouldShowTagCloud;
            if($scope.shouldShowTagCloud) {
                TagCanvas.Start('myCanvas','tags',{
                    textColour: '#ff0000',
                    outlineColour: '#ff00ff',
                    reverse: true,
                    depth: 0.8,
                    maxSpeed: 0.05,
                    weight: true,
                    weightFrom: 'weight',
                    textColour: '#00f',
                    textFont: 'Impact,Arial Black,sans-serif'
                });
                TagCanvas.prototype.$scope = $scope;
                $http.get($scope.board.tagCloudLink.href)
                    .success(function(tagCloud){
                        $scope.tagCloud = tagCloud;
                        setTimeout(function(){TagCanvas.Update('myCanvas','tags');}, 200);
                    });
            }
        }

        function refreshBoards() {
            $http.get(config.shortenUrlEntryPoint + "/" + params('shortenUrlCode'), {params:{embed:"sections"}})
                .success(function (board) {
                    board.tagCloudLink = _.find(board.links, function(link){return link.rel == 'tagcloud'});
                    $scope.board = board;
                    $scope.sections = [];
                    _.each($scope.board.sections, function (section, index) {
                        $http.get(section.links.getLink('self').href, {params:{embed:"ideas"}})
                            .success(function (section) {
                                $scope.sections[index] = section;
                            });
                    });
                });
        }

        function refreshSections() {
            _.each($scope.sections, function (section, index) {
                $http.get(section.links.getLink('self').href, {params:{embed:"ideas"}})
                    .success(function (section) {
                        $scope.sections[index] = section;
                    });
            });
        }

        autoUpdater.clear();
        autoUpdater.register($location.cur, refreshSections);
    }
]);