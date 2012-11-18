angular.module('idea-boardy')
    .factory('dialog', [function () {
        var dialogs = {};
        return function (dialogName) {
            var dialog = dialogs[dialogName];
            if (!dialog) {
                dialogs[dialogName] = dialog = new Dialog();
            }
            return dialog;
        };

        function Dialog() {
            this.visible = false;
            this.context = {};
            this.open = function (context) {
                this.context = context || {};
                this.visible = true;
            };
            this.close = function() {
                this.visible = false;
            };
        }
    }
]);