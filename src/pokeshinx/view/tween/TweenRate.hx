package pokeshinx.view.tween;

import hxd.Timer;
import haxe.ds.Option;

using tweenxcore.Tools;

class TweenRate {
    public var duration:Float;
    public var running(default, null) = false;
    var startTime:Option<Float> = None;

    public function new(duration:Float = 1) {
        this.duration = duration;
    }

    public function start() {
        if (!running) {
            running = true;

            if (startTime == None) {
                startTime = Some(Timer.lastTimeStamp);
            }
        }
    }

    public function restart() {
        running = true;
        startTime = Some(Timer.lastTimeStamp);
    }

    public function stop() {
        running = false;
    }

    public function get():Float {
        var calcStartTime;
        var calcStopTime = Timer.lastTimeStamp;

        switch startTime {
            case None:
                calcStartTime = Timer.lastTimeStamp;
            case Some(value):
                calcStartTime = value;
        }

        var rate = ((calcStopTime - calcStartTime) / duration).clamp();

        if (rate == 1) {
            running = false;
        }

        return rate;
    }
}