#import <UIKit/UIKit.h>

@protocol LDAdBannerDelegate;
@protocol LDAdBannerProtocol;

/**
 *  Sets the size of a banner ad.
 */
typedef NS_ENUM(NSInteger, LDAdBannerSize) {
    /**
     *  Smart size.
     */
     LD_SMART_SIZE,
    /**
     *  Standard banner size.
     */
    LD_BANNER_SIZE,
    /**
     *  Medium Rectangle size.
     */
    LD_MEDIUM_RECT_SIZE,
    /**
     *  Leaderboard size.
     */
    LD_LEADERBOARD_SIZE,
};

/**
 *  The LDAdBanner class provides a view that can display banner advertisements.
 */
typedef NSObject <LDAdBannerProtocol> LDAdBanner;

@protocol LDAdBannerProtocol

/**
*  The delegate (`LDAdBannerDelegate`) of the ad view.
*/
    @property(nonatomic, weak) id <LDAdBannerDelegate> delegate;

/**
 *  Enable or disable automatic refresh of the ads.
 *  By default, an ad view is allowed to automatically load new advertisements.
 */
    @property(nonatomic, assign) BOOL autoRefresh;

/**
 *  Requests a new ad from the ad server.
 *  If the ad view is already loading an ad, this call might be ignored.
 */
    - (void)loadAd;

/**
 * Returns YES is the Ad is ready to be displayed
 **/
    - (bool)isReady;

/**
 *  Returns the size of the current ad being displayed in the ad view.
 *  Ad sizes may vary between different ad networks. This method returns the actual size of the banner.
 *
 *  @return The size of the underlying mediated ad.
 */
    - (CGSize)adSize;

/**
 *  Returns the size of the current ad being displayed in the ad view.
 *
 *  @return The size of the current ad being displayed.
 */
    - (UIView *)view;

@end

@protocol LDAdBannerDelegate <NSObject>
@optional

/**
 *  Asks the delegate for a view controller to use for presenting modal content, such as the in-app browser that can appear when an ad is tapped.
 *  keyWindow.rootViewController is used if the delegate doesn't implement this method.
 *
 *  @return A view controller that should be used for presenting modal content.
 */
    - (UIViewController *)viewControllerForPresentingModalView;

/**
 *  Sent when an ad banner successfully loads a new ad.
 *
 *  @param banner The ad banner sending the message.
 */
    - (void)adBannerDidLoad: (LDAdBanner *)banner;

/**
 *  Sent when an ad view fails to load an ad.
 *  To avoid displaying blank ads, you should hide the ad view in response to this message.
 *
 *  @param banner The banner ad that failed to load.
 *  @param error  The reported error.
 */
    - (void)adBannerDidFailLoad: (LDAdBanner *)banner withError: (NSError *)error;

/**
 *  Sent when an ad view is about to present modal content.
 *  This method is called when the user taps on the ad view. Your implementation of this method
 *  should pause any application activity that requires user interaction.
 *
 *  @param banner The banner ad that is about to present modal content.
 */
    - (void)adBannerWillPresentModal: (LDAdBanner *)banner;

/**
 *  Sent when an ad view has dismissed its modal content, returning control to your application.
 *  Your implementation of this method should resume any application activity that was paused
 *  in response to `willPresentModalViewForAd:`.
 *
 *  @param banner The banner ad that has dismissed its modal content.
 */
    - (void)adBannerDidDismissModal: (LDAdBanner *)banner;

@end