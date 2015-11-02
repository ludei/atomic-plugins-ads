var gulp = require('gulp'); 
var path = require('path');
var jshint = require('gulp-jshint');
var fs = require('fs');
var shell = require('gulp-shell');
var del = require('del');
var cordova = require('cordova-lib').cordova.raw;
var jsdoc = require('gulp-jsdoc');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');

var testMopub = true; //Disable to test admob
var mopubAndroidAdapters = ['adcolony', 'admob', 'chartboost', 'greystripe', 'inmobi', 'millennialmedia'];
var mopubIOSAdapters = ['admob', 'chartboost', 'millennial'];


gulp.task('clean', function(finish){ 
    del(['**/build', '**/obj', 'test/cordova/AdTest'], function (err, deletedFiles) {
        console.log('Files deleted:', deletedFiles.join(', '));
        finish();
    });
});
/*
 * Copy cordova plugin dependenties
 * Cordova plugins don't support symlinks so we have to copy some shared source files and libraries
 */
gulp.task('deps-cordova', function() {
    //ios mopub
    gulp.src('src/atomic/ios/common/**/')
        .pipe(gulp.dest('src/cordova/ios/common/src/deps'));
    gulp.src(['src/atomic/ios/mopub/*.h', 'src/atomic/ios/mopub/*.m'])
        .pipe(gulp.dest('src/cordova/ios/mopub/base/src/deps'));
  
    //ios admob
    gulp.src(['src/atomic/ios/admob/*.h', 'src/atomic/ios/admob/*.m'])
        .pipe(gulp.dest('src/cordova/ios/admob/base/src/deps'));

    //ios chartboost
    gulp.src(['src/atomic/ios/chartboost/*.h', 'src/atomic/ios/chartboost/*.m'])
        .pipe(gulp.dest('src/cordova/ios/chartboost/src/deps'));

    //android chartboost
    gulp.src(['src/atomic/android/chartboost/src/**/','src/atomic/android/chartboost/libs/**/'])
        .pipe(gulp.dest('src/cordova/android/chartboost/src/deps'));

    //Android mopub
    gulp.src('src/atomic/android/common/src/**/')
        .pipe(gulp.dest('src/cordova/android/common/src/deps'));
    gulp.src('src/atomic/android/mopub/src/**/')
        .pipe(gulp.dest('src/cordova/android/mopub/base/src/deps'));
    gulp.src('src/atomic/android/mopub/external/mopub/**/')
        .pipe(gulp.dest('src/cordova/android/mopub/base/src/deps'));   

    //Android mopub adapters
    for (var i = 0; i < mopubAndroidAdapters.length; ++i) {
        gulp.src('src/atomic/android/mopub/external/adapters/' + mopubAndroidAdapters[i] + '/libs/**/')
            .pipe(gulp.dest('src/cordova/android/mopub/' + mopubAndroidAdapters[i] + '/src/deps'));
    }  

    //Android admob
    return gulp.src('src/atomic/android/admob/src/**/')
        .pipe(gulp.dest('src/cordova/android/admob/base/src/deps'));

});

gulp.task('build-android', shell.task([
  'cd test/android/AdTest && ./gradlew assembleDebug'
]));

gulp.task('build-ios', shell.task([
  'cd test/ios/AdTest && xcodebuild'
]));

gulp.task('build-js', function () {
    return gulp.src(['src/js/cocoon_ads.js','src/js/cocoon_ads_admob.js','src/js/cocoon_ads_mopub.js', 'src/js/cocoon_ads_chartboost.js'])
            .pipe(jshint())
            .pipe(jshint.reporter())
            .pipe(concat('cocoon_ads.js')) 
            .pipe(uglify())
            .pipe(gulp.dest('src/cordova/common/www'));
});

gulp.task('create-cordova', ['deps-cordova', 'build-js'], function(finish) {

	var name = "AdTest";
	var buildDir = path.join('test','cordova', name);
	var srcDir = path.join('test','cordova', "www");
	var appId = "com.ideateca.jscocoon";
	var cfg = {lib: {www: {uri: srcDir, url: srcDir, link: false}}};
	del([buildDir], function() {
		cordova.create(buildDir, appId, name, cfg)    
    	.then(function() {

            gulp.src('test/cordova/config.xml')
                .pipe(gulp.dest('test/cordova/AdTest'));
        	process.chdir(buildDir);
    	})
    	.then(function() {
            console.log("Prepare cordova platforms");
        	return cordova.platform('add', ['android', 'ios']);
    	})
    	.then(function() {

            console.log("Add cordova plugins");

            var plugins = ["src/cordova/common",
                           "src/cordova/android/common",
                           "src/cordova/ios/common"]

            if (testMopub) {
                plugins.push("src/cordova/android/mopub/base");
                for (var i = 0; i < mopubAndroidAdapters.length; ++i) {
                    plugins.push("src/cordova/android/mopub/" + mopubAndroidAdapters[i]);
                }
                plugins.push("src/cordova/ios/mopub/base");
                for (var i = 0; i < mopubIOSAdapters.length; ++i) {
                    plugins.push("src/cordova/ios/mopub/" + mopubIOSAdapters[i]);
                }
            } 
            else {
                plugins.push("src/cordova/android/admob",
                           "src/cordova/ios/admob/base");
            }

            console.log("Plugins: " + JSON.stringify(plugins));
        	return cordova.plugins('add', plugins);
   		 })
        .then(function() {
            finish();
        })
        .fail(function(message) {
            console.error("Error: " + message);
            finish();
        })
	});
});

gulp.task('build-cordova', ['create-cordova'], function(finish) {

    cordova.build(['ios', 'android'])
    .then(function (){
        finish();
    })
    .fail(function(message){
        console.error(message);
        finish();
    });

});

gulp.task('build-cpp-ios', shell.task([
  'cd test/cpp/proj.ios && xcodebuild -target BuildDist'
]));

gulp.task('build-cpp-android', shell.task([
  'cd test/cpp/proj.android && ./gradlew assembleDebug' 
]));

gulp.task("build-cpp", ["build-cpp-ios", "build-cpp-android"]);

gulp.task("build", ["build-ios", "build-android", "build-cordova", "build-cpp"]);

gulp.task('doc-js', ["build-js"], function() {

    var config = require('./doc_template/js/jsdoc.conf.json');

    var infos = {
        plugins: config.plugins
    }

    var templates = config.templates;
    templates.path = 'doc_template/js';

    return gulp.src("src/js/*.js")
      .pipe(jsdoc.parser(infos))
      .pipe(jsdoc.generator('dist/doc/js', templates));

});

gulp.task('doc-android', shell.task([
  'cd ./doc_template/android && doxygen config'
]));

gulp.task('doc-ios', shell.task([
  'cd ./doc_template/ios && doxygen config'
]));

gulp.task('doc-cpp', shell.task([
  'cd ./doc_template/cpp && doxygen config'
]));

gulp.task('doc', ["doc-ios", "doc-android", "doc-js", "doc-cpp"]);

gulp.task('default', ['build', 'doc']);
