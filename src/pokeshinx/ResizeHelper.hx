package pokeshinx;

class ResizeHelper {
    public static function init() {
        #if js
        // The library uses a timer to check if the canvas has been resized but
        // to avoid infinite loops, it sets the CSS size. So we clear the
        // CSS size to have it relayout.
        var canvas = js.Browser.window.document.getElementById("webgl");
        js.Browser.window.addEventListener("resize", function (event) {
            canvas.style.width = "";
            canvas.style.height = "";
        });
        #end
    }
}