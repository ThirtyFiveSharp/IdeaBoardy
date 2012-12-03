angular.module('idea-boardy')
    .controller('SectionController', ['$scope', '$http', 'dialog', 'events',
    function ($scope, $http, dialog, events) {
        var deleteSectionDialog = dialog('deleteSectionDialog'),
            createIdeaDialog = dialog('createIdeaDialog');
        $http.get($scope.section.links.getLink('section').href)
            .success(function (data) {
                $scope.section = enhanceSection(data);
                refreshIdeas();
            });

        $scope.showDeleteSectionDialog = function () {
            deleteSectionDialog.open({sectionToDelete:$scope.section});
        };
        $scope.showCreateIdeaDialog = function ($event) {
            createIdeaDialog.open({section:$scope.section, ideaToCreate:{}, $event:$event});
        };

        $scope.$on(events.editSection, function (event, targetSection) {
            if ($scope.section == targetSection) {
                $scope.section.mode = "edit";
            }
            else {
                $scope.section.editable = false;
            }
        });
        $scope.$on(events.sectionEditingFinished, function (event, targetSection) {
            if ($scope.section == targetSection) {
                $scope.section.mode = "view";
            }
            else {
                $scope.section.editable = true;
            }
        });
        $scope.$on(events.ideaDeleted, function (event, ideaIndex) {
            if (event.stopPropagation) event.stopPropagation();
            $scope.ideas.splice(ideaIndex, 1);
            refreshSection();
        });
        $scope.$on(events.ideaMerged, function (event, sourceIdea) {
            if (event.stopPropagation) event.stopPropagation();
            if(_.any($scope.ideas, function(idea) {return idea.id == sourceIdea.id})) return;
            refreshSection();
        });
        $scope.$on(events.ideaEmigrated, function (event) {
            if (event.stopPropagation) event.stopPropagation();
            refreshSection();
        });

        function enhanceSection(rawSection) {
            return angular.extend(rawSection, {
                selfLink:rawSection.links.getLink('self'),
                mode:"view",
                editable:true,
                expanded:true,
                enable:function () {
                    this.editable = true;
                },
                disable:function () {
                    this.editable = false;
                },
                edit:function () {
                    $scope.$emit(events.editSection, this);
                },
                save:function(updatedSection) {
                    $http.put(this.selfLink.href, updatedSection)
                        .success(function() {
                            refreshSection();
                            $scope.$emit(events.sectionEditingFinished);
                        });
                },
                delete:function () {
                    $http.delete(this.selfLink.href).success(function () {
                        $scope.$emit(events.sectionDeleted, $scope.$index);
                    });
                },
                createIdea:function (ideaToCreate) {
                    $http.post(this.links.getLink('ideas').href, ideaToCreate).success(refreshSection);
                },
                addImmigrant:function (sourceIdea) {
                    if (_.any($scope.ideas, function (idea) {
                        return idea.id == sourceIdea.id
                    })) return;
                    $http.post(this.links.getLink('immigration').href, {source:sourceIdea.id})
                        .success(function () {
                            sourceIdea.notifyEmigrated();
                            refreshSection();
                        });
                },
                cancel:function () {
                    $scope.$emit(events.sectionEditingFinished, this);
                },
                toggleExpand: function() {
                    this.expanded = !this.expanded;
                }
            });
        }

        function refreshSection() {
            $http.get($scope.section.selfLink.href).success(function (data) {
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