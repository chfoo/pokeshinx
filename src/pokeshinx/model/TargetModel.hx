package pokeshinx.model;

import zigcall.Signal;

class TargetModel {
    public var clicked(default, null):SignalClient;
    public var showRequested(default, null):SignalClient;
    public var hideRequested(default, null):SignalClient;
    public var visible(default, null):Bool = false;
    public var hasClicked(default, null):Bool = false;

    var _clicked:Signal;
    var _showRequested:Signal;
    var _hideRequested:Signal;

    public function new() {
        clicked = _clicked = new Signal();
        showRequested = _showRequested = new Signal();
        hideRequested = _hideRequested = new Signal();
    }

    public function click() {
        hasClicked = true;
        _clicked.emit();
    }

    public function hide() {
        if (visible) {
            visible = false;
            _hideRequested.emit();
            hasClicked = false;
        }
    }

    public function show() {
        if (!visible) {
            visible = true;
            _showRequested.emit();
        }
    }

    public function reset() {
        visible = false;
    }
}
