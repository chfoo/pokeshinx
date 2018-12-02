package pokeshinx.view;

import hxd.Timer;
import de.polygonal.Printf;
import h2d.Object;
import h2d.Scene;
import haxe.ds.Vector;
import pokeshinx.view.object.OverlayText;
import pokeshinx.view.object.TargetParticles;

private enum HUDState {
    Ready;
    Countdown;
    Running;
    Ending;
}

class HUDView implements View {
    var scene2d:Scene;
    var state:HUDState = Ready;
    var scheduler:Scheduler;

    var container:Object;
    var timeText:OverlayText;
    var overlayTexts:Vector<OverlayText>;
    var overlayTextsIndex = 0;
    var targetParticles:TargetParticles;

    public function new(scene2d:Scene) {
        this.scene2d = scene2d;

        scheduler = new Scheduler();
        container = new Object();
        timeText = new OverlayText(container);
        overlayTexts = new Vector(5);

        for (index in 0...overlayTexts.length) {
            overlayTexts[index] = new OverlayText(container);
        }

        targetParticles = new TargetParticles(container);

        timeText.overlayPosition = OverlayTextPosition.CenterTop;
        timeText.baseScale = 2.0;

        layout();
    }

    public function update() {
        switch state {
            case Countdown:
                updateCountdown();
            case Running:
                updateRunning();
            case Ending:
                // pass
            case Ready:
                // pass
        }

        scheduler.update();

        for (overlayText in overlayTexts) {
            overlayText.update();
        }

        timeText.update();
    }

    function updateCountdown() {
    }

    function updateRunning() {
    }

    public function layout() {
        timeText.layout();

        for (overlayText in overlayTexts) {
            overlayText.layout();
        }
    }

    public function updateTime(seconds:Float) {
        timeText.text = Printf.format("%.1f", [seconds]);
    }

    function showCenterText(text:String) {
        var overlayText = getFreeOverlayText();
        overlayText.text = text;
        overlayText.overlayPosition = OverlayTextPosition.CenterMiddle;
        overlayText.baseScale = 2.0;
        overlayText.showTransient();
    }

    function getFreeOverlayText():OverlayText {
        var overlayText = overlayTexts[overlayTextsIndex];

        overlayTextsIndex += 1;

        if (overlayTextsIndex >= overlayTexts.length) {
            overlayTextsIndex = 0;
        }

        return overlayText;
    }

    public function showClicked(x:Float, y:Float) {
        // showClickText(x, y, "Poked!");
        targetParticles.show(x, y);
    }

    public function showMissed(x:Float, y:Float) {
        showClickText(x, y, "MISS");
    }

    function showClickText(x:Float, y:Float, text:String) {
        var overlayText = getFreeOverlayText();
        overlayText.overlayPosition = Absolute(x, adjustYAboveCursor(y));
        overlayText.text = text;
        overlayText.baseScale = 1.0;
        overlayText.showTransient();
    }

    function adjustYAboveCursor(y:Float):Float {
        var newY = y - scene2d.height * 0.1;

        if (newY < 0) {
            // If offscreen, then put it under the cursor
            newY = y + scene2d.height * 0.1;
        }

        return newY;
    }

    public function showCountdown() {
        state = Countdown;

        showCenterText("3");

        scheduler.delay(1, showCenterText.bind("2"));
        scheduler.delay(2, showCenterText.bind("1"));
    }

    public function showTimer() {
        showCenterText("START");
        state = Running;
        timeText.show();
    }

    public function showEnd() {
        state = Ending;
        showCenterText("FINISH");
        timeText.hide();
    }

    public function show() {
        scene2d.addChild(container);
    }

    public function hide():MiniPromise {
        state = Ready;
        scene2d.removeChild(container);

        return MiniPromise.asResolved();
    }
}