angular.module('idea-boardy')
    .directive('jqUi', function () {
        return function (scope, element, attrs) {
            element[attrs.jqUi].apply(element);
        };
    })

    .directive('jqUiDialog', ['dialog', function (dialog) {
        return function (scope, element, attrs) {
            var name = attrs.name || getRandomDialogName(),
                options = JSON.parse(attrs.jqUiDialog || '{}');
            element.dialog(_.extend(options, {
                title:attrs.title,
                autoOpen:false,
                modal:true,
                resizable:false,
                show: 'fade',
                hide: 'fade',
                close:function () {
                    dialog(name).close();
                }
            }));
            scope.$watch(function () {
                var needToOpen = dialog(name).visible;
                if(element.dialog('isOpen') !== needToOpen) {
                    var targetElement = (dialog(name).context.$event || {}).currentTarget || window;
                    element.dialog('option', 'position', {of: targetElement})
                        .dialog(needToOpen ? 'open' : 'close');
                }
            });

            function getRandomDialogName() {
                return "dialog_" + new Date().getTime();
            }
        }
    }]);