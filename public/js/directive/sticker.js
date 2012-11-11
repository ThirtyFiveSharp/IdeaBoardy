angular.module('idea-boardy')
    .directive('sticker', function () {
    return {
        template:'<div>'
            + ' <div class="dialog" title="Sticker Edition">'
            + '     <textarea ng:model="sticker.newContent"/>'
            + '     <input type="button" value="Update" ng:click="update()">'
            + '     <input type="button" value="Cancel" ng:click="cancel()">'
            + ' </div>        '
            + ' <div style="width: 100; height: 100px;" ng:click="showDialog()">{{sticker.content}}</div>'
            + ' <span>{{sticker.vote}}</span>'
            + ' <input type="button" value="Vote" ng:click="vote()">'
            + '</div>',
        replace:true,
        restrict:'E',
        scope:true,
        require:"ngModel",
        link:function (scope, element, attr, ngModel) {
            var sticker,
                dialog = element.find('.dialog'),
                opener = element.find('.opener');

            ngModel.$formatters.push(function(modelValue){
                sticker = modelValue;
            });

            scope.showDialog = function () {
                sticker.newContent = sticker.content;
                dialog.dialog("open");
            };

            scope.showDialog = function () {
                dialog.dialog("open");
            };

            scope.update = function () {
                sticker.content = sticker.newContent;
                dialog.dialog("close");
            };

            scope.cancel = function () {
                dialog.dialog("close");
            };

            scope.vote = function () {
                sticker.vote++;
            };

//            $.fx.speeds._default = 1000;
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
});
