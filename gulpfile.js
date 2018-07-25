const gulp = require("gulp");
const path = require("path");
const jshint = require("gulp-jshint");
const shell = require("gulp-shell");
const del = require("del");
const cordova = require("cordova-lib").cordova.raw;
const jsdoc = require("gulp-jsdoc");
const uglify = require("gulp-uglify");
const concat = require("gulp-concat");

const testMopub = true; //Disable to test admob
const mopubAndroidAdapters = ["adcolony", "admob", "chartboost", "greystripe", "inmobi", "millennialmedia"];
const mopubIOSAdapters = ["admob", "chartboost", "millennial"];


gulp.task("clean", function (finish) {
    del(["**/build", "**/obj", "test/cordova/AdTest"], function (err, deletedFiles) {
        console.log("Files deleted:", deletedFiles.join(", "));
        finish();
    });
});

/*
 * Copy cordova plugin dependencies
 * Cordova plugins don"t support symlinks so we have to copy some shared source files and libraries
 */
gulp.task("deps-cordova", function () {
    // Android common
    gulp.src("src/atomic/android/common/src/**/")
        .pipe(gulp.dest("src/cordova/android/common/src/deps"));

    // Android AdColony
    gulp.src("src/atomic/android/mopub/external/adapters/adcolony/libs/**/")
        .pipe(gulp.dest("src/cordova/android/adcolony/src/deps"));

    // Android AdMob
    gulp.src("src/atomic/android/admob/src/**/")
        .pipe(gulp.dest("src/cordova/android/admob/base/src/deps"));

    // Android Chartboost
    gulp.src(["src/atomic/android/chartboost/src/**/", "src/atomic/android/chartboost/libs/**/"])
        .pipe(gulp.dest("src/cordova/android/chartboost/src/deps"));

    // Android Heyzap
    gulp.src(["src/atomic/android/heyzap/src/**/", "src/atomic/android/heyzap/libs/**/"])
        .pipe(gulp.dest("src/cordova/android/heyzap/base/src/deps"));

    // Android InMobi
    gulp.src("src/atomic/android/mopub/external/adapters/inmobi/libs/**/")
        .pipe(gulp.dest("src/cordova/android/mopub/inmobi/src/deps"));

    // Android MillennialMedia
    gulp.src("src/atomic/android/mopub/external/adapters/millennialmedia/libs/**/")
        .pipe(gulp.dest("src/cordova/android/mopub/millennialmedia/src/deps"));

    // Android MoPub
    gulp.src("src/atomic/android/mopub/src/**/")
        .pipe(gulp.dest("src/cordova/android/mopub/base/src/deps"));

    // Android MoPub adapters
    for (let i = 0; i < mopubAndroidAdapters.length; ++i) {
        gulp.src("src/atomic/android/mopub/external/adapters/" + mopubAndroidAdapters[i] + "/src/*.java")
            .pipe(gulp.dest("src/cordova/android/mopub/" + mopubAndroidAdapters[i] + "/src"));
    }

    // iOS common
    gulp.src(["src/atomic/ios/common/*.h", "src/atomic/ios/common/*.m"])
        .pipe(gulp.dest("src/cordova/ios/common/src/deps"));

    // iOS AdMob
    gulp.src(["src/atomic/ios/admob/*.h", "src/atomic/ios/admob/*.m"])
        .pipe(gulp.dest("src/cordova/ios/admob/base/src/deps"));

    // iOS Chartboost
    gulp.src(["src/atomic/ios/chartboost/*.h", "src/atomic/ios/chartboost/*.m"])
        .pipe(gulp.dest("src/cordova/ios/chartboost/src/deps"));

    // iOS Heyzap
    gulp.src(["src/atomic/ios/heyzap/*.h", "src/atomic/ios/heyzap/*.m"])
        .pipe(gulp.dest("src/cordova/ios/heyzap/base/src/deps"));

    // iOS MoPub
    return gulp.src(["src/atomic/ios/mopub/*.h", "src/atomic/ios/mopub/*.m"])
        .pipe(gulp.dest("src/cordova/ios/mopub/base/src/deps"));
});

