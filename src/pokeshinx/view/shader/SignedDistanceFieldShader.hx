package pokeshinx.view.shader;

import h3d.Vector;
import hxsl.Shader;

// https://github.com/libgdx/libgdx/wiki/Distance-field-fonts
class SignedDistanceFieldShader extends Shader {
    static var SRC = {
        @:import h3d.shader.Base2d;

        @param var smoothing:Float; // (x / 16.0)
        @param var textColor:Vec4;
        @param var outlineColor:Vec4;
        @param var outlineDistance:Float;

        function fragment() {
            var distance = textureColor.a;
            var outlineFactor = smoothstep(0.5 - smoothing, 0.5 + smoothing, distance);
            var newColor = mix(outlineColor, textColor, outlineFactor);
            var newAlpha = smoothstep(outlineDistance - smoothing, outlineDistance + smoothing, distance);
            var objectAlpha = pixelColor.a / textureColor.a; // Reversing operation to get object.alpha
            output.color = vec4(newColor.rgb, newColor.a * newAlpha * objectAlpha);
        }
    }

    public function new(?textColor:Vector, smoothing:Float = 0.0625, ?outlineColor:Vector, outlineFactor:Float = 0) {
        super();

        this.textColor = textColor != null ? textColor : Vector.fromColor(0xff000000);
        this.smoothing = smoothing;
        this.outlineColor = outlineColor != null ? outlineColor : Vector.fromColor(0xffffffff);
        this.outlineDistance = (1 - outlineFactor) * 0.5;
    }
}