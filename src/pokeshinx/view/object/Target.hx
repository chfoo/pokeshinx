package pokeshinx.view.object;

import h2d.Mask;
import h2d.Bitmap;
import h2d.col.Point;
import h2d.Interactive;
import h2d.Object;
import h2d.Tile;
import hxd.Cursor;
import hxd.Event;
import hxd.Res;
import pokeshinx.view.tween.TweenRate;
import zigcall.SignalP;

using tweenxcore.Tools;

typedef TargetClickedInfo = {
    x:Float,
    y:Float
};

private enum TweenType {
    Show;
    Hide;
    HideClicked;
}

class Target extends Object {
    public static inline var PIXEL_WIDTH = 256;
    static inline var HIDE_DURATION = 0.3;
    static inline var SHOW_DURATION = 0.8;

    public var active(default, null) = false;
    public var clicked(default, null):SignalClientP<TargetClickedInfo>;

    var _clicked:SignalP<TargetClickedInfo>;

    var tweenRate:TweenRate;
    var tweenType:TweenType = Show;
    var targetOriginY:Float;

    var targetGraphic:Bitmap;
    var mask:Mask;
    var backgroundGraphic:Bitmap;
    var interactive:Interactive;

    public function new(?parent:Object) {
        super(parent);

        clicked = _clicked = new SignalP();

        tweenRate = new TweenRate();

        initBackground();
        initGraphic();
        initInteractive();
    }

    function initBackground() {
        var tile = Res.textures.texture.toTile();

        backgroundGraphic = new Bitmap(tile.sub(768, 768, PIXEL_WIDTH, PIXEL_WIDTH), this);
    }

    function initGraphic() {
        mask = new Mask(PIXEL_WIDTH, PIXEL_WIDTH, this);

        var tile = Res.textures.texture.toTile();

        targetGraphic = new Bitmap(tile.sub(0, 768, PIXEL_WIDTH, PIXEL_WIDTH), mask);

        targetGraphic.setScale(0.8);
        targetGraphic.x = (PIXEL_WIDTH - targetGraphic.getBounds().width ) / 2;
        targetGraphic.y = (PIXEL_WIDTH - targetGraphic.getBounds().height ) / 2;
        targetOriginY = targetGraphic.y;
    }

    function initInteractive() {
        interactive = new Interactive(PIXEL_WIDTH, PIXEL_WIDTH, targetGraphic);

        interactive.onPush = function (event:Event) {
            var globalPoint = interactive.localToGlobal(new Point(event.relX, event.relY));
            _clicked.emit({
                x: globalPoint.x,
                y: globalPoint.y
            });
        };
        interactive.cursor = Cursor.Default;
    }

    public function update() {
        #if debug_show_all
        targetGraphic.alpha = 1;
        return;
        #end

        if (!tweenRate.running) {
            return;
        }
        var rate = tweenRate.get();

        switch tweenType {
            case Hide:
                targetGraphic.alpha = rate.cubicInOut().lerp(1, 0);
                targetGraphic.y = targetOriginY + rate.cubicInOut().lerp(0, PIXEL_WIDTH);
            case HideClicked:
                targetGraphic.alpha = rate.cubicInOut().lerp(1, 0);
                targetGraphic.y = targetOriginY + rate.backIn().lerp(0, PIXEL_WIDTH);
            case Show:
                targetGraphic.alpha = rate.cubicInOut().lerp(0, 1);
                targetGraphic.y = targetOriginY + rate.cubicInOut().lerp(PIXEL_WIDTH, 0);

        }
    }

    public function show() {
        if (!active) {
            active = true;
            tweenRate.duration = SHOW_DURATION;
            tweenRate.restart();
            tweenType = Show;
        }
    }

    public function hide(clickedAnim:Bool = false) {
        if (active) {
            active = false;
            tweenRate.duration = HIDE_DURATION;
            tweenRate.restart();

            if (clickedAnim) {
                tweenType = HideClicked;
            } else {
                tweenType = Hide;
            }
        }
    }

    public function reset() {
        tweenRate.stop();
        active = false;
        targetGraphic.alpha = 0;
    }
}