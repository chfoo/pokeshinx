package pokeshinx.controller;

import pokeshinx.view.TitleView;

class TitleController implements Controller {
    var context:ControllerContext;
    var view:TitleView;

    public function new(context:ControllerContext, view:TitleView) {
        this.context = context;
        this.view = view;

        connectButtons();
    }

    function connectButtons() {
        view.startClicked.connect(function () {
            context.activateNext(ControllerTag.Play);
        });
    }

    public function update() {
        view.update();
    }

    public function layout() {
        view.layout();
    }

    public function activate() {
        view.show();
    }

    public function deactivate():MiniPromise {
        return view.hide();
    }
}