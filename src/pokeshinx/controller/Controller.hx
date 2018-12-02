package pokeshinx.controller;

interface Controller {
    public function update():Void;
    public function layout():Void;
    public function activate():Void;
    public function deactivate():MiniPromise;
}