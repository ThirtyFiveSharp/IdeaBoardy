angular.module('idea-boardy')
    .directive('draggable', function () {
        return function (scope, element) {
            element.draggable({
                revert:'invalid',
                handle:'.handle',
                helper:'clone',
                appendTo: 'body',
                cursor:'move',
                opacity:0.8
            });
        };
    })
    .directive('droppable', ['$parse', function ($parse) {
        return function (scope, dropTarget, attrs) {
            var dropExpr = attrs.droppable;
            dropTarget.droppable({
                activeClass: "droppable-active",
                hoverClass: "droppable-hover",
                tolerance: 'pointer',
                greedy: true,
                drop: function (event, ui) {
                    var draggableModelController = angular.element(ui.draggable).controller('ngModel');
                    scope.$apply(function() {
                        $parse(dropExpr)(scope, {$draggableModel: draggableModelController.$modelValue});
                    });
                }
            });
        };
    }]);