angular.module('idea-boardy')
    .controller('BoardController', ['$scope', '$http', '$location', 'params',
        function ($scope, $http, $location, params) {
            $http.get(params('boardUri')).success(function (board) {
                enhanceBoard(board);
                $scope.board = board;
                $http.get(board.sectionsLink.href).success(function (sections) {
                    $scope.sections = sections;
                });
            });
            $scope.addSection = function() {
                $scope.$broadcast(ScopeEvent.createNewSection);
            };
            $scope.goToReport = function(board) {
                var reportLinkUri = board.reportLink.href;
                params('reportUri', reportLinkUri);
                $location.path('/boards/' + board.id + '/report').search('reportUri', reportLinkUri);
            };
            $scope.$on(ScopeEvent.editSection, function(event, targetSection) {
                if(event.stopPropagation) event.stopPropagation();
                if(event.targetScope == $scope) return;
                $scope.$broadcast(ScopeEvent.editSection, targetSection);
            });

            $scope.$on(ScopeEvent.cancelEditSection, function(event, targetSection) {
                if(event.stopPropagation) event.stopPropagation();
                if(event.targetScope == $scope) return;
                $scope.$broadcast(ScopeEvent.cancelEditSection, targetSection);
            });
            $scope.$on(ScopeEvent.beginRefreshBoardSections, function(event) {
                if(event.stopPropagation) event.stopPropagation();
                $http.get($scope.board.sectionsLink.href).success(function (sections) {
                    $scope.sections = sections;
                });
            });

            function enhanceBoard(board) {
                angular.extend(board, {
                    selfLink:board.links.getLink('self'),
                    sectionsLink:board.links.getLink('sections'),
                    reportLink:board.links.getLink('report'),
                    mode:"view",
                    edit:function () {
                        this.mode = 'edit'
                    },
                    delete:function() {
                        $scope.$broadcast(ScopeEvent.deleteBoard, this);
                    },
                    cancel:function () {
                        this.mode = 'view'
                    }
                });
            }
        }
    ]);

