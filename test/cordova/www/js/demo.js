"use strict";

(function () {
    var bannerStatus;
    var interstitialStatus;
    var rewardedVideoStatus;

    var banner;
    var interstitial;
    var rewardedVideo;

    var demoPosition;

    var backgroundTexture;
    var button1Texture;
    var button2Texture;

    var adService;

    var container;

    function createBanner() {

        banner = adService.createBanner();

        banner.on("load", function() {
            console.log("Banner loaded " + banner.width, banner.height);
            bannerStatus.text = "Banner loaded";
        });

        banner.on("fail", function() {
            console.log("Banner failed to load");
            bannerStatus.text = "Banner failed";
        });

        banner.on("show", function() {
            console.log("Banner shown a modal content");
            bannerStatus.text = "Banner show modal content";
        });

        banner.on("dismiss", function() {
            console.log("Banner dismissed the modal content");
            bannerStatus.text = "Banner dismissed modal";
        });
    }

    function createInterstitial() {

        interstitial = adService.createInterstitial();

        interstitial.on("load", function() {
            console.log("Interstitial loaded");
            interstitialStatus.text = "Interstitial loaded";
        });
        interstitial.on("fail", function() {
            console.log("Interstitial failed");
            interstitialStatus.text = "Interstitial failed";
        });
        interstitial.on("show", function() {
            console.log("Interstitial shown");
            interstitialStatus.text = "Interstitial shown";
        });
        interstitial.on("dismiss", function() {
            console.log("Interstitial dismissed");
            interstitialStatus.text = "Interstitial dismissed";
        });
    }

    function createRewardedVideo() {

        rewardedVideo = adService.createRewardedVideo();

        rewardedVideo.on("load", function() {
            console.log("Rewarded video loaded");
            rewardedVideoStatus.text = "Rewarded video loaded";
        });
        rewardedVideo.on("fail", function() {
            console.log("Rewarded video failed");
            rewardedVideoStatus.text = "Rewarded video failed";
        });
        rewardedVideo.on("show", function() {
            console.log("Rewarded video shown");
            rewardedVideoStatus.text = "Rewarded video shown";
        });
        rewardedVideo.on("dismiss", function() {
            console.log("Rewarded video dismissed");
            rewardedVideoStatus.text = "Rewarded video dismissed";
        });
        rewardedVideo.on("reward", function() {
            console.log("Rewarded video completed");
            rewardedVideoStatus.text = "Rewarded video completed";
        });
    }

    function showProviderSelector() {

        var btnTestAdmob = createButton("Test AdMob", function() {
            if (!window.Cocoon || !Cocoon.Ad || !Cocoon.Ad.AdMob) {
                alert('Cocoon AdMob plugin not installed');
                return;
            }
            adService = Cocoon.Ad.AdMob;
            adService.configure({
                android: {
                    appId: "ca-app-pub-7686972479101507~2048640671",
                    banner: "ca-app-pub-7686972479101507/9530149874",
                    interstitial: "ca-app-pub-7686972479101507/2006883074",
                    rewardedVideo: "ca-app-pub-7686972479101507/2741189626",
                    personalizedAdsConsent: false,
                },
                ios: {
                    appId: "ca-app-pub-7686972479101507~4862506278",
                    banner: "ca-app-pub-7686972479101507/5518752672",
                    interstitial: "ca-app-pub-7686972479101507/7135086675",
                    rewardedVideo: "ca-app-pub-7686972479101507/6843838743",
                    personalizedAdsConsent: false,
                }
                // android: {
                //     appId: "ca-app-pub-3940256099942544~3347511713",
                //     banner: "ca-app-pub-3940256099942544/6300978111",
                //     interstitial: "ca-app-pub-3940256099942544/1033173712",
                //     rewardedVideo: "ca-app-pub-3940256099942544/5224354917",
                //     personalizedAdsConsent: false,
                // },
                // ios: {
                //     appId: "ca-app-pub-3940256099942544~1458002511",
                //     banner: "-app-pub-3940256099942544/2934735716",
                //     interstitial: "ca-app-pub-3940256099942544/4411468910",
                //     rewardedVideo: "ca-app-pub-3940256099942544/1712485313",
                //     personalizedAdsConsent: false,
                // }
            });
            showControls();

        });
        var btnTestChartboost = createButton("Test Chartboost", function() {
            if (!window.Cocoon || !Cocoon.Ad || !Cocoon.Ad.Chartboost) {
                alert('Cocoon Chartboost plugin not installed');
                return;
            }
            adService = Cocoon.Ad.Chartboost;
            adService.configure({
                android: {
                    appId: "50ae12d715ba47c00d01000c",
                    appSignature: "95fb313c08717042903819d76f65d64d2347ac44",
                    personalizedAdsConsent: false,
                },
                ios: {
                    appId: "4ed254a3cb5015e47c000000",
                    appSignature: "91858cc162b56414ca47e63ce7a1b20105c70e65",
                    personalizedAdsConsent: false,
                }
            });
            showControls();

        });
        var btnTestMoPub = createButton("Test MoPub", function() {

            if (!window.Cocoon || !Cocoon.Ad || !Cocoon.Ad.MoPub) {
                alert('Cocoon MoPub plugin not installed');
                return;
            }
            adService = Cocoon.Ad.MoPub;
            adService.configure({
                android: {
                    banner: "68949c5d9de74b79bb79aa29c203ca02",
                    interstitial: "74a813ae7a404881bf17eb8d1b0aa943"
                },
                ios: {
                    banner: "agltb3B1Yi1pbmNyDQsSBFNpdGUY5dDoEww",
                    bannerIpad: "agltb3B1Yi1pbmNyDQsSBFNpdGUYk8vlEww", //optional
                    interstitial: "agltb3B1Yi1pbmNyDQsSBFNpdGUYjf30Eww",
                    interstitialIpad: "agltb3B1Yi1pbmNyDQsSBFNpdGUYjf30Eww", //optional
                }
            });
            showControls();
        });

        btnTestAdmob.position.set(0, -100);
        container.addChild(btnTestAdmob);

        btnTestChartboost.position.set(0, 0);
        container.addChild(btnTestChartboost);

        btnTestMoPub.position.set(0, 100);
        container.addChild(btnTestMoPub);
    }

    function showControls() {
        container.removeChildren();
        if (adService) {
            createBanner();
            createInterstitial();
            createRewardedVideo();
        }

        //Add buttons
        var btnShowBanner = createButton("Show banner", function() {
            banner.show();
        });
        var btnHideBanner = createButton("Hide banner", function() {
            banner.hide();
        });
        var btnChangePosition = createButton("Change position", function() {
            if (demoPosition === Cocoon.Ad.BannerLayout.BOTTOM_CENTER) {
                demoPosition = Cocoon.Ad.BannerLayout.TOP_CENTER;
            } else {
                demoPosition = Cocoon.Ad.BannerLayout.BOTTOM_CENTER;
            }
            banner.setLayout(demoPosition);
        });
        var btnLoadBanner = createButton("Load banner", function() {
            bannerStatus.text = "Loading...";
            banner.load();
        });

        bannerStatus = createText("Created");

        btnShowBanner.position.set(-250, -150);
        container.addChild(btnShowBanner);

        btnHideBanner.position.set(-250, -50);
        container.addChild(btnHideBanner);

        btnChangePosition.position.set(-250, 50);
        container.addChild(btnChangePosition);

        btnLoadBanner.position.set(-250, 150);
        container.addChild(btnLoadBanner);

        bannerStatus.position.set(-250, 250);
        container.addChild(bannerStatus);

        var btnShowInterstitial = createButton("Show interstitial", function() {
            interstitial.show();
        });

        var btnLoadInterstitial = createButton("Load interstitial", function() {
            interstitialStatus.text = "Loading...";
            interstitial.load();
        });

        interstitialStatus = createText("Created");

        btnShowInterstitial.position.set(0, -50);
        container.addChild(btnShowInterstitial);

        btnLoadInterstitial.position.set(0, 50);
        container.addChild(btnLoadInterstitial);

        interstitialStatus.position.set(0, 250);
        container.addChild(interstitialStatus);

        var btnShowRewardedVideo = createButton("Show rewarded video", function() {
            rewardedVideo.show();
        }, 20);

        var btnLoadRewardedVideo = createButton("Load rewarded video", function() {
            rewardedVideoStatus.text = "Loading...";
            rewardedVideo.load();
        }, 20);

        rewardedVideoStatus = createText("Created");

        btnShowRewardedVideo.position.set(250, -50);
        container.addChild(btnShowRewardedVideo);

        btnLoadRewardedVideo.position.set(250, 50);
        container.addChild(btnLoadRewardedVideo);

        rewardedVideoStatus.position.set(250, 250);
        container.addChild(rewardedVideoStatus);
    }

    function initDemo() {

        var renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight);
        document.body.appendChild(renderer.view);

        var W = 800;
        var H = 600;

        //load resources
        backgroundTexture = PIXI.Texture.fromImage('./images/background.jpg');
        button1Texture = PIXI.Texture.fromImage('./images/button1.png');
        button2Texture = PIXI.Texture.fromImage('./images/button2.png');

        var stage = new PIXI.Container();
        stage.interactive = true;

        //Add background
        var background = new PIXI.Sprite(backgroundTexture);
        background.width = renderer.width;
        background.height = renderer.height;
        stage.addChild(background);

        var scale = Math.min(renderer.width / W, renderer.height / H);
        container = new PIXI.Container();
        container.scale.set(scale, scale);
        container.position.set(renderer.width / 2, renderer.height / 2);
        stage.addChild(container);

        showProviderSelector();
        // start animating
        animate();

        function animate() {
            requestAnimationFrame(animate);
            renderer.render(stage);
        }
    }

    function createButton(text, callback, size) {

        var button = new PIXI.Sprite(button1Texture);
        button.anchor.set(0.5, 0.5);
        button.interactive = true;
        button.addChild(createText(text, size));

        button.mousedown = button.touchstart = function() {
            button.texture = button2Texture;
            callback();
        };

        button.mouseup = button.touchend = function() {
            button.texture = button1Texture;
        };

        return button;
    }

    function createText(text, size, fill) {
        size = size || 25;
        fill = fill || "#000000";
        var txt = new PIXI.Text(text, {
            fontFamily: "Arial",
            fontSize: size,
            fill: fill,
            align: "center"
        });
        txt.anchor.set(0.5, 0.5);

        return txt;
    }

    if (window.cordova) {
        document.addEventListener("deviceready", initDemo);
    } else {
        window.onload = initDemo;
    }
})();







