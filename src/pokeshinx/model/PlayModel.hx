package pokeshinx.model;

import zigcall.Signal;
import haxe.ds.Vector;
import seedyrng.Random;

using tweenxcore.Tools;

enum PlayState {
    Ready;
    Countdown;
    Running;
    Ending;
    GameOver;
}

class PlayModel {
    static inline var FPS = 60;
    static inline var NUM_TARGETS = 25;

    #if debug_short_game
    static inline var MAX_DIFFICULTY_FRAME = 60 * 10;
    #else
    static inline var MAX_DIFFICULTY_FRAME = 60 * 60;
    #end
    static inline var MAX_DIFFICULTY_TARGETS = 10;

    public var targets(default, null):Vector<TargetModel>;
    var targetVisibilityCounters:Vector<Int>;
    var visibleCount = 0;

    public var stateChanged(default, null):SignalClient;

    var _stateChanged:Signal;

    var tickCounter:TickCounter;
    var rng:Random;
    public var state(default, null):PlayState = Ready;
    public var score(default, null):ScoreModel;

    public var timeRemaining(default, null):Float = 0;

    public function new() {
        targets = new Vector(NUM_TARGETS);
        targetVisibilityCounters = new Vector(NUM_TARGETS);
        stateChanged = _stateChanged = new Signal();
        tickCounter = new TickCounter();
        rng = new Random();
        score = new ScoreModel();

        for (index in 0...NUM_TARGETS) {
            var target = new TargetModel();
            targets[index] = target;
            target.clicked.connect(clickedCallback.bind(index));

            targetVisibilityCounters[index] = 0;
        }
    }

    public function update() {
        tickCounter.update(updateTick);
    }

    function updateTick() {
        switch state {
            case Ready:
                changeState(Countdown);
            case Countdown:
                updateCountdown();
            case Running:
                updateRunning();
            case Ending:
                updateEnding();
            case GameOver:
                // pass
        }
    }

    function changeState(newState:PlayState) {
        tickCounter.reset();
        state = newState;
        _stateChanged.emit();

    }

    function updateCountdown() {
        if (tickCounter.tickCount == 60 * 3) {
            changeState(Running);
        }
    }

    function updateRunning() {
        timeRemaining = (MAX_DIFFICULTY_FRAME - tickCounter.tickCount) / FPS;

        var difficultyRate = Math.min(1.0, tickCounter.tickCount / MAX_DIFFICULTY_FRAME);
        var spawnChance = Std.int(difficultyRate.lerp(50, 1));
        var maxTargets = Std.int(difficultyRate.lerp(1, MAX_DIFFICULTY_TARGETS));

        if (rng.randomInt(0, spawnChance) == 0 && visibleCount < maxTargets) {
            var index = rng.randomInt(0, NUM_TARGETS - 1);
            var target = targets[index];

            if (!target.visible) {
                target.show();
                visibleCount += 1;

                var frameDuration = Std.int(difficultyRate.lerp(60 * 5, 60 * 1));
                targetVisibilityCounters[index] = frameDuration;
            }
        }

        for (index in 0...NUM_TARGETS) {
            var visibilityCounter = targetVisibilityCounters[index];

            if (visibilityCounter > 0) {
                if (visibilityCounter == 1 && targets[index].visible) {
                    targets[index].hide();
                    visibleCount -= 1;
                    score.fled += 1;
                }

                targetVisibilityCounters[index] -= 1;
            }
        }

        if (tickCounter.tickCount == MAX_DIFFICULTY_FRAME) {
            changeState(Ending);

            for (target in targets) {
                target.hide();
            }
        }
    }

    function updateEnding() {
        if (tickCounter.tickCount == 60 * 2) {
            changeState(GameOver);
        }
    }

    function clickedCallback(index:Int) {
        var target = targets[index];

        if (target.visible) {
            target.hide();
            visibleCount -= 1;
            score.clicked += 1;
        }
    }

    public function clickGround() {
        score.missed += 1;
    }

    public function reset() {
        score.reset();
        visibleCount = 0;

        for (target in targets) {
            target.reset();
        }
        changeState(Ready);
    }
}
