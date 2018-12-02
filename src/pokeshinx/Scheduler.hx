package pokeshinx;


import hxd.Timer;


private typedef CallbackItem = {
    timestamp:Float,
    callback:Void->Void
};


class Scheduler {
    var callbacks:Map<Int,CallbackItem>;
    var keyCounter = 0;

    public function new() {
        callbacks = new Map();
    }

    public function delay(time:Float, callback:Void->Void) {
        runAt(Timer.lastTimeStamp + time, callback);
    }

    public function runAt(timestamp:Float, callback:Void->Void) {
        callbacks.set(
            keyCounter,
            {
                timestamp: timestamp,
                callback: callback
            }
        );

        keyCounter += 1;
    }

    public function update() {
        var timestampNow = Timer.lastTimeStamp;

        for (key in callbacks.keys()) {
            var item = callbacks.get(key);

            if (timestampNow >= item.timestamp) {
                item.callback();
                callbacks.remove(key);
            }
        }
    }
}