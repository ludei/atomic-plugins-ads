//
// AppLovin <--> MoPub Network Adaptors
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use the -fobjc-arc flag in the XCode build phases tab.
#endif

#import "AppLovinInterstitialCustomEvent.h"

@implementation AppLovinInterstitialCustomEvent

    static NSString *const kALMoPubMediationErrorDomain = @"com.applovin.sdk.mediation.mopub.errorDomain";

    - (void)requestInterstitialWithCustomEventInfo: (NSDictionary *)info {
        ALAdService *adService = [[ALSdk shared] adService];
        [adService loadNextAd: [ALAdSize sizeInterstitial] andNotify: self];
    }

    - (void)showInterstitialFromRootViewController: (UIViewController *)rootViewController {
        if (self.loadedAd) {
            UIWindow *window = rootViewController.view.window;

            UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];

            CGRect localFrame;

            if (currentOrientation == UIDeviceOrientationPortrait || currentOrientation == UIDeviceOrientationPortraitUpsideDown) {
                localFrame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
            } else // Landscape
            {
                localFrame = CGRectMake(0, 0, window.frame.size.width - [UIApplication sharedApplication].statusBarFrame.size.width, window.frame.size.height);
            }

            self.interstitialAd = [[ALInterstitialAd alloc] initWithSdk: [ALSdk shared]];
            self.interstitialAd.adDisplayDelegate = self;
            self.interstitialAd.frame = localFrame;
            [self.interstitialAd showOver: window andRender: self.loadedAd];
        } else {
            NSError *error = [NSError errorWithDomain: kALMoPubMediationErrorDomain
                                                 code: -1
                                             userInfo: @{
                                                     NSLocalizedFailureReasonErrorKey: @"Adaptor requested to display an interstitial before one was loaded."
                                             }
            ];

            [self.delegate interstitialCustomEvent: self didFailToLoadAdWithError: error];
        }
    }

#pragma mark - ALAdLoadDelegate methods

    - (void)adService: (ALAdService *)adService didLoadAd: (ALAd *)ad {
        self.loadedAd = ad;
        [self.delegate interstitialCustomEvent: self didLoadAd: ad];
    }

    - (void)adService: (ALAdService *)adService didFailToLoadAdWithError: (int)code {
        NSError *error = [NSError errorWithDomain: kALMoPubMediationErrorDomain
                                             code: code
                                         userInfo: nil];

        [self.delegate interstitialCustomEvent: self didFailToLoadAdWithError: error];
    }

#pragma mark - ALAdDisplayDelegate methods

    - (void)ad: (ALAd *)ad wasHiddenIn: (UIView *)view {
        [self.delegate interstitialCustomEventWillDisappear: self];
        [self.delegate interstitialCustomEventDidDisappear: self];
    }

    - (void)ad: (ALAd *)ad wasDisplayedIn: (UIView *)view {
        [self.delegate interstitialCustomEventWillAppear: self];
        [self.delegate interstitialCustomEventDidAppear: self];
    }

    - (void)ad: (ALAd *)ad wasClickedIn: (UIView *)view {
        [self.delegate interstitialCustomEventDidReceiveTapEvent: self];
        [self.delegate interstitialCustomEventWillLeaveApplication: self];
    }

    - (void)dealloc {
        self.loadedAd = nil;
        self.interstitialAd = nil;
        self.interstitialAd.adDisplayDelegate = nil;
    }

@end
