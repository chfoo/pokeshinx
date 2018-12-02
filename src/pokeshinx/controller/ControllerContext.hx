package pokeshinx.controller;

class ControllerContext {
    public var nextRequested(default, null):Bool = false;
    public var nextTag(default, null):ControllerTag;

    public function new() {
    }

    public function activateNext(tag:ControllerTag) {
        nextRequested = true;
        nextTag = tag;
    }

    public function resetNext() {
        nextRequested = false;
    }
}