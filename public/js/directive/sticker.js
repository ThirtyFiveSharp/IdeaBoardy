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
            + ' <div class="dialog" title="Sticker Edition">'
            + '     <textarea ng:model="sticker.newContent"/>'
            + '     <input type="button" value="Update" ng:click="update()">'
            + '     <input type="button" value="Cancel" ng:click="cancel()">'
            + ' </div>        '
            + ' <div style="width: 100; height: 100px;" double-click="showDialog()">{{sticker.content}}</div>'
            + ' <span>{{sticker.vote}}</span>'
            + ' <input type="button" value="Vote" ng:click="vote()">'
            + ' <input type="button" value="Delete" ng:click="delete()">'
            + '</div>',
        replace:true,
        restrict:'E',
        scope:true,
        require:"ngModel",
        link:function (scope, element, attr, ngModel) {
            var sticker,
                dialog = element.find('.dialog'),
                opener = element.find('.opener');


            ngModel.$formatters.push(function (modelValue) {
                $http.get(modelValue.links.getLink("idea").href).success(function (data) {
                    sticker = scope.sticker = enhanceSticker(data);
                    console.log("sticker", sticker)
                });
            });

            function enhanceSticker(newSticker) {
                newSticker.update = function () {
                    $http.put(sticker.links.getLink("self").href, { content:sticker.newContent});
                };
                newSticker.addVote = function () {
                    $http.post(sticker.links.getLink("vote").href).success($route.reload);
                };
                newSticker.delete = function () {
                    $http.delete(sticker.links.getLink("self").href).success($route.reload);
                };
                return newSticker;
            }

            scope.showDialog = function () {
                sticker.newContent = sticker.content;
                dialog.dialog("open");
            };

            scope.update = function () {
                sticker.update();
                sticker.content = sticker.newContent;
                dialog.dialog("close");
            };

            scope.cancel = function () {
                dialog.dialog("close");
            };

            scope.vote = function () {
                sticker.addVote();
            };

            scope.delete = function () {
                sticker.delete();
            };

            $(function () {
                dialog.dialog({
                    autoOpen:false,
                    show:"blind",
                    hide:"explode"
                });

                opener.click(function () {
                    dialog.dialog("open");
                    return false;
                });
            });
        }
    }
}]);


angular.module('idea-boardy')
    .directive('ideaCreation', ['$http', '$route', function ($http, $route) {
    return {
        template:'<div>'
            + ' <div class="dialog" title="Create a New Idea">'
            + '     <textarea ng:model="idea.content"/>'
            + '     <input type="button" value="Create" ng:click="createNewIdea()">'
            + '     <input type="button" value="Cancel" ng:click="cancel()">'
            + ' </div>        '
            + ' <input type="button" class="btn-2"  jq-ui="button" value="+ 1 idea" ng:click="showDialog()">'
            + '</div>',
        replace:true,
        restrict:'E',
        scope:true,
        require:"ngModel",
        link:function (scope, element, attr, ngModel) {
            var section,
                dialog = element.find('.dialog');

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
                section.createNewIdea();
                dialog.dialog("close");
            };

            scope.cancel = function () {
                dialog.dialog("close");
            };

            $(function () {
                dialog.dialog({
                    autoOpen:false,
                    show:"blind",
                    hide:"explode"
                });
            });
        }
    }
}]);

