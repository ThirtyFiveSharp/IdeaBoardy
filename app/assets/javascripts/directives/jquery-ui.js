angular.module('idea-boardy')
    .directive('jqUi', function () {
        return function (scope, element, attrs) {
            element[attrs.jqUi].apply(element);
        };
    })

    .directive('jqUiDialog', ['$parse', 'dialog', function ($parse, dialog) {
        return function (scope, element, attrs) {
            var name = attrs.name,
                options = JSON.parse(attrs.jqUiDialog || '{}'),
                visibilityExpr = attrs.ngShow,
                closeExpr = attrs.close;
            element.dialog(_.extend(options, {
                title:attrs.title,
                autoOpen:false,
                modal:true,
                resizable:false,
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
                    var targetElement = (dialog(name).params.$event || {}).currentTarget || window;
                    element.dialog('option', 'position', {of: targetElement}).dialog(needToOpen ? 'open' : 'close');
                }
            });
        }
    }]);