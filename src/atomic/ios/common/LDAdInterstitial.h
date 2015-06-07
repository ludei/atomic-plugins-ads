#import <UIKit/UIKit.h>

@protocol LDAdInterstitialDelegate;
@protocol LDAdInterstitialProtocol;

/**
 *  The `LDAdInterstitial` class provides a full-screen advertisement UIViewController
 */
typedef NSObject<LDAdInterstitialProtocol> LDAdInterstitial;
@protocol LDAdInterstitialProtocol

/**
 *  The delegate (`LDAdInterstitialDelegate`) of the ad view.
*/
@property (nonatomic, weak) id<LDAdInterstitialDelegate> delegate;

/**
 *  Begins loading ad content for the interstitial.
 *  You can implement the `adInterstitialDidLoad:` and `adInterstitialDidFailLoad:` methods of
 *  `LDAdInterstitialDelegate` if you would like to be notified as loading succeeds or fails.
 */
- (void)loadAd;

/**
 *  Shows the interstitial, if it is ready.
 *
 *  @param controller The parent view controller.
 *  @param animated   Animated transtition.
 */
- (void)showFromViewController:(UIViewController *)controller animated:(BOOL) animated;

/**
 *  Hides the interstitial.
 *
 *  @param animated Animated transtition.
 */
- (void)dismissAnimated:(BOOL) animated;
@end

@protocol LDAdInterstitialDelegate<NSObject>
@optional

/**
 *  Sent when an interstitial successfully loads a new ad.
 *
 *  @param interstitial The interstitial.
 */
-(void) adInterstitialDidLoad:(LDAdInterstitial *) interstitial;

/**
 *  Sent when an interstitial ad object fails to load an ad.
 *
 *  @param interstitial The interstitial.
 *  @param error        The reported error.
 */
-(void) adInterstitialDidFailLoad:(LDAdInterstitial *) interstitial withError:(NSError *) error;

/**
 *  Sent immediately before an interstitial ad object is presented on the screen.
 *  Your implementation of this method should pause any application activity that requires user interaction.
 *
 *  @param interstitial The interstitial.
 */
- (void)adInterstitialWillAppear:(LDAdInterstitial *)interstitial;

/**
 *  Sent after an interstitial ad object has been dismissed from the screen, returning control to your application.
 *  Your implementation of this method should resume any application activity that was paused prior to the interstitial being presented on-screen.
 *
 *  @param interstitial The interstitial.
 */
- (void)adInterstitialWillDisappear:(LDAdInterstitial *)interstitial;

/**
 *  Sent when a rewarded video interstitial is completed
 *
 *  @param interstitial The interstitial.
 */
- (void)adInterstitialDidCompleteRewardedVideo:(LDAdInterstitial *)interstitial withReward:(int)reward;

@end
