angular.module('idea-boardy')
    .controller('SectionController', ['$scope', '$http', 'dialog',
        function ($scope, $http, dialog) {
            var deleteSectionDialog = dialog('deleteSectionDialog'),
                createIdeaDialog = dialog('createIdeaDialog');
            $http.get($scope.section.links.getLink('section').href)
                .success(function(data) {
                    $scope.section = enhanceSection(data);
                    refreshIdeas();
                });

            $scope.showDeleteSectionDialog = function() {
                deleteSectionDialog.open({sectionToDelete: $scope.section});
            };
            $scope.showCreateIdeaDialog = function($event) {
                createIdeaDialog.open({section: $scope.section, ideaToCreate: {}, $event: $event});
            };

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
            $scope.$on(ScopeEvent.ideaDeleted, function(event, ideaIndex) {
                if(event.stopPropagation) event.stopPropagation();
                $scope.ideas.splice(ideaIndex, 1);
                refreshSection();
            });

            function enhanceSection(rawSection) {
                return angular.extend(rawSection, {
                    selfLink:rawSection.links.getLink('self'),
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
                        $http.delete(this.selfLink.href).success(function() {
                            $scope.$emit(ScopeEvent.sectionDeleted, $scope.$index);
                        });
                    },
                    createIdea:function(ideaToCreate) {
                        $http.post(this.links.getLink('ideas').href, ideaToCreate).success(refreshSection);
                    },
                    cancel:function () {
                        $scope.$emit(ScopeEvent.cancelEditSection, this);
                    }
                });
            }
            function refreshSection() {
                $http.get($scope.section.selfLink.href).success(function(data) {
                    $scope.section = enhanceSection(data);
                    refreshIdeas();
                });
            }
            function refreshIdeas() {
                $http.get($scope.section.links.getLink('ideas').href).success(function (ideas) {
                    $scope.ideas = ideas;
                });
            }
        }
    ]);