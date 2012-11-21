angular.module('idea-boardy')
    .directive('dropSource', function () {
        return {
            require:'^?ngModel',
            link:function (scope, droppable, attrs, ngModelCtrl) {
                ngModelCtrl.$formatters.push(function (modelValue) {
                    droppable.data("$$idea", modelValue)
                });

                droppable.draggable({
                    revert: "invalid",
                    containment: "document",
                    helper: "clone",
                    cursor: "move",
                    start:function (event, ui) {
                        droppable.addClass("drop-start");
                    },
                    stop:function (event, ui) {
                        droppable.removeClass("drop-start");
                    }
                });
            }
        };
    });

angular.module('idea-boardy')
    .directive('dropTarget', ['$http', '$compile', function ($http, $compile) {
    return {
        require:'^?ngModel',
        link:function (scope, dropTarget, attrs, ngModelCtrl) {
            var section;
            ngModelCtrl.$formatters.push(function (modelValue) {
                section = modelValue;
            });

            dropTarget.droppable({
                drop:function (event, ui) {
                    var item = ui.draggable;
                    var idea = $(item).inheritedData("$$idea");

                    $http.delete(idea.links.getLink("idea").href);
                    $http.post(section.links.getLink("ideas").href, idea);

                    moveItem(dropTarget, item);
                }
            });

            function moveItem(target, item){
                var blankIdeaContainer = $("li.blank", target).remove();
                item.fadeOut(function () {
                    item.appendTo(target).fadeIn(function () {
                        blankIdeaContainer.appendTo(target).fadeIn();
                        $("a", blankIdeaContainer).removeAttr("href");
                        scope.$apply(function(){
                            $compile(blankIdeaContainer)(scope);
                        });
                    });
                });
            }
        }
    };


}]);