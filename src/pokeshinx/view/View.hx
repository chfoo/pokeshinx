package pokeshinx.view;

interface View {
    public function update():Void;
    public function layout():Void;
    public function show():Void;
    public function hide():MiniPromise;
}