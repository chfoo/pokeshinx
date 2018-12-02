package pokeshinx;

class MiniPromise {
    public var isResolved(default, null):Bool = false;

    static var resolvedCache:MiniPromise;

    public function new() {
    }

    public static function asResolved():MiniPromise {
        if (resolvedCache == null) {
            resolvedCache = new MiniPromise();
            resolvedCache.resolve();
        }

        return resolvedCache;
    }

    public static function aggregate(promises:Array<MiniPromise>):MiniPromise {
        return new AggregateMiniPromise(promises);
    }

    public function resolve() {
        isResolved = true;
    }
}

private class AggregateMiniPromise extends MiniPromise {
    var promises:Array<MiniPromise>;

    public function new(promises:Array<MiniPromise>) {
        super();

        this.promises = promises;

        checkResolved();
    }

    override public function resolve() {
        checkResolved();
    }

    function checkResolved() {
        for (promise in promises) {
            if (!promise.isResolved) {
                return;
            }
        }

        isResolved = true;
    }
}