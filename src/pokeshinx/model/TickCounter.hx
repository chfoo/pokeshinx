package pokeshinx.model;

import hxd.Timer;

class TickCounter {
    static inline var FPS = 60;

    public var tickCount(default, null):Int = 0;

    var unusedTime:Float = 0.0;
    var timePerFrame:Float = 1 / FPS;
    var resetRequested = false;


    public function new() {
    }

    public function update(callback:Void->Void, ?elapsedTime:Float) {
        elapsedTime = elapsedTime != null ? elapsedTime : Timer.elapsedTime;

        unusedTime += elapsedTime;

        // By default, hxd.Timer will drop time if it's too great so we don't
        // have to worry about large batches of callback execution
        while (unusedTime >= timePerFrame) {
            callback();

            unusedTime -= timePerFrame;

            if (!resetRequested) {
                tickCount += 1;
            } else {
                tickCount = 0;
                resetRequested = false;
            }
        }
    }

    public function reset() {
        resetRequested = true;
    }
}