(function() {

    var demo = {
        isHidden: false,
        position: Cocoon.Ad.BannerLayout.BOTTOM_CENTER,
        x : 0,
        y : 0,
        width : 0,
        height : 0,
        ctx:null,
        params: {
            banner : {
                status : ""
            },
            interstitial : {
                status : "",
                sub_status: ""
            }
        }
    };

    var banner;
    var interstitial;

    demo.createBanner = function(){

        banner = Cocoon.Ad.createBanner();

        banner.on("load", function(){
            console.log("Banner loaded " + banner.width, banner.height);
            demo.params.banner.status = "Banner loaded";
        });

        banner.on("fail", function(){
            console.log("Banner failed to load");
            demo.params.banner.status = "Banner failed";
        });

        banner.on("show", function(){
            console.log("Banner shown a modal content");
            demo.params.banner.status = "Banner show modal content";
        });

        banner.on("dismiss", function(){
            console.log("Banner dismissed the modal content");
            demo.params.banner.status = "Banner dismissed modal";
        });
    };

    demo.createInterstitial = function(){

        interstitial = Cocoon.Ad.createInterstitial();

        interstitial.on("load", function(){
            console.log("Interstitial loaded");
            demo.params.interstitial.status = "Interstitial loaded,";
            demo.params.interstitial.sub_status = "press SHOW FULL SCREEN to watch the ad.";
        });
        interstitial.on("fail", function(){
            console.log("Interstitial failed");
            demo.params.interstitial.status = "Interstitial failed,";
            demo.params.interstitial.sub_status = "";
        });
        interstitial.on("show", function(){
            console.log("Interstitial shown");
            demo.params.interstitial.status = "Interstitial shown";
            demo.params.interstitial.sub_status = "";
        });
        interstitial.on("dismiss", function(){
            console.log("Interstitial dismissed");
            demo.params.interstitial.status = "Interstitial dismissed,";
            demo.params.interstitial.sub_status = "press CACHE AD to download another ad.";
        });
    };

    demo.init = function(){

        var canvas= document.createElement("canvas");
        var dpr = window.devicePixelRatio;
        var w= 960;
        var h = 640;
        canvas.width= w;
        canvas.height= h;

        var scale = Math.min(window.innerHeight/h,window.innerWidth/w);

        canvas.style.position = "absolute";
        canvas.style.width = (w * scale) + "px";
        canvas.style.height = (h * scale) + "px";
        canvas.style.left = (window.innerWidth * 0.5 - w * scale * 0.5) + "px";
        canvas.style.top = (window.innerHeight * 0.5 - h * scale * 0.5) + "px";

        document.body.appendChild(canvas);

        ctx= canvas.getContext("2d");
        demo.ctx = ctx;
        var image= new Image();
        image.onload=function() {
            ctx.drawImage( image,0,0 );

            var touchOrClick = function(x, y)
            {
                var bound = canvas.getBoundingClientRect();
                x = (x - bound.left) / scale;
                y = (y - bound.top) / scale;

                if(x >= 540 && x <= 885 && y >= 200 && y <= 255){
                    banner.show();
                }
                else if (x >= 540 && x <= 885 && y >= 273 && y <= 327){
                    banner.hide();
                }
                else if (x >= 540 && x <= 885 && y >= 350 && y <= 403){
                    if (demo.position == Cocoon.Ad.BannerLayout.BOTTOM_CENTER) {
                        demo.position = Cocoon.Ad.BannerLayout.TOP_CENTER;
                    }
                    else {
                        demo.position = Cocoon.Ad.BannerLayout.BOTTOM_CENTER;
                    }
                    banner.setLayout(demo.position);
                }
                else if (x >= 540 && x <= 885 && y >= 430 && y <= 482){
                    console.log("Downloading banner...");
                    demo.params.banner.status = "Downloading banner...";
                    banner.load();
                }
                else if (x >= 77 && x <= 418 && y >= 200 && y <= 254){
                    interstitial.show();
                }
                else if (x >= 77 && x <= 418 && y >= 272 && y <= 325){
                    demo.params.interstitial.status = "Downloading interstitial...";
                    demo.params.interstitial.sub_status = "";
                    interstitial.load();
                }else{
                    console.log("No button selected: ", x | 0 , y | 0);
                }

            }

            canvas.addEventListener(
                "touchstart",
                function( touches ) {
                    var that = touches.targetTouches[0];

                    var x= that.pageX;
                    var y= that.pageY;
                    touchOrClick(x, y);

                },
                false
            );
            setInterval(function(){

                ctx.clearRect(0,0,window.innerWidth,window.innerHeight);

                ctx.drawImage(image,0,0);

                ctx.fillStyle = '#888';
                ctx.font = '22px Arial';
                ctx.textBaseline = 'bottom';
                ctx.fillText('Full screen status: '+demo.params.interstitial.status, 77, 510);
                ctx.fillText('Banner status: '+demo.params.banner.status, 540, 510);
                ctx.fillText(demo.params.interstitial.sub_status, 77, 530);

            },1000 / 60);

        };
        image.src = "img/background.png";
    };


    function init() {

        //Configuration If AdMob service plugins are installed
        /*Cocoon.Ad.configure({
             ios: {
                  banner:"ca-app-pub-7686972479101507/8873903476",
                  interstitial:"ca-app-pub-7686972479101507/8873903476",
             },
             android: {
                  banner:"ca-app-pub-7686972479101507/4443703872",
                  interstitial:"ca-app-pub-7686972479101507/4443703872"
             }
        });*/

        //Configuration If MoPub service plugins are installed
        Cocoon.Ad.configure({
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

        // Create banner ads through the CocoonJS Ads extension
        demo.createBanner();
        // Create interstitial ads through the CocoonJS Ads extension
        demo.createInterstitial();
        demo.init();
    }

    if (window.cordova) {
        document.addEventListener("deviceready", init);
    }
    else {
        window.onload = init;
    }


})();
