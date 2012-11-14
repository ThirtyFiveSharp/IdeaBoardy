angular.module('idea-boardy').directive('doubleClick', ['$parse', function ($parse) {
    return function (scope, element, attr) {
        var fn = $parse(attr['doubleClick']);
        element.bind('dblclick', function (event) {
            scope.$apply(function () {
                fn(scope, {$event:event});
            });
        });
    };
}]);

angular.module('idea-boardy')
    .directive('sticker', ['$http', '$route', function ($http, $route) {
    return {
        template:'<div>'
            + ' <div class="edit-idea-dialog" title="Edit An Idea">'
            + '     <dl>'
            + '         <textarea style="width:100%; height: 5em;" ng:model="sticker.newContent"/>'
            + '     </dl>'
            + '     <div class="command-bar">'
            + '         <input class="btn-3 btn-ok" type="button" value="OK" ng:click="update()" jq-ui="button" />'
            + '         <input class="btn-3 btn-cancel" type="button" value="Cancel" ng:click="cancelEdit()" jq-ui="button" />'
            + '     </div>        '
            + ' </div>        '
            + ' <div class="delete-idea-dialog" title="Delete An Idea">'
            + '     <p>This brilliant idea is to be delete.</p>'
            + '     <p>Is that OK?</p>'
            + '     <div class="command-bar">'
            + '         <input class="btn-5 btn-ok" type="button" value="Yes, go ahead." ng:click="delete()" jq-ui="button" />'
            + '         <input class="btn-5 btn-cancel" type="button" value="No, take me back." ng:click="cancelDelete()" jq-ui="button" />'
            + '     </div>'
            + ' </div>        '
            + ' <div class="idea-wrapper"><div class="idea-info"><a class="idea-content" ng-click="showEditDialog()">{{sticker.content}}</a></div></div>'
            + ' <input class="btn-2 btn-trivial" type="button" value="+{{sticker.vote}}" ng:click="vote()" jq-ui="button" />'
            + ' <input class="btn-2 btn-trivial" type="button" value="Delete" ng:click="showDeleteDialog()" jq-ui="button" />'
            + '</div>',
        replace:true,
        restrict:'E',
        scope:true,
        require:"ngModel",
        link:function (scope, element, attr, ngModel) {
            var sticker,
                editDialog = element.find('.edit-idea-dialog'),
                deleteDialog = element.find('.delete-idea-dialog');


            ngModel.$formatters.push(function (modelValue) {
                $http.get(modelValue.links.getLink("idea").href).success(function (data) {
                    sticker = scope.sticker = enhanceSticker(data);
                });
            });

            function enhanceSticker(newSticker) {
                newSticker.update = function () {
                    $http.put(sticker.links.getLink("self").href, {content:sticker.newContent})
                        .success(refreshIdea);
                };
                newSticker.addVote = function () {
                    $http.post(sticker.links.getLink("vote").href).success(refreshIdea);
                };
                newSticker.delete = function () {
                    $http.delete(sticker.links.getLink("self").href).success($route.reload);
                };
                return newSticker;
            }

            function refreshIdea() {
                $http.get(scope.sticker.links.getLink("self").href)
                    .success(function(data) {
                        sticker = scope.sticker = enhanceSticker(data);
                    });
            }

            scope.showEditDialog = function () {
                sticker.newContent = sticker.content;
                editDialog.dialog("open");
            };

            scope.showDeleteDialog = function () {
                deleteDialog.dialog("open");
            };

            scope.update = function () {
                if(!sticker.newContent) return;
                editDialog.dialog("close");
                sticker.update();
                sticker.content = sticker.newContent;
            };

            scope.cancelEdit = function () {
                editDialog.dialog("close");
            };

            scope.cancelDelete = function () {
                deleteDialog.dialog("close");
            };

            scope.vote = function () {
                sticker.addVote();
            };

            scope.delete = function () {
                deleteDialog.dialog("close");
                sticker.delete();
            };

            $(function () {
                editDialog.dialog({
                    autoOpen:false,
                    resizable:false,
                    width:400,
                    position: {of: element},
                    show:"fade",
                    hide:"fade"
                });
                deleteDialog.dialog({
                    autoOpen:false,
                    modal:true,
                    resizable:false,
                    width:400,
                    show:"fade",
                    hide:"fade"
                });
            });
        }
    }
}]);

angular.module('idea-boardy')
    .directive('ideaCreation', ['$http', '$route', function ($http, $route) {
    return {
        template:'<a ng:click="showDialog()">'
            + ' <div class="create-idea-dialog" title="Create A New Idea">'
            + '     <dl>'
            + '         <textarea style="width:100%; height: 5em;" ng:model="idea.content"/>'
            + '     </dl>'
            + '     <div class="command-bar">'
            + '         <input class="btn-3 btn-ok" type="button" value="OK" ng:click="createNewIdea()" jq-ui="button" />'
            + '         <input class="btn-3 btn-cancel" type="button" value="Cancel" ng:click="cancel()" jq-ui="button" />'
            + '     </div>        '
            + ' </div>        '
            + ' + 1 idea '
            + '</a>',
        replace:true,
        restrict:'E',
        scope:true,
        require:"ngModel",
        link:function (scope, element, attr, ngModel) {
            var section,
                dialog = element.find('.create-idea-dialog');

            ngModel.$formatters.push(function (modelValue) {
                $http.get(modelValue.links.getLink("section").href).success(function (data) {
                    section = transformSection(data);
                });
            });

            function transformSection(newSection) {
                newSection.createNewIdea = function () {
                    $http.post(section.links.getLink("ideas").href, { content:scope.idea.content}).success($route.reload);
                };
                return newSection;
            }

            scope.showDialog = function () {
                scope.idea = {};
                dialog.dialog("open");
            };

            scope.createNewIdea = function () {
                if(!scope.idea.content) return;
                dialog.dialog("close");
                section.createNewIdea();
            };

            scope.cancel = function () {
                dialog.dialog("close");
            };

            $(function () {
                dialog.dialog({
                    autoOpen:false,
                    resizable:false,
                    width:400,
                    position:{of: element},
                    show:"fade",
                    hide:"fade"
                });
            });
        }
    }
}]);

