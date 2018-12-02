package pokeshinx.controller;

import pokeshinx.view.PlayView;
import pokeshinx.view.HUDView;
import pokeshinx.model.PlayModel;

class PlayController implements Controller {
    var context:ControllerContext;
    var model:PlayModel;
    var view:PlayView;
    var hudView:HUDView;

    public function new(context:ControllerContext, model:PlayModel, view:PlayView, hudView:HUDView) {
        this.context = context;
        this.model = model;
        this.view = view;
        this.hudView = hudView;

        connectModel();
        connectView();
    }

    function connectModel() {
        model.stateChanged.connect(playStateChangedCallback);

        for (index in 0...model.targets.length) {
            var target = model.targets[index];

            target.hideRequested.connect(function () {
                view.hideTarget(index, target.hasClicked);
            });
            target.showRequested.connect(view.showTarget.bind(index));
        }
    }

    function connectView() {
        view.targetClicked.connect(targetClickedViewCallback);
        view.groundClicked.connect(groundClickedViewCallback);
    }

    function playStateChangedCallback() {
        switch model.state {
            case PlayState.Ready:
                // pass
            case PlayState.Countdown:
                hudView.showCountdown();
            case PlayState.Running:
                hudView.showTimer();
            case PlayState.Ending:
                hudView.showEnd();
            case PlayState.GameOver:
                context.activateNext(ControllerTag.GameOver);
        }
    }

    function targetClickedViewCallback(info:TargetClickedInfo) {
        if (model.state.equals(PlayState.Running)) {
            model.targets[info.index].click();
            hudView.showClicked(info.x, info.y);
        }
    }

    function groundClickedViewCallback(info:GroundClickedInfo) {
        if (model.state.equals(PlayState.Running)) {
            model.clickGround();
            hudView.showMissed(info.x, info.y);
        }
    }

    public function update() {
        model.update();

        view.update();

        hudView.updateTime(model.timeRemaining);
        hudView.update();
    }

    public function layout() {
        view.layout();
        hudView.layout();
    }

    public function activate() {
        view.reset();
        model.reset();
        view.show();
        hudView.show();
    }

    public function deactivate():MiniPromise {
        return MiniPromise.aggregate([view.hide(), hudView.hide()]);
    }
}