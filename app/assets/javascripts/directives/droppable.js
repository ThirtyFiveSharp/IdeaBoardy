angular.module('idea-boardy')
    .directive('dropSource', function () {
        return {
            require:'^?ngModel',
            link:function (scope, droppable, attrs, ngModelCtrl) {
                ngModelCtrl.$formatters.push(function (modelValue) {
                    droppable.data("$$idea", modelValue)
                });

                droppable.draggable({
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
    .directive('dropTarget', ['$http', function ($http) {
    return {
        require:'^?ngModel',
        link:function (scope, dropTarget, attrs, ngModelCtrl) {
            var section;
            ngModelCtrl.$formatters.push(function (modelValue) {
                section = modelValue;
            });

            dropTarget.droppable({
//                    activate:function (event, ui) {
//                        console.log("Drop here !", ui);
//                    },
//                    over:function (event, ui) {
//                        console.log("Oh, Yeah!", ui);
//                    },
//                    out:function (event, ui) {
//                        console.log("Don't leave me!", ui);
//                    },
                drop:function (event, ui) {
                    var idea = $(ui.draggable).inheritedData("$$idea");
                    $http.delete(idea.links.getLink("idea").href);
                    $http.post(section.links.getLink("ideas").href, idea);
                }
            });
        }
    };
}]);