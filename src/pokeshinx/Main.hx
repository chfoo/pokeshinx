package pokeshinx;

import hxd.App;
import hxd.Res;
import pokeshinx.controller.Controller;
import pokeshinx.controller.ControllerContext;
import pokeshinx.controller.ControllerTag;
import pokeshinx.controller.GameOverController;
import pokeshinx.controller.PlayController;
import pokeshinx.controller.TitleController;
import pokeshinx.MiniPromise;
import pokeshinx.model.PlayModel;
import pokeshinx.view.GameOverView;
import pokeshinx.view.HUDView;
import pokeshinx.view.PlayView;
import pokeshinx.view.TitleView;

private enum ActivationPendingState {
    None;
    Pending(promise:MiniPromise, tag:ControllerTag);
}

class Main extends App {
    var controllerContext:ControllerContext;
    var controller:Controller;
    var activationPending:ActivationPendingState = None;

    var titleController:TitleController;
    var playController:PlayController;
    var gameOverController:GameOverController;

    var playModel:PlayModel;

    override function init() {
        Res.initEmbed();

        controllerContext = new ControllerContext();

        s2d.defaultSmooth = true;

        ResizeHelper.init();

        engine.backgroundColor = 0xff000000 | 0x3360b6;

        initTitle();
        initPlay();
        initGameOver();
        activateFirstController(ControllerTag.Title);
    }

    function initTitle() {
        var view = new TitleView(s2d);
        titleController = new TitleController(controllerContext, view);
    }

    function initPlay() {
        playModel = new PlayModel();
        var view = new PlayView(s2d);
        var hudView = new HUDView(s2d);
        playController = new PlayController(controllerContext, playModel, view, hudView);
    }

    function initGameOver() {
        var view = new GameOverView(s2d);
        gameOverController = new GameOverController(controllerContext, playModel.score, view);
    }

    override function update(dt:Float) {
        super.update(dt);

        processControllerActivation();
        controller.update();
    }

    static function main() {
        new Main();
    }

    override function onResize() {
        controller.layout();
    }

    function activateFirstController(tag:ControllerTag) {
        controller = getControllerFromTag(tag);
        controller.activate();
    }

    function processControllerActivation() {
        if (controllerContext.nextRequested) {
            activationPending = Pending(controller.deactivate(), controllerContext.nextTag);
            controllerContext.resetNext();
        }

        switch activationPending {
            case Pending(promise, nextTag):
                if (promise.isResolved) {
                    controller = getControllerFromTag(nextTag);
                    controller.activate();
                    activationPending = None;
                }
            case None:
                // pass
        }
    }

    function getControllerFromTag(tag:ControllerTag):Controller {
        switch tag {
            case ControllerTag.Title:
                return titleController;
            case ControllerTag.Play:
                return playController;
            case ControllerTag.GameOver:
                return gameOverController;
        }
    }
}
