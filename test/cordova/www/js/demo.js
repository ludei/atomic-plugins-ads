"use strict";

(function(){
    var bannerStatus;
    var interstitialStatus;

    var banner;
    var interstitial;
    var demoPosition;

    var backgroundTexture;
    var button1Texture;
    var button2Texture;

    var adService;

    var container;

    function createBanner() {

        banner = adService.createBanner();

        banner.on("load", function(){
            console.log("Banner loaded " + banner.width, banner.height);
            bannerStatus.text = "Banner loaded";
        });

        banner.on("fail", function(){
            console.log("Banner failed to load");
            bannerStatus.text = "Banner failed";
        });

        banner.on("show", function(){
            console.log("Banner shown a modal content");
            bannerStatus.text = "Banner show modal content";
        });

        banner.on("dismiss", function(){
            console.log("Banner dismissed the modal content");
            bannerStatus.text = "Banner dismissed modal";
        });
    }

    function createInterstitial() {

        interstitial = adService.createInterstitial();

        interstitial.on("load", function(){
            console.log("Interstitial loaded");
            interstitialStatus.text = "Interstitial loaded";
        });
        interstitial.on("fail", function(){
            console.log("Interstitial failed");
            interstitialStatus.text = "Interstitial failed";
        });
        interstitial.on("show", function(){
            console.log("Interstitial shown");
            interstitialStatus.text = "Interstitial shown";
        });
        interstitial.on("dismiss", function(){
            console.log("Interstitial dismissed");
            interstitialStatus.text = "Interstitial dismissed";
        });
    }

    function showProviderSelector() {

        var btnTestAdmob = createButton("Test AdMob", function(){
            if (!window.Cocoon || !Cocoon.Ad || !Cocoon.Ad.AdMob) {
                alert('Cocoon AdMob plugin not installed');
                return;
            }
            adService = Cocoon.Ad.AdMob;
            adService.configure({
                 ios: {
                      banner:"ca-app-pub-7686972479101507/8873903476",
                      interstitial:"ca-app-pub-7686972479101507/8873903476",
                 },
                 android: {
                      banner:"ca-app-pub-7686972479101507/4443703872",
                      interstitial:"ca-app-pub-7686972479101507/4443703872"
                 }
            });
            showControls();

        });
        var btnTestMoPub = createButton("Test MoPub", function(){

            if (!window.Cocoon || !Cocoon.Ad || !Cocoon.Ad.MoPub) {
                alert('Cocoon MoPub plugin not installed');
                return;
            }
            adService = Cocoon.Ad.MoPub;
            adService.configure({
                 ios: {
                      banner:"agltb3B1Yi1pbmNyDQsSBFNpdGUY5dDoEww",
                      bannerIpad:"agltb3B1Yi1pbmNyDQsSBFNpdGUYk8vlEww", //optional
                      interstitial:"agltb3B1Yi1pbmNyDQsSBFNpdGUYjf30Eww",
                      interstitialIpad:"agltb3B1Yi1pbmNyDQsSBFNpdGUYjf30Eww", //optional
                 },
                 android: {
                      banner:"68949c5d9de74b79bb79aa29c203ca02",
                      interstitial:"74a813ae7a404881bf17eb8d1b0aa943"
                 }
            });
            showControls();
        });

        var btnTestHeyzap = createButton("Test Heyzap", function(){

            if (!window.Cocoon || !Cocoon.Ad || !Cocoon.Ad.Heyzap) {
                alert('Cocoon Heyzap plugin not installed');
                return;
            }
            adService = Cocoon.Ad.Heyzap;
            adService.configure({publisherId:"719d975e5c491118535b3413a8b20d52"});
            //adService.showDebug(); //Native View: Very interesting for testing purposes!
            showControls();
        });


        btnTestAdmob.position.set(0, -50);
        container.addChild(btnTestAdmob);

        btnTestMoPub.position.set(0, 50);
        container.addChild(btnTestMoPub);

        btnTestHeyzap.position.set(0, 150);
        container.addChild(btnTestHeyzap);
    }

    function showControls() {
        container.removeChildren();
        if (adService) {
            createBanner();
            createInterstitial();
        }

         //Add buttons
        var btnShowBanner = createButton("Show banner", function(){
            banner.show();
        });
        var btnHideBanner = createButton("Hide banner", function(){
            banner.hide();
        });
        var btnChangePosition = createButton("Change position", function(){
            if (demoPosition == Cocoon.Ad.BannerLayout.BOTTOM_CENTER) {
                demoPosition = Cocoon.Ad.BannerLayout.TOP_CENTER;
            }
            else {
                demoPosition = Cocoon.Ad.BannerLayout.BOTTOM_CENTER;
            }
            banner.setLayout(demoPosition);
        });
        var btnLoadBanner = createButton("Load banner", function(){
            bannerStatus.text = "Loading...";
            banner.load();
        });

        btnShowBanner.position.set(150, -150);
        container.addChild(btnShowBanner);

        btnHideBanner.position.set(150, -50);
        container.addChild(btnHideBanner);

        btnChangePosition.position.set(150, 50);
        container.addChild(btnChangePosition);

        btnLoadBanner.position.set(150, 150);
        container.addChild(btnLoadBanner);

        var btnShowInterstitial = createButton("Show interstial", function(){
            interstitial.show();
        });

        var btnLoadInterstitial = createButton("Load interstial", function(){
            interstitialStatus.text = "Loading...";
            interstitial.load();
        });

        btnShowInterstitial.position.set(-150, -50);
        container.addChild(btnShowInterstitial);

        btnLoadInterstitial.position.set(-150, 50);
        container.addChild(btnLoadInterstitial);

        bannerStatus = createText("Created", 30, "#000");
        interstitialStatus = createText("Created", 30, "#000");

        bannerStatus.position.set(150, 250);
        container.addChild(bannerStatus);

        interstitialStatus.position.set(-150, 250);
        container.addChild(interstitialStatus);
    }

    function initDemo(){

        var renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight, null, true);
        document.body.appendChild(renderer.view);

        var W = 800;
        var H = 600;

        //load resources
        backgroundTexture = PIXI.Texture.fromImage('images/background.jpg', true);
        button1Texture = PIXI.Texture.fromImage('images/button1.png', true);
        button2Texture = PIXI.Texture.fromImage('images/button2.png', true);

        var stage = new PIXI.Container();
        stage.interactive = true;

        //Add background
        var background = new PIXI.Sprite(backgroundTexture);
        background.width = renderer.width;
        background.height = renderer.height;
        stage.addChild(background);

        var scale = Math.min(renderer.width/W, renderer.height/H);
        container = new PIXI.Container();
        container.scale.set(scale, scale);
        container.position.set(renderer.width/2, renderer.height/2);
        stage.addChild(container);

        showProviderSelector();
        // start animating
        animate();
        function animate() {
            requestAnimationFrame(animate);
            renderer.render(stage);
        }
    }

    function createButton(text, callback) {

        var button = new PIXI.Sprite(button1Texture);
        button.anchor.set(0.5, 0.5);
        button.interactive = true;
        button.addChild(createText(text));

        button.mousedown = button.touchstart = function(){
            this.texture = button2Texture;
            callback();
        };

        button.mouseup = button.touchend = function(){
            this.texture = button1Texture;
        };

        return button;
    }

    function createText(text, size, fill){
        size = size || 25;
        fill = fill || "#ffffff";
        var txt = new PIXI.Text(text, {
            fill: fill,
            font: size + "px Arial"
        });
        txt.anchor.set(0.5, 0.5);

        return txt;
    }

    if (window.cordova) {
        document.addEventListener("deviceready", initDemo);
    }
    else {
        window.onload = initDemo;
    }


})();







