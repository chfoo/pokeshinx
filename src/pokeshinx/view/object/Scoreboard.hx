package pokeshinx.view.object;

import h2d.Object;
import h2d.Text;
import pokeshinx.view.model.Scores;
import pokeshinx.view.tween.TweenRate;

using tweenxcore.Tools;

class Scoreboard extends Object {
    static inline var _WIDTH = 150;
    static inline var SCORE_TWEEN_DURATION = 2.0;

    var clickedLabel:UIText;
    var fledLabel:UIText;
    var missedLabel:UIText;
    var totalLabel:UIText;

    var clickedScore:UIText;
    var fledScore:UIText;
    var missedScore:UIText;
    var totalScore:UIText;

    var scores:Scores;

    var scoreTweenRate:TweenRate;
    var tweenRate:TweenRate;

    public function new(?parent:Object) {
        super(parent);

        clickedLabel = new UIText(this);
        fledLabel = new UIText(this);
        missedLabel = new UIText(this);
        totalLabel = new UIText(this);

        clickedScore = new UIText(this);
        fledScore = new UIText(this);
        missedScore = new UIText(this);
        totalScore = new UIText(this);

        clickedLabel.maxWidth = _WIDTH;
        fledLabel.maxWidth = _WIDTH;
        missedLabel.maxWidth = _WIDTH;
        totalLabel.maxWidth = _WIDTH;

        clickedScore.maxWidth = _WIDTH;
        fledScore.maxWidth = _WIDTH;
        missedScore.maxWidth = _WIDTH;
        totalScore.maxWidth = _WIDTH;

        clickedLabel.y = clickedScore.y = 0;
        fledLabel.y = fledScore.y = clickedLabel.lineHeight;
        missedLabel.y = missedScore.y = clickedLabel.lineHeight * 2;
        totalLabel.y = totalScore.y = clickedLabel.lineHeight * 3;

        clickedScore.textAlign = Align.Right;
        fledScore.textAlign = Align.Right;
        missedScore.textAlign = Align.Right;
        totalScore.textAlign = Align.Right;

        clickedLabel.text = "Poked";
        fledLabel.text = "Missed";
        missedLabel.text = "xxxxx";
        totalLabel.text = "Final score";

        scoreTweenRate = new TweenRate(SCORE_TWEEN_DURATION);

        missedLabel.visible = false;
        missedScore.visible = false;
    }

    public function setScores(scores:Scores) {
        this.scores = scores;
    }

    public function update() {
        if (scoreTweenRate.running) {
            var rate = scoreTweenRate.get();
            clickedScore.text = Std.string(Std.int(rate.linear().lerp(0, scores.clicked)));
            fledScore.text = Std.string(Std.int(rate.linear().lerp(0, scores.fled)));
            missedScore.text = Std.string(Std.int(rate.linear().lerp(0, scores.missed)));
            totalScore.text = Std.string(Std.int(rate.linear().lerp(0, scores.total)));
        }
    }

    public function show() {
        scoreTweenRate.restart();
    }
}
