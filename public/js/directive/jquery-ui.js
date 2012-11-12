angular.module('idea-boardy')
    .directive('jqUi', function () {
        return function (scope, element, attrs) {
            element[attrs.jqUi].apply(element);
        };
    })

    .directive('jqUiDialog', ['$parse', function ($parse) {
        return function (scope, element, attrs) {
            var options = JSON.parse(attrs.jqUiDialog || '{}'),
                visibilityExpr = attrs.ngShow,
                closeExpr = attrs.close;
            element.dialog(_.extend(options, {
                title:attrs.title,
                autoOpen:false,
                modal:true,
                resizable:false,
                position:{my:'center center-50%', at:'center', of:window},
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