package pokeshinx.model;

class ScoreModel {
    public var clicked:Int = 0;
    public var fled:Int = 0;
    public var missed:Int = 0;

    public function new() {

    }

    public function reset() {
        clicked = fled = missed = 0;
    }

    public function getTotal():Int {
        return clicked * 5 - fled * 1 - missed * 1;
    }
}