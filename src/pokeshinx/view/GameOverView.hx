package pokeshinx.view;

import h2d.Flow;
import h2d.Scene;
import haxe.ds.Option;
import pokeshinx.view.model.Scores;
import pokeshinx.view.object.Button;
import pokeshinx.view.object.Scoreboard;
import pokeshinx.view.tween.RevealTweener;
import zigcall.Signal;

class GameOverView implements View {
    public var restartClicked(default, null):SignalClient;

    var _restartClicked:Signal;

    var scene2d:Scene;

    var container:Flow;
    var scoreboard:Scoreboard;
    var restartButton:Button;
    var revealTweener:RevealTweener;
    var hidePromise:Option<MiniPromise>;

    public function new(scene2d:Scene) {
        this.scene2d = scene2d;
        restartClicked = _restartClicked = new Signal();

        container = new Flow();
        scoreboard = new Scoreboard(container);
        restartButton = new Button(container);
        revealTweener = new RevealTweener(container);

        restartButton.clicked.connect(_restartClicked.emit);
        restartButton.text = "Play Again";

        container.isVertical = true;
        container.horizontalAlign = FlowAlign.Middle;
        container.verticalSpacing = 10;
    }

    public function update() {
        scoreboard.update();
        revealTweener.update();

        if (!revealTweener.visible) {
            scene2d.removeChild(container);
        }
    }

    public function layout() {
        container.setScale(ScreenUtil.getScreenScale());
        var bounds = container.getBounds();

        container.x = (scene2d.width - bounds.width) / 2;
        container.y = (scene2d.height - bounds.height) / 2;
    }

    public function showScores(scores:Scores) {
        scoreboard.setScores(scores);
        scoreboard.show();
    }

    public function show() {
        scene2d.addChild(container);
        layout();
        revealTweener.show();
    }

    public function hide():MiniPromise {
        return revealTweener.hide();
    }
}