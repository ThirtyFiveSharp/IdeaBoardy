angular.module('idea-boardy')
    .controller('SectionController', ['$scope', '$http',
        function ($scope, $http) {
            enhanceSection($scope.section);

            function enhanceSection(section) {
                angular.extend(section, {
                    selfLink:section.links.getLink('section'),
                    mode:"view",
                    editable:true,
                    enable:function () {
                        this.editable = true
                    },
                    disable:function () {
                        this.editable = false
                    },
                    edit:function () {
                        _.each($scope.sections, function (section) {
                            section.disable();
                        });
                        this.enable();
                        this.mode = "edit";
                    },
                    delete:function() {
                        $scope.$broadcast(ScopeEvent.deleteSection, this);
                    },
                    addIdea:function() {
                        $scope.$broadcast(ScopeEvent.createNewIdea, this);
                    },
                    cancel:function () {
                        _.each($scope.sections, function (section) {
                            section.enable();
                        });
                        this.mode = "view";
                    }
                });
            }
        }
    ]);