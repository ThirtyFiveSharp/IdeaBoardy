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
            this.params = {};
            this.open = function (params) {
                this.params = params || {};
                this.visible = true;
            };
            this.close = function() {
                this.visible = false;
            };
        }
    }
]);