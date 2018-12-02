package pokeshinx.view.object;

import h3d.Vector;
import h2d.Interactive;
import h2d.Object;
import h2d.ScaleGrid;
import hxd.Event;
import hxd.Res;
import zigcall.Signal;

class Button extends Object {
    static inline var TEXTURE_BORDER_WIDTH = 16;
    static inline var BORDER_WIDTH = 3;

    public var clicked(default, null):SignalClient;

    var _clicked:Signal;

    public var text(get, set):String;

    var background:ScaleGrid;
    var textObject:UIText;
    var interactive:Interactive;

    public function new(?parent:Object) {
        super(parent);

        clicked = _clicked = new Signal();

        initBackground();
        initText();
        initInteractive();
    }

    function get_text():String {
        return textObject.text;
    }

    function set_text(value:String):String {
        var layoutDirty = textObject.text != value;

        textObject.text = value;

        if (layoutDirty) {
            layout();
        }

        return value;
    }

    function initBackground() {
        var tile = Res.textures.texture.toTile().sub(0, 512, 128, 128);

        background = new ScaleGrid(tile, TEXTURE_BORDER_WIDTH, TEXTURE_BORDER_WIDTH, this);
        background.setScale(BORDER_WIDTH / TEXTURE_BORDER_WIDTH);
    }

    function initText() {
        textObject = new UIText(this, Vector.fromColor(0xff444444), null, null, 0);

        textObject.x = BORDER_WIDTH;
        textObject.y = BORDER_WIDTH;
    }

    function initInteractive() {
        interactive = new Interactive(0, 0, this);

        interactive.onClick = function (event:Event) {
            _clicked.emit();
        };
    }

    function layout() {
        background.width = Std.int((textObject.textWidth + BORDER_WIDTH * 2) / background.scaleX);
        background.height = Std.int((textObject.textHeight + BORDER_WIDTH * 2) / background.scaleY);

        var bounds = getBounds();
        interactive.width = bounds.width;
        interactive.height = bounds.height;

        onContentChanged();
    }
}