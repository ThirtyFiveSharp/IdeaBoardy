angular.module('idea-boardy')
    .controller('SectionController', ['$scope', '$http', 'dialog', 'events', 'autoUpdater',
    function ($scope, $http, dialog, events, autoUpdater) {
        var createIdeaDialog = dialog('createIdeaDialog');
        $http.get($scope.section.links.getLink('section').href, {params:{embed:"ideas"}})
            .success(function (section) {
                $scope.section = enhanceSection(section);
                refreshIdeas(section.ideas);
            });

        autoUpdater.register($scope.section.links.getLink('section').href, refreshSection, function () {
            //TODO: skip auto update when section is collapsed?
            return $scope.section.mode === 'view' && $scope.section.expanded;
        });

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
            if (_.any($scope.ideas, function (idea) {
                return idea.id == sourceIdea.id;
            })) return;
            refreshSection();
        });
        $scope.$on(events.ideaEmigrated, function (event) {
            if (event.stopPropagation) event.stopPropagation();
            refreshSection();
        });
        $scope.filterIdeas = function (idea) {
            var keyword = $scope.keyword;
            if (!keyword) {
                return idea;
            }
            var regexp = new RegExp(keyword, 'gi');
            var content = idea.content;
            if (content.match(regexp)) {
                return idea;
            }
            var isAnyTagMatch = _.any(idea.tags, function (tag) {
                return tag.name.match(regexp);
            });
            if (isAnyTagMatch) {
                return idea;
            }
            var isVoteMatch = idea.vote == keyword;
            if (isVoteMatch) {
                return idea;
            }
            return undefined;
        };

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
                save:function (updatedSection) {
                    $http.put(this.selfLink.href, updatedSection)
                        .success(function () {
                            refreshSection(true);
                            $scope.$emit(events.sectionEditingFinished);
                        });
                },
                delete:function () {
                    $http.delete(this.selfLink.href).success(function () {
                        $scope.$emit(events.sectionDeleted, $scope.$index);
                    });
                },
                createIdea:function (ideaToCreate) {
                    $http.post(this.links.getLink('ideas').href, ideaToCreate)
                        .success(function () {
                            refreshSection();
                        });
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
                toggleExpand:function () {
                    this.expanded = !this.expanded;
                }
            });
        }

        function refreshSection(skipIdeas) {
            $http.get($scope.section.selfLink.href, {params:{embed:"ideas"}})
                .success(function (section) {
                    $scope.section = enhanceSection(section);
                    if (!skipIdeas) refreshIdeas(section.ideas);
                });
        }

        function refreshIdeas(ideas) {
            _.each(ideas, function (idea) {
                angular.extend(idea, {
                    $$hashKey:function () {
                        var hashKey = this.id + '_' + this.content + '_' + this.vote;
                        hashKey = _.reduce(this.tags, function (key, tag) {
                            return key + '_' + tag.id;
                        }, hashKey);
                        return hashKey;
                    }
                });
            });
            $scope.ideas = ideas;
        }
    }
]);