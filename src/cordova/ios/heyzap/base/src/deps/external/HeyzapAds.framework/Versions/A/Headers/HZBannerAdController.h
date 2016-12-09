//
//  HZBannerAdController.h
//  Heyzap
//
//  Created by Maximilian Tagher on 4/12/16.
//  Copyright © 2016 Heyzap. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Locations where Heyzap can automatically place the banner.
 */
typedef NS_ENUM(NSUInteger, HZBannerPosition){
    /**
     *  Option for placing the banner at the top of the view.
     */
    HZBannerPositionTop,
    /**
     *  Option for placing the banner at the bottom of the view.
     */
    HZBannerPositionBottom,
};

@class HZBannerAdController;

extern NSString * const kHZBannerAdDidReceiveAdNotification;
extern NSString * const kHZBannerAdDidFailToReceiveAdNotification;
extern NSString * const kHZBannerAdWasClickedNotification;
extern NSString * const kHZBannerAdWillPresentModalViewNotification;
extern NSString * const kHZBannerAdDidDismissModalViewNotification;
extern NSString * const kHZBannerAdWillLeaveApplicationNotification;

@protocol HZBannerAdDelegate <NSObject>

@optional

/// @name Ad Request Notifications
#pragma mark - Ad Request Notifications

/**
 *  Called when the banner ad loads or refreshes itself.
 */
- (void)bannerDidReceiveAd:(HZBannerAdController *)banner;

/**
 *  Called when the banner ad fails to load.
 *
 *  @param error An error describing the failure.
 *
 *  If the underlying ad network provided an `NSError` object, it will be accessible in the `userInfo` dictionary
 *  with the `NSUnderlyingErrorKey`.
 */
- (void)bannerDidFailToReceiveAd:(HZBannerAdController *)banner error:(NSError *)error;

/// @name Click-time Notifications
#pragma mark - Click-time Notifications

/**
 *  Called when the user clicks the banner ad.
 */
- (void)bannerWasClicked:(HZBannerAdController *)banner;
/**
 *  Called when the banner ad will present a modal view controller, after the user clicks the ad.
 */
- (void)bannerWillPresentModalView:(HZBannerAdController *)banner;
/**
 *  Called when a presented modal view controller is dismissed by the user.
 */
- (void)bannerDidDismissModalView:(HZBannerAdController *)banner;
/**
 *  Called when a user clicks a banner ad that causes them to leave the application.
 */
- (void)bannerWillLeaveApplication:(HZBannerAdController *)banner;

@end

@class HZBannerAdOptions;

@interface HZBannerAdController : NSObject

+ (instancetype)sharedInstance;

/**
 *  The delegate for the banner ad.
 */
@property (nonatomic, weak) id<HZBannerAdDelegate> delegate;

- (void)placeBannerAtPosition:(HZBannerPosition)position
                      options:(HZBannerAdOptions *)options
                      success:(void (^)(UIView *banner))success
                      failure:(void (^)(NSError *error))failure;

- (void)requestBannerWithOptions:(HZBannerAdOptions *)options
                         success:(void (^)(UIView *banner))success
                         failure:(void (^)(NSError *error))failure;

#pragma mark - Interacting with the banner

/**
 *  A reference to the banner view. You must load the banner using `placeBannerInView:...` or `requestBannerWithOptions:...` for this to be set.
 */
@property (nonatomic, strong, readonly) UIView *bannerView;

/**
 *  Removes the banner from its superview and removes all of the SDK's strong references to it. You should set any of your strong references to the banner view to nil before calling this.
 */
- (void)destroyBanner;

@end
