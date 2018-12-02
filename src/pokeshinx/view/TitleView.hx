package pokeshinx.view;

import h2d.Bitmap;
import h2d.Flow;
import h2d.Scene;
import h2d.Tile;
import h3d.mat.Texture;
import hxd.Res;
import pokeshinx.view.object.Button;
import pokeshinx.view.tween.RevealTweener;
import zigcall.Signal;

class TitleView implements View {
    static inline var BASE_WIDTH = 200;

    public var startClicked(default, null):SignalClient;

    var _startClicked:Signal;

    var scene2d:Scene;

    var container:Flow;
    var titleGraphic:Bitmap;
    var startButton:Button;
    var revealTweener:RevealTweener;

    public function new(scene2d:Scene) {
        this.scene2d = scene2d;

        startClicked = _startClicked = new Signal();

        container = new Flow();
        container.isVertical = true;
        container.maxWidth = BASE_WIDTH;
        container.horizontalAlign = FlowAlign.Middle;
        container.verticalSpacing = Std.int(10 * ScreenUtil.getScreenScale());

        var texture = Res.textures.texture.toTexture();

        titleGraphic = new Bitmap(Tile.fromTexture(texture).sub(0, 0, 768, 384), container);
        startButton = new Button(container);

        titleGraphic.setScale(BASE_WIDTH / titleGraphic.getBounds().width);

        startButton.text = "Start Game";
        startButton.clicked.connect(_startClicked.emit);

        revealTweener = new RevealTweener(container);
    }

    public function update() {
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

    public function show() {
        scene2d.addChild(container);
        layout();
        revealTweener.show();
    }

    public function hide():MiniPromise {
        return revealTweener.hide();
    }
}