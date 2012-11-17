angular.module('idea-boardy')
    .directive('jqUi', function () {
        return function (scope, element, attrs) {
            element[attrs.jqUi].apply(element);
        };
    })

    .directive('jqUiDialog', ['$parse', '$window', function ($parse, $window) {
        return function (scope, element, attrs) {
            var options = JSON.parse(attrs.jqUiDialog || '{}'),
                visibilityExpr = attrs.ngShow,
                closeExpr = attrs.close,
                forExpr = attrs.for,
                targetElement = !!forExpr ? element.parents(forExpr) : $window,
                positionReference = targetElement.length > 0 ? targetElement : $window;
            element.dialog(_.extend(options, {
                title:attrs.title,
                autoOpen:false,
                modal:true,
                resizable:false,
                position:{my:'center center', at:'center', of: positionReference },
                show: 'fade',
                hide: 'fade',
                close:function () {
                    $parse(visibilityExpr).assign(scope, false) ;
                    $parse(closeExpr)(scope);
                }
            }));
            scope.$watch(function () {
                var needToOpen = scope.$eval(visibilityExpr);
                if(element.dialog('isOpen') !== needToOpen) {
                    element.dialog(needToOpen ? 'open' : 'close');
                }
            });
        }
    }]);