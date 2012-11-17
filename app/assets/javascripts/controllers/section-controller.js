angular.module('idea-boardy')
    .controller('SectionController', ['$scope', '$http',
        function ($scope, $http) {
            $http.get($scope.section.links.getLink('section').href)
                .success(function(data) {
                    $scope.section = enhanceSection(data);
                });
            $scope.$on(ScopeEvent.beginRefreshSection, function(event) {
                if(event.stopPropagation) event.stopPropagation();
                $http.get($scope.section.selfLink.href)
                    .success(function(data) {
                        $scope.section = enhanceSection(data);
                        $scope.$broadcast(ScopeEvent.refresh);
                    });
            });
            $scope.$on(ScopeEvent.editSection, function(event, targetSection) {
                if($scope.section == targetSection) {
                    $scope.section.mode = "edit";
                }
                else {
                    $scope.section.editable = false;
                }
            });
            $scope.$on(ScopeEvent.cancelEditSection, function(event, targetSection) {
                if($scope.section == targetSection) {
                    $scope.section.mode = "view";
                }
                else {
                    $scope.section.editable = true;
                }
            });
            function enhanceSection(section) {
                return angular.extend(section, {
                    selfLink:section.links.getLink('self'),
                    mode:"view",
                    editable:true,
                    enable:function () {
                        this.editable = true
                    },
                    disable:function () {
                        this.editable = false
                    },
                    edit:function () {
                        $scope.$emit(ScopeEvent.editSection, this);
                    },
                    delete:function() {
                        $scope.$broadcast(ScopeEvent.deleteSection, this);
                    },
                    addIdea:function() {
                        $scope.$broadcast(ScopeEvent.createNewIdea, this);
                    },
                    cancel:function () {
                        $scope.$emit(ScopeEvent.cancelEditSection, this);
                    }
                });
            }
        }
    ]);