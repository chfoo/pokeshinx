package pokeshinx.controller;

import pokeshinx.model.ScoreModel;
import pokeshinx.view.GameOverView;

class GameOverController implements Controller {
    var context:ControllerContext;
    var view:GameOverView;
    var scoreModel:ScoreModel;

    public function new(context:ControllerContext, scoreModel:ScoreModel, view:GameOverView) {
        this.context = context;
        this.scoreModel = scoreModel;
        this.view = view;

        connectButtons();
    }

    function connectButtons() {
        view.restartClicked.connect(function () {
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
        view.showScores({
            clicked: scoreModel.clicked,
            missed: scoreModel.missed,
            fled: scoreModel.fled,
            total: scoreModel.getTotal()
        });
    }

    public function deactivate():MiniPromise {
        return view.hide();
    }
}