angular.module('idea-boardy')
    .directive('jqUi', function () {
        return function (scope, element, attrs) {
            element[attrs.jqUi].apply(element);
        };
    })

    .directive('jqUiDialog', function () {
        return function (scope, element, attrs) {
            var options = JSON.parse(attrs.jqUiDialog || '{}'),
                visibilityExpr = attrs.ngShow,
                onCloseFnExpr = attrs.onClose;
            element.dialog(_.extend(options, {
                title:attrs.title,
                autoOpen:false,
                modal:true,
                resizable:false,
                position:{my:'center center-50%', at:'center', of:window},
                close:function () {
                    scope[visibilityExpr] = false;
                    (scope[onCloseFnExpr] || angular.noop)();
                }
            }));
            scope.$watch(function () {
                var needToOpen = scope.$eval(visibilityExpr);
                if(element.dialog('isOpen') !== needToOpen) {
                    element.dialog(needToOpen ? 'open' : 'close');
                }
            });
        }
    });