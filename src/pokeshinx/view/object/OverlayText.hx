package pokeshinx.view.object;

import h2d.Object;
import h2d.Text;
import hxd.Timer;
import pokeshinx.view.tween.RevealTweener;

enum OverlayTextPosition {
    CenterTop;
    CenterMiddle;
    Absolute(x:Float, y:Float);
}

class OverlayText extends Object {
    static inline var TRANSIENT_DISPLAY_DURATION = 1.0;

    public var overlayPosition:OverlayTextPosition = CenterMiddle;
    public var baseScale:Float = 1;
    public var text(get, set):String;

    var internalText:UIText;
    var revealTweener:RevealTweener;
    var transientTimestamp = 0.0;
    var active = false;
    var layoutDirty = true;

    public function new(?parent:Object) {
        super(parent);

        internalText = new UIText(this);
        revealTweener = new RevealTweener(internalText, true);
        internalText.textAlign = Align.Center;
    }

    function get_text():String {
        return internalText.text;
    }

    function set_text(value:String):String {
        return internalText.text = value;
    }

    public function update() {
        var scene = getScene();

        if (scene == null) {
            return;
        }

        if (transientTimestamp > 0) {
            var elapsedTime = Timer.lastTimeStamp - transientTimestamp;

            if (elapsedTime >= TRANSIENT_DISPLAY_DURATION) {
                hide();
            }
        }

        if (layoutDirty) {
            layout();
        }

        revealTweener.update();
    }

    public function show() {
        if (!active) {
            active = true;
            revealTweener.show();
            layoutDirty = true;
        }
    }

    public function hide() {
        if (active) {
            active = false;
            revealTweener.hide();
        }
    }

    public function showTransient() {
        transientTimestamp = Timer.lastTimeStamp;
        show();
    }

    public function layout() {
        var scene = getScene();

        if (scene == null) {
            return;
        }

        internalText.setScale(baseScale * ScreenUtil.getScreenScale());

        switch overlayPosition {
            case CenterTop:
                internalText.maxWidth = scene.width / internalText.scaleX;
                x = 0;
                y = 0;
            case CenterMiddle:
                internalText.maxWidth = scene.width / internalText.scaleX;
                x = 0;
                y = (scene.height - internalText.textHeight * internalText.scaleY) / 2;
            case Absolute(x, y):
                internalText.maxWidth = null;
                this.x = x;
                this.y = y;
        }

        layoutDirty = false;
    }
}