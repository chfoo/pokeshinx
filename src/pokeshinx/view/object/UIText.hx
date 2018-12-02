package pokeshinx.view.object;

import h2d.Font;
import h2d.Object;
import h2d.Text;
import h3d.Vector;
import hxd.Res;
import pokeshinx.view.shader.SignedDistanceFieldShader;

class UIText extends Object {
    static inline var BASE_FONT_SIZE = 12;
    static var fontCache:Font;

    public var text(get, set):String;
    public var maxWidth(get, set):Null<Float>;
    public var lineHeight(get, never):Int;
    public var textAlign(get, set):Align;
    public var textWidth(get, never):Int;
    public var textHeight(get, never):Int;

    var internalText:Text;

    public function new(?parent:Object, ?textColor:Vector,
            smoothing:Float = 0.03125, ?outlineColor:Vector,
            outlineFactor:Float = 0.2) {
        super(parent);

        textColor = textColor != null ? textColor : Vector.fromColor(0xffffffff);
        outlineColor = outlineColor != null ? outlineColor : Vector.fromColor(0xff000000);

        if (fontCache == null) {
            fontCache = Res.fonts.SourceSansPro_Bold_latin.toFont();

            // resizeTo() gives really poor results with glyphs misaligned at
            // small sizes
        }

        internalText = new Text(fontCache, this);
        internalText.setScale(BASE_FONT_SIZE / fontCache.lineHeight);

        var shader = new SignedDistanceFieldShader(
            textColor, smoothing, outlineColor, outlineFactor
        );

        internalText.addShader(shader);
    }

    function get_lineHeight():Int {
        return Std.int(fontCache.lineHeight * internalText.scaleX);
    }

    function get_text():String {
        return internalText.text;
    }

    function set_text(value:String):String {
        return internalText.text = value;
    }

    function get_maxWidth():Null<Float> {
        return internalText.maxWidth * internalText.scaleX;
    }

    function set_maxWidth(value:Null<Float>):Null<Float> {
        return internalText.maxWidth = value / internalText.scaleX;
    }

    function get_textAlign():Align {
        return internalText.textAlign;
    }

    function set_textAlign(value:Align):Align {
        return internalText.textAlign = value;
    }

    function get_textWidth():Int {
        return Std.int(internalText.textWidth * internalText.scaleX);
    }

    function get_textHeight():Int {
        return Std.int(internalText.textHeight * internalText.scaleX);
    }
}