gulp.task("build-android", shell.task([
    "cd test/android/AdTest && ./gradlew assembleDebug"
]));

gulp.task("build-ios", shell.task([
    "cd test/ios/AdTest && xcodebuild"
]));

gulp.task("build-js", function () {
    return gulp.src(["src/js/cocoon_ads.js", "src/js/cocoon_ads_admob.js", "src/js/cocoon_ads_mopub.js", "src/js/cocoon_ads_chartboost.js", "src/js/cocoon_ads_heyzap.js"])
        .pipe(jshint())
        .pipe(jshint.reporter())
        .pipe(concat("cocoon_ads.js"))
        .pipe(uglify())
        .pipe(gulp.dest("src/cordova/common/www"));
});

gulp.task("create-cordova", ["deps-cordova", "build-js"], function (finish) {

    const name = "AdTest";
    const buildDir = path.join("test", "cordova", name);
    const srcDir = path.join("test", "cordova", "www");
    const appId = "com.ideateca.jscocoon";
    const cfg = {lib: {www: {uri: srcDir, url: srcDir, link: false}}};
    del([buildDir], function () {
        cordova.create(buildDir, appId, name, cfg)
            .then(function () {

                gulp.src("test/cordova/config.xml")
                    .pipe(gulp.dest("test/cordova/AdTest"));
                process.chdir(buildDir);
            })
            .then(function () {
                console.log("Prepare cordova platforms");
                return cordova.platform("add", ["android", "ios"]);
            })
            .then(function () {

                console.log("Add cordova plugins");

                const plugins = ["src/cordova/common",
                    "src/cordova/android/common",
                    "src/cordova/ios/common"];

                if (testMopub) {
                    plugins.push("src/cordova/android/mopub/base");
                    for (let i = 0; i < mopubAndroidAdapters.length; ++i) {
                        plugins.push("src/cordova/android/mopub/" + mopubAndroidAdapters[i]);
                    }
                    plugins.push("src/cordova/ios/mopub/base");
                    for (let i = 0; i < mopubIOSAdapters.length; ++i) {
                        plugins.push("src/cordova/ios/mopub/" + mopubIOSAdapters[i]);
                    }
                }
                else {
                    plugins.push("src/cordova/android/admob",
                        "src/cordova/ios/admob/base");
                }

                console.log("Plugins: " + JSON.stringify(plugins));
                return cordova.plugins("add", plugins);
            })
            .then(function () {
                finish();
            })
            .fail(function (message) {
                console.error("Error: " + message);
                finish();
            })
    });
});

gulp.task("build-cordova", ["create-cordova"], function (finish) {

    cordova.build(["ios", "android"])
        .then(function () {
            finish();
        })
        .fail(function (message) {
            console.error(message);
            finish();
        });

});

gulp.task("build-cpp-ios", shell.task([
    "cd test/cpp/proj.ios && xcodebuild -target BuildDist"
]));

gulp.task("build-cpp-android", shell.task([
    "cd test/cpp/proj.android && ./gradlew assembleDebug"
]));

gulp.task("build-cpp", ["build-cpp-ios", "build-cpp-android"]);

gulp.task("build", ["build-ios", "build-android", "build-cordova", "build-cpp"]);

gulp.task("doc-js", ["build-js"], function () {

    const config = require("./doc_template/js/jsdoc.conf.json");

    const infos = {
        plugins: config.plugins
    };

    const templates = config.templates;
    templates.path = "doc_template/js";

    return gulp.src("src/js/*.js")
        .pipe(jsdoc.parser(infos))
        .pipe(jsdoc.generator("dist/doc/js", templates));

});

gulp.task("doc-android", shell.task([
    "cd ./doc_template/android && doxygen config"
]));

gulp.task("doc-ios", shell.task([
    "cd ./doc_template/ios && doxygen config"
]));

gulp.task("doc-cpp", shell.task([
    "cd ./doc_template/cpp && doxygen config"
]));

gulp.task("doc", ["doc-ios", "doc-android", "doc-js", "doc-cpp"]);

gulp.task("default", ["build", "doc"]);
