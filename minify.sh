#!/bin/dash

closure-compiler --js out/js/app.js --js_output_file out/js/app.min.js --language_in ECMASCRIPT5
mkdir -p out/html_publish/
cp out/js/app.js out/js/app.min.js out/html_publish/
cp app.html out/html_publish/
sed -i 's|out/js/app.js|app.min.js|g' out/html_publish/app.html

echo "Done"
