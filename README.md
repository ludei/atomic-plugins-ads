#Atomic Plugins for Ads

This repo contains Ad APIs designed using the [Atomic Plugins](#about-atomic-plugins) paradigm. Monetize your app and take advantage of all the features provided: elegant API, flexible monetization solution that works across multiple platforms, full support for banners and full screen ads (interstitials), single API for different Ad Providers and more. The API is already available in many languagues and we plan to add more in the future:

  * [Objective-C API for pure iOS/Mac apps](#ios-api)
  * [Java API for pure Android apps](#android-api)
  * [JavaScript API for Cordova or Cocoon based Apps](#javascript-api)
  * [C++ API for C++ based apps and games](#c-api)

Currently there are 2 Ad providers implemented but new ones can be easily added:

* MoPub with optional adapters
* AdMob

You can contribute and help to create more awesome plugins.

##About Atomic Plugins

Atomic Plugins provide an elegant and minimalist API and are designed with portability in mind from the beginning. Framework dependencies are avoided by design so the plugins can run on any platform and can be integrated with any app framework or game engine. 

#Provided APIs

* [iOS API](#ios-api)
  * [API Reference](#api-reference)
  * [Introduction](#introduction)
  * [Setup your project](#setup-your-project)
  * [Example](#example)
* [Android API](#android-api)
  * [API Reference](#api-reference-1)
  * [Introduction](#introduction-1)
  * [Setup your project](#setup-your-project-1)
  * [Example](#example-1)
* [JavaScript API](#javascript-api)
  * [API Reference](#api-reference-2)
  * [Introduction](#introduction-2)
  * [Setup your project](#setup-your-project-2)
  * [Example](#example-2)
* [C++ API](#c-api)
  * [API Reference](#api-reference-3)
  * [Introduction](#introduction-3)
  * [Setup your project](#setup-your-project-3)
  * [Example](#example-3)
  
##iOS API:

###API Reference

See [API Documentation](http://ludei.github.io/atomic-plugins-ads/dist/doc/ios/html/annotated.html)

See [`LDAdService.h`](src/atomic/ios/common/LDAdService.h) [`LDAdBanner.h`](src/atomic/ios/common/LDAdBanner.h) [`LDAdInterstitial.h`](src/atomic/ios/common/LDAdInterstitial.h) header files for a complete overview of the capabilities of the API

See [`AdTest`](test/ios) for a complete project that tests all the features provided in the API.

###Introduction 

LDAdService class provides an easy to use Ads API that can be used with different Ad providers with built-in support for multiple banners and interstitials.

###Setup your project

You can use CocoaPods to include the desired Ad providers:

    pod 'LDAdServiceMoPub' //for MoPub
    pod 'LDAdServiceAdMob' //for AdMob

If you are using MoPub you optionally can include the following adapters:

  [`Chartboost adapter`](/src/cordova/ios/mopub/chartboost/src/deps)
  [`AdMob adapter`](/src/cordova/ios/mopub/admob/src/deps)
  [`Millennial Media adapter`](/src/cordova/ios/mopub/millennial/src/deps)


###Example

```objc
//Instantiathe the desired ad provider
LDAdService * service = [[LDAdServiceMoPub alloc] init]; //MoPub
LDAdService * service = [[LDAdServiceAdMob alloc] init]; //AdMob

//Configure default banner and interstitial adunits
service.settings.banner = @"....";
service.settings.bannerIpad = @"...."; //optional (use if you want an specific AdUnit for iPad)
service.settings.interstitial = @"....";
service.settings.interstitialIpad = @"...."; //optional (use if you want an specific AdUnit for iPad)

//Create banner: optional AdUnit and AdSize arguments
LDAdBanner * banner = [service createBanner];
banner.delegate = self; //optional banner delegate
[banner loadAd];

//Layout the view as you want
[self.view addSubview: banner.view]; 
banner.view.center = self.view.center;

//Create interstitial: optional AdUnit argument
LDAdInterstitial * interstitial  = [service createInterstitial];
interstitial.delegate = self; //optional delegate
[interstitial loadAd];

//Show an interstitial
[interstitial showFromViewController:self animated:YES];
```

##Android API:

###API Reference

See [API Documentation](http://ludei.github.io/atomic-plugins-ads/dist/doc/android/html/annotated.html)

See [`AdTest`](test/android) for a complete project that tests all the features provided in the API.

###Introduction 

AdService interface provides an easy to use Ads API that can be used with different Ad providers with built-in support for multiple banners and interstitials.

### Setup your project

Releases are deployed to Maven Central. You only have to add the desired dependencies in your build.gradle:

    dependencies {
        compile 'com.ludei.ads.admob:1.0.0' //AdMob Ad Provider

        compile 'com.ludei.ads.mopub:1.0.0' //MoPub Ad Provider
        compile 'com.ludei.ads.mopub.adcolony:1.0.0' //Optional MoPub AdColony adapter
        compile 'com.ludei.ads.mopub.admob:1.0.0' //Optional MoPub AdMob adapter
        compile 'com.ludei.ads.mopub.chartboost:1.0.0' //Optional MoPub Chartboost adapter
        compile 'com.ludei.ads.mopub.inmobi:1.0.0' //Optional MoPub InMobi adapter
        compile 'com.ludei.ads.mopub.greystripe:1.0.0' //Optional MoPub Greystriper adapter
        compile 'com.ludei.ads.mopub.millennialmedia:1.0.0' //Optional MoPub MillennialMedia adapter
    }


###Example

```java
//Instantiathe the desired ad provider
AdService service = new AdServiceMoPub(); //MoPub
AdService service = new AdServiceAdMob(); //AdMob

//Configure default banner and interstitial adunits
service.configure(bannerAdUnit, interstitialAdUnit);

//Create banner: optional AdUnit and AdSize arguments
AdBanner banner = service.createBanner(this);
banner.setListener(this); //Optional banner listener
banner.loadAd();

//Layout the banner as you want
viewGroup.addView(banner.getView());

//Create interstitial: optional AdUnit argument
AdInterstitial interstitial = service.createInterstitial(this);
interstitial.setListener(this); //Optional interstitial listener
interstitial.loadAd();

//Show an interstitial
interstitial.show();
```

##JavaScript API:

###API Reference

See [API Documentation](http://ludei.github.io/cocoon-common/dist/doc/js/Cocoon.Ad.html)

For a complete project that tests all the features provided in the API run the following command:

    gulp create-cordova

###Introduction 

Cocoon.Ad class provides an easy to use Ads API that can be used with different Ad providers with built-in support for multiple banners and interstitials.

###Setup your project

Releases are deployed to Cordova Plugin Registry. You only have to install the desired plugins using Cordova CLI, CocoonJS CLI or Ludei's Cocoon Cloud Server.

    cordova plugin add cocoon-plugin-ads-ios-admob; //AdMob plugin for iOS
    cordova plugin add cocoon-plugin-ads-ios-mopub; //MoPub plugin for iOS
    cordova plugin add cocoon-plugin-ads-android-admob; //AdMob plugin for Android
    cordova plugin add cocoon-plugin-ads-android-mopub; //MoPub plugin for Android

    //Optional MoPub adapters for iOS and Android
    cordova plugin add cocoon-plugin-ads-ios-mopub-adcolony;
    cordova plugin add cocoon-plugin-ads-ios-mopub-admob;
    cordova plugin add cocoon-plugin-ads-ios-mopub-chartboost;
    cordova plugin add cocoon-plugin-ads-ios-mopub-millennial;
    cordova plugin add cocoon-plugin-ads-android-mopub-adcolony;
    cordova plugin add cocoon-plugin-ads-android-mopub-admob;
    cordova plugin add cocoon-plugin-ads-android-mopub-chartboost;
    cordova plugin add cocoon-plugin-ads-android-mopub-greystripe;
    cordova plugin add cocoon-plugin-ads-android-mopub-inmobi;
    cordova plugin add cocoon-plugin-ads-android-mopub-millennial;

The following JavaScript file is included automatically:

[`cocoon_ads.js`](src/js/cocoon_ads.js)

###Example

```javascript

//get the installed plugin instance
var service = Cocoon.Ad;

//multiplatform default configuration
service.configure({
    ios: {
         banner:"agltb3B1Yi1pbmNyDQsSBFNpdGUxxxxxxx",
         bannerIpad:"agltb3B1Yi1pbmNyDQsSBFNpdGUzzzzz", //optional
         interstitial:"agltb3B1Yi1pbmNyDQsSBFNpdGUyyyyyyy",
         interstitialIpad:"agltb3B1Yi1pbmNyDQsSBFNpdGUtttttt", //optional
    },
    android: {
         banner:"agltb3B1Yi1pbmNyDQsSBFNpdGUwwwwww",
         interstitial:"agltb3B1Yi1pbmNyDQsSBFNpdGUhhhhhh"
    }
});

//Create banner: optional AdUnit and BannerSize arguments
var banner = service.createBanner();

//Configure banner listeners
banner.on("load", function(){
   console.log("Banner loaded " + banner.width, banner.height);
   banner.show();
});

banner.on("fail", function(){
   console.log("Banner failed to load");
});

banner.on("show", function(){
   console.log("Banner shown a modal content");
});

banner.on("dismiss", function(){
   console.log("Banner dismissed the modal content");
});

banner.on("click", function(){
   console.log("Banner clicked");
});

 //load banner
banner.load();

//Show or hide banner
banner.show();
banner.hide();

//Automatic banner layout
banner.setLayout(Cocoon.Ad.BannerLayout.TOP_CENTER);

//Custom banner layout
banner.setLayout(Cocoon.Ad.BannerLayout.CUSTOM);
banner.setPosition(x,y);

//Create interstitial: optional AdUnit argument
var interstitial = service.createInterstitial();

//Configure interstitial listeners
interstitial.on("load", function(){
    console.log("Interstitial loaded");
});
interstitial.on("fail", function(){
    console.log("Interstitial failed");
});
interstitial.on("show", function(){
    console.log("Interstitial shown");
});
interstitial.on("dismiss", function(){
    console.log("Interstitial dismissed");
});

interstitial.on("click", function(){
    console.log("Interstitial clicked");
});

//load interstitial
interstitial.load();

//show interstitial
interstitial.show();
```

##C++ API:

###API Reference

See [API Documentation](http://ludei.github.io/atomic-plugins-ads/dist/doc/cpp/html/annotated.html)

See [`AdService.h`](src/cpp/AdService.h) [`AdBanner.h`](src/cpp/AdBanner.h) [`AdInterstitial.h`](src/cpp/AdInterstitial.h) header files for a complete overview of the capabilities of the API

See [`AdTest`](test/cpp) for a complete project (cocos2dx game) that integrates the C++ Ad API.

###Introduction 

AdService class provides an easy to use Ads API that can be used with different Ad providers with built-in support for multiple banners and interstitials.

###Setup your project

You can download prebuilt headers and static libraries from [Releases page](https://github.com/ludei/atomic-plugins-ads/releases)

These static libraries provide the bindings between C++ and the native platform (iOS, Android, WP, etc). You might need to add some platform dependent libraries in your project (some jar files or gradle dependecies for example). See [`AdTest`](test/cpp) for an already setup C++ multiplatform project.

####Special setup required for Android

There isn't a portable and realiable way to get the current Activity and life cycle events on Android and we don't want to depend on specific game engine utility APIs. C++ and Java bridge is implemmented using the [SafeJNI](https://github.com/MortimerGoro/SafeJNI) utility. Atomic Plugins take advantage of this class and use it also as a generic Activity and Life Cycle Event notification provider. See the following code to set up the activity for atomic plugins and to notify Android life cycle events.

```java
@Override
public void onCreate(Bundle savedInstanceState) {
    //set the activity for atomic plugins and load safejni.so
    SafeJNI.INSTANCE.setActivity(this); 
    super.onCreate(savedInstanceState);
}
```

Optionally (but recommended) you can use setJavaToNativeDispatcher to configure the thread in which async callbacks should be dispatched. By default callbacks are dispatched in the UI Thread. For example the following dispatcher is used in the Cocos2dx game engine test project.

```java
@Override
public Cocos2dxGLSurfaceView onCreateView() {
    final Cocos2dxGLSurfaceView surfaceView = super.onCreateView();
    SafeJNI.INSTANCE.setJavaToNativeDispatcher(new SafeJNI.JavaToNativeDispatcher() {
        @Override
        public void dispatch(Runnable runnable) {
            surfaceView.queueEvent(runnable);
        }
    });
    return surfaceView;
}
```

###Example

```objc
//Easy to use static method to instantiate a new service
//You can pass a specific AdProvider if you have many providers linked in your app and you want to choose one of them at runtime
AdService * service = AdService::create();

//Configure default banner and interstitial adunits
AdServiceSettings settings;
settings.banner = "ca-app-pub-7686972479101507/xxxxxxxx";
settings.interstitial = "ca-app-pub-7686972479101507/xxxxxx";
service->configure(settings);

//Create banner: optional AdUnit and AdSize arguments
AdBanner * banner = service->createBanner();
banner->setListener(this); //Optional banner listener
banner->loadAd();

//Automatic layout
banner->setLayout(AdBannerLayout::TOP_CENTER);

//Custom layout
banner->setLayout(AdBannerLayout::CUSTOM);
banner->setPosition(x, y);

//Create interstitial: optional AdUnit argument
AdInterstitial * interstitial = service->createInterstitial();
interstitial->setListener(this); //Optional interstitial listener
interstitial->loadAd();

//Show an interstitial
interstitial->show();

//delete the ads or the service when you are done. You can wrap them into a Smart Pointer if you want.
delete banner;
delete interstitial;
delete service; 
```

#License

Mozilla Public License, version 2.0

Copyright (c) 2015 Ludei 

See [`MPL 2.0 License`](LICENSE)
