angular.module('idea-boardy')
    .directive('draggable', function () {
        return {
            require: ['draggable'],
            controller: ['$scope', '$attrs', '$parse', function($scope, $attrs, $parse) {
                var draggableTypeExpr = $attrs.type,
                    draggableModelExpr = $attrs.draggable;
                this.getType = function() {
                    return draggableTypeExpr;
                };
                this.getModel = function() {
                    return $parse(draggableModelExpr)($scope);
                };
            }],
            compile: function() {
                return function (scope, element) {
                    element.draggable({
                        revert:'invalid',
                        handle:'.handle',
                        helper:'clone',
                        appendTo: 'body',
                        opacity:0.8
                    });
                };
            }
        };
    })
    .directive('droppable', ['$parse', function ($parse) {
        return {
            require: 'droppable',
            controller: [function() {
                var handlers = {};
                this.addHandler = function(type, action) {
                    handlers[type] = action;
                };
                this.canAccept = function(type) {
                    return !!handlers[type];
                };
                this.getHandler = function(type) {
                    return handlers[type];
                };
            }],
            compile: function() {
                return function (scope, element, attrs, droppableCtrl) {
                    element.droppable({
                        activeClass: "droppable-active",
                        hoverClass: "droppable-hover",
                        tolerance: 'pointer',
                        greedy: true,
                        accept: function(draggable) {
                            var draggableElem = angular.element(draggable),
                                draggableCtrl = draggableElem.controller('draggable'),
                                draggableType = draggableCtrl.getType();
                            return droppableCtrl.canAccept(draggableType);
                        },
                        drop: function (event, ui) {
                            var draggableElem = angular.element(ui.draggable),
                                draggableCtrl = draggableElem.controller('draggable'),
                                draggableType = draggableCtrl.getType(),
                                handler = droppableCtrl.getHandler(draggableType),
                                draggableModel = draggableCtrl.getModel();
                            scope.$apply(function() {
                                $parse(handler)(scope, {$draggableModel: draggableModel});
                            });
                        }
                    });
                };
            }
        };
    }])
    .directive('draggableType', function() {
        return {
            require: '^droppable',
            compile: function() {
                return function(scope, element, attrs, droppableCtrl) {
                    droppableCtrl.addHandler(attrs.draggableType, attrs.action);
                };
            }
        };
    });