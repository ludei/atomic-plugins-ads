//
//  InMobiNativeAdapter.m
//  InMobiMopubSampleApp
//
//  Created by Niranjan Agrawal on 28/10/15.
//
//
#import "InMobiNativeAdAdapter.h"
#import <inMobi/IMNative.h>
#import <MoPub/MPNativeAdError.h>
#import <MoPub/MPNativeAdConstants.h>
#import <MoPub/MPAdDestinationDisplayAgent.h>
#import <MoPub/MPCoreInstanceProvider.h>
#import <MoPub/MPLogging.h>
#import <MoPub/MPStaticNativeAdImpressionTimer.h>

static const NSTimeInterval kInMobiRequiredSecondsForImpression = 0.0;
static const CGFloat kInMobiRequiredViewVisibilityPercentage = 0.5;

/*
 * Default keys for InMobi Native Ads
 *
 * These values must correspond to the strings configured with InMobi.
 */
static NSString *gInMobiTitleKey = @"title";
static NSString *gInMobiDescriptionKey = @"description";
static NSString *gInMobiCallToActionKey = @"cta";
static NSString *gInMobiRatingKey = @"rating";
static NSString *gInMobiScreenshotKey = @"screenshots";
static NSString *gInMobiIconKey = @"icon";
// As of 6-25-2014 this key is editable on InMobi's site
static NSString *gInMobiLandingURLKey = @"landingURL";

/*
 * InMobi Key - Do Not Change.
 */
static NSString *const kInMobiImageURL = @"url";

@interface InMobiNativeAdAdapter() <MPAdDestinationDisplayAgentDelegate, MPStaticNativeAdImpressionTimerDelegate>

@property (nonatomic, readonly) IMNative *inMobiNativeAd;
@property (nonatomic) MPStaticNativeAdImpressionTimer *impressionTimer;
@property (nonatomic, readonly) MPAdDestinationDisplayAgent *destinationDisplayAgent;

@end

@implementation InMobiNativeAdAdapter

@synthesize properties = _properties;
@synthesize defaultActionURL = _defaultActionURL;

+ (void)setCustomKeyForTitle:(NSString *)key
{
    gInMobiTitleKey = [key copy];
}

+ (void)setCustomKeyForDescription:(NSString *)key
{
    gInMobiDescriptionKey = [key copy];
}

+ (void)setCustomKeyForCallToAction:(NSString *)key
{
    gInMobiCallToActionKey = [key copy];
}

+ (void)setCustomKeyForRating:(NSString *)key
{
    gInMobiRatingKey = [key copy];
}

+ (void)setCustomKeyForScreenshot:(NSString *)key
{
    gInMobiScreenshotKey = [key copy];
}

+ (void)setCustomKeyForIcon:(NSString *)key
{
    gInMobiIconKey = [key copy];
}

+ (void)setCustomKeyForLandingURL:(NSString *)key
{
    gInMobiLandingURLKey = [key copy];
}

- (instancetype)initWithInMobiNativeAd:(IMNative *)nativeAd
{
    self = [super init];
    if (self) {
        _inMobiNativeAd = nativeAd;
        
        NSDictionary *inMobiProperties = [self inMobiProperties];
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        
        if ([inMobiProperties objectForKey:gInMobiRatingKey]) {
            [properties setObject:[inMobiProperties objectForKey:gInMobiRatingKey] forKey:kAdStarRatingKey];
        }
        
        if ([[inMobiProperties objectForKey:gInMobiTitleKey] length]) {
            [properties setObject:[inMobiProperties objectForKey:gInMobiTitleKey] forKey:kAdTitleKey];
        }
        
        if ([[inMobiProperties objectForKey:gInMobiDescriptionKey] length]) {
            [properties setObject:[inMobiProperties objectForKey:gInMobiDescriptionKey] forKey:kAdTextKey];
        }
        
        if ([[inMobiProperties objectForKey:gInMobiCallToActionKey] length]) {
            [properties setObject:[inMobiProperties objectForKey:gInMobiCallToActionKey] forKey:kAdCTATextKey];
        }
        
        NSDictionary *iconDictionary = [inMobiProperties objectForKey:gInMobiIconKey];
        
        if ([[iconDictionary objectForKey:kInMobiImageURL] length]) {
            [properties setObject:[iconDictionary objectForKey:kInMobiImageURL] forKey:kAdIconImageKey];
        }
        
        NSDictionary *mainImageDictionary = [inMobiProperties objectForKey:gInMobiScreenshotKey];
        
        if ([[mainImageDictionary objectForKey:kInMobiImageURL] length]) {
            [properties setObject:[mainImageDictionary objectForKey:kInMobiImageURL] forKey:kAdMainImageKey];
        }
        
        _properties = properties;
        
        if ([[inMobiProperties objectForKey:gInMobiLandingURLKey] length]) {
            _defaultActionURL = [NSURL URLWithString:[inMobiProperties objectForKey:gInMobiLandingURLKey]];
        } else {
            // Log a warning if we can't find the landing URL since the key can either be "landing_url", "landingURL", or a custom key depending on the date the property was created.
            MPLogWarn(@"WARNING: Couldn't find landing url with key: %@ for InMobi network.  Double check your ad property and call setCustomKeyForLandingURL: with the correct key if necessary.", gInMobiLandingURLKey);
        }
        
        _destinationDisplayAgent = [[MPCoreInstanceProvider sharedProvider] buildMPAdDestinationDisplayAgentWithDelegate:self];
        
        _impressionTimer = [[MPStaticNativeAdImpressionTimer alloc] initWithRequiredSecondsForImpression:kInMobiRequiredSecondsForImpression requiredViewVisibilityPercentage:kInMobiRequiredViewVisibilityPercentage];
        _impressionTimer.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [_destinationDisplayAgent cancel];
    [_destinationDisplayAgent setDelegate:nil];
}

- (NSDictionary *)inMobiProperties
{
    NSData *data = [self.inMobiNativeAd.adContent dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSDictionary *propertyDictionary = nil;
    if (data) {
        propertyDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    if (propertyDictionary && !error) {
        return propertyDictionary;
    }
    else {
        return nil;
    }
}

#pragma mark - <MPStaticNativeAdImpressionTimerDelegate>

- (void)trackImpression
{
    [self.delegate nativeAdWillLogImpression:self];
}

#pragma mark - <MPNativeAdAdapter>

- (void)willAttachToView:(UIView *)view
{
    [self.impressionTimer startTrackingView:view];
    [IMNative bindNative:self.inMobiNativeAd toView:view];
}

- (void)trackClick
{
    [self.inMobiNativeAd reportAdClick:nil];
}

- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller
{
    if (!controller) {
        return;
    }
    
    if (!URL || ![URL isKindOfClass:[NSURL class]] || ![URL.absoluteString length]) {
        return;
    }
    
    [self.destinationDisplayAgent displayDestinationForURL:URL];
}

#pragma mark - <MPAdDestinationDisplayAgentDelegate>

- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)displayAgentWillPresentModal
{
    [self.delegate nativeAdWillPresentModalForAdapter:self];
}

- (void)displayAgentWillLeaveApplication
{
    [self.delegate nativeAdWillLeaveApplicationFromAdapter:self];
}

- (void)displayAgentDidDismissModal
{
    [self.delegate nativeAdDidDismissModalForAdapter:self];
}

@end