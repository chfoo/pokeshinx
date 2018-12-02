package pokeshinx.view;

import h2d.Object;
import h2d.Scene;
import haxe.ds.Vector;
import pokeshinx.view.object.Target;
import zigcall.SignalP;

typedef TargetClickedInfo = {
    index:Int,
    target:Target,
    x:Float,
    y:Float
};

typedef GroundClickedInfo = {
    x:Float,
    y:Float
};

class PlayView implements View {
    static inline var NUM_ROW_TARGETS = 5;
    static inline var NUM_COL_TARGETS = 5;
    static inline var TARGET_WIDTH = 256;
    static inline var TARGET_SPACING = 64;

    public var targetClicked(default, null):SignalClientP<TargetClickedInfo>;
    public var groundClicked(default, null):SignalClientP<GroundClickedInfo>;

    var _targetClicked:SignalP<TargetClickedInfo>;
    var _groundClicked:SignalP<GroundClickedInfo>;

    var scene2d:Scene;
    var targets:Vector<Target>;
    var targetContainer:Object;

    public function new(scene2d:Scene) {
        this.scene2d = scene2d;
        targetClicked = _targetClicked = new SignalP();
        groundClicked = _groundClicked = new SignalP();

        initGround();
        initTargets();
    }

    function initGround() {
    }

    function initTargets() {
        targets = new Vector(NUM_ROW_TARGETS * NUM_COL_TARGETS);
        targetContainer = new Object();

        for (row in 0...NUM_ROW_TARGETS) {
            for (col in 0...NUM_COL_TARGETS) {
                var targetIndex = row * NUM_COL_TARGETS + col;
                var target = new Target(targetContainer);
                var x = col * (TARGET_SPACING + TARGET_WIDTH);
                var y = row * (TARGET_SPACING + TARGET_WIDTH);

                targets[targetIndex] = target;
                target.x = x;
                target.y = y;

                initTargetInteractive(target, targetIndex);
            }
        }
    }

    function initTargetInteractive(target:Target, index:Int) {
        target.clicked.connect(function (info) {
            if (!target.active) {
                return;
            }

            _targetClicked.emit({
                index: index,
                target: target,
                x: info.x,
                y: info.y
            });
        });
    }

    public function showTarget(index:Int) {
        targets[index].show();
    }

    public function hideTarget(index:Int, clickedAnim:Bool = false) {
        targets[index].hide(clickedAnim);
    }

    public function update() {
        for (target in targets) {
            target.update();
        }
    }

    public function layout() {
        var pixelWidth = NUM_COL_TARGETS * TARGET_WIDTH + (NUM_COL_TARGETS - 1) * TARGET_SPACING;
        var sceneWidth = Math.min(scene2d.width, scene2d.height);

        targetContainer.setScale(sceneWidth / pixelWidth * 0.8);
        targetContainer.x = (scene2d.width - pixelWidth * targetContainer.scaleX) / 2;
        targetContainer.y = (scene2d.height - pixelWidth * targetContainer.scaleY) / 2;
    }

    public function show() {
        scene2d.addChild(targetContainer);
        layout();
    }

    public function hide():MiniPromise {
        scene2d.removeChild(targetContainer);

        return MiniPromise.asResolved();
    }

    public function reset() {
        for (target in targets) {
            target.hide();
            target.reset();
        }
    }
}