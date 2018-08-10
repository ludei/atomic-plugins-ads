//
//  InMobiNativeCustomEvent.m
//  InMobiMopubSampleApp
//
//  Created by Niranjan Agrawal on 28/10/15.
//
//

#import <Foundation/Foundation.h>
#import "InMobiNativeCustomEvent.h"
#import <InMobi/IMNative.h>
#import "InMobiNativeAdAdapter.h"
#import <MoPub/MPNativeAd.h>
#import <MoPub/MPLogging.h>
#import <MoPub/MPNativeAdError.h>
#import <MoPub/MPNativeAdConstants.h>
#import <MoPub/MPNativeAdUtils.h>
#import <InMobi/IMSdk.h>

static NSString *gAppId = nil;

@interface InMobiNativeCustomEvent ()

    @property(nonatomic, strong) IMNative *inMobiAd;

@end

@implementation InMobiNativeCustomEvent
    - (void)requestAdWithCustomEventInfo: (NSDictionary *)info {
        NSString *appId = [[info objectForKey: @"placementid"] description];

        [IMSdk initWithAccountID: [info valueForKey: @"accountid"]];
        self.inMobiAd = [[IMNative alloc] initWithPlacementId: [appId longLongValue]];
        NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
        [paramsDict setObject: @"c_mopub" forKey: @"tp"];
        [paramsDict setObject: MP_SDK_VERSION forKey: @"tp-ver"];
        self.inMobiAd.extras = paramsDict; // For supply source identification
        self.inMobiAd.delegate = self;
        [self.inMobiAd load];
    }

#pragma mark - IMNativeDelegate

    - (void)nativeDidFinishLoading: (IMNative *)imnative {

        NSLog(@"%@", [imnative adContent]);

        InMobiNativeAdAdapter *adAdapter = [[InMobiNativeAdAdapter alloc] initWithInMobiNativeAd: imnative];
        MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter: adAdapter];

        NSMutableArray *imageURLs = [NSMutableArray array];

        if ([[interfaceAd.properties objectForKey: kAdIconImageKey] length]) {
            if (![MPNativeAdUtils addURLString: [interfaceAd.properties objectForKey: kAdIconImageKey] toURLArray: imageURLs]) {
                [self.delegate nativeCustomEvent: self didFailToLoadAdWithError: MPNativeAdNSErrorForInvalidImageURL()];
            }
        }

        if ([[interfaceAd.properties objectForKey: kAdMainImageKey] length]) {
            if (![MPNativeAdUtils addURLString: [interfaceAd.properties objectForKey: kAdMainImageKey] toURLArray: imageURLs]) {
                [self.delegate nativeCustomEvent: self didFailToLoadAdWithError: MPNativeAdNSErrorForInvalidImageURL()];
            }
        }

        [super precacheImagesWithURLs: imageURLs completionBlock: ^(NSArray *errors) {
            if (errors) {
                MPLogDebug(@"%@", errors);
                [self.delegate nativeCustomEvent: self didFailToLoadAdWithError: MPNativeAdNSErrorForImageDownloadFailure()];
            } else {
                [self.delegate nativeCustomEvent: self didLoadAd: interfaceAd];
            }
        }];
    }

    - (void)native: (IMNative *)native didFailToLoadWithError: (IMRequestStatus *)error {
        [self.delegate nativeCustomEvent: self didFailToLoadAdWithError: MPNativeAdNSErrorForInvalidAdServerResponse(@"InMobi ad load error")];
    }

    - (void)nativeWillPresentScreen: (IMNative *)native {
        NSLog(@"Native will present screen");
    }

    - (void)nativeDidPresentScreen: (IMNative *)native {
        NSLog(@"Native did present screen");
    }

    - (void)nativeWillDismissScreen: (IMNative *)native {
        NSLog(@"Native will dismiss screen");
    }

    - (void)nativeDidDismissScreen: (IMNative *)native {
        NSLog(@"Native did dismiss screen");
    }

    - (void)userWillLeaveApplicationFromNative: (IMNative *)native {
        NSLog(@"User will leave application from native");
    }

@end