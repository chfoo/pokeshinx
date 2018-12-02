package pokeshinx.view;

import hxd.Window;

class ScreenUtil {
    static inline var BASE_WIDTH = 320;
    static inline var BASE_HEIGHT = 240;

    public static function getScreenScale() {
        var window = Window.getInstance();

        return (window.width / BASE_WIDTH + window.height / BASE_HEIGHT) / 2;
    }
}