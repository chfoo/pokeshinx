package pokeshinx.view.tween;

import haxe.ds.Option;
import h2d.Object;

using tweenxcore.Tools;

enum RevealTweenerState {
    Stopped;
    Showing;
    Hiding;
}

class RevealTweener {
    public var state(default, null):RevealTweenerState = Stopped;
    public var visible(default, null):Bool = false;

    var object:Object;
    var tweenRate:TweenRate;
    var hidePromise:Option<MiniPromise>;
    var animTranslation:Bool;

    public function new(object:Object, animTranslation:Bool = false) {
        this.object = object;
        this.animTranslation = animTranslation;
        tweenRate = new TweenRate();

        object.visible = false;
    }

    public function update() {
        switch state {
            case Stopped:
                return;
            case Showing:
                updateShowing();
            case Hiding:
                updateHiding();
        }
    }

    function updateShowing() {
        object.visible = true;
        visible = true;

        // Fade in and slide up from bottom
        var rate = tweenRate.get();
        object.alpha = rate.cubicInOut().lerp(0, 1);

        if (animTranslation) {
            object.y = rate.cubicOut().lerp(5 * ScreenUtil.getScreenScale(), 0);
        }

        if (object.alpha == 1) {
            state = Stopped;
        }
    }

    function updateHiding() {
        // Fade out and slide up
        var rate = tweenRate.get();
        object.alpha = rate.cubicInOut().lerp(1, 0);

        if (animTranslation) {
            object.y = rate.cubicIn().lerp(0, -10 * ScreenUtil.getScreenScale());
        }

        if (object.alpha == 0) {
            object.visible = false;
            visible = false;
            state = Stopped;

            switch hidePromise {
                case Some(promise):
                    promise.resolve();
                case None:
                    throw "Missing promise";
            }
        }
    }

    public function show() {
        state = Showing;
        tweenRate.duration = 0.3;
        tweenRate.restart();
    }

    public function hide():MiniPromise {
        state = Hiding;
        tweenRate.duration = 0.3;
        tweenRate.restart();

        var promise = new MiniPromise();
        hidePromise = Some(promise);
        return promise;
    }
}