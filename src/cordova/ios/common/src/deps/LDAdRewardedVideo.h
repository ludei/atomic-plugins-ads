#import <UIKit/UIKit.h>

@protocol LDAdRewardedVideoDelegate;
@protocol LDAdRewardedVideoProtocol;

/**
 *  The `LDAdRewardedVideo` class provides a full-screen advertisement UIViewController
 */
typedef NSObject<LDAdRewardedVideoProtocol> LDAdRewardedVideo;


@protocol LDAdRewardedVideoProtocol

/**
 *  The delegate (`LDAdRewardedVideoDelegate`) of the ad view.
*/
@property (nonatomic, weak) id<LDAdRewardedVideoDelegate> delegate;

/**
 *  Begins loading ad content for the rewardedVideo.
 *  You can implement the `adRewardedVideoDidLoad:` and `adRewardedVideoDidFailLoad:` methods of
 *  `LDAdRewardedVideoDelegate` if you would like to be notified as loading succeeds or fails.
 */
- (void)loadAd;

/**
 * Returns YES is the ad is ready to be displayed
 **/
-(bool) isReady;


/**
 *  Shows the rewardedVideo, if it is ready.
 *
 *  @param controller The parent view controller.
 *  @param animated   Animated transtition.
 */
- (void)showFromViewController:(UIViewController *)controller animated:(BOOL) animated;

/**
 *  Hides the rewardedVideo.
 *
 *  @param animated Animated transtition.
 */
- (void)dismissAnimated:(BOOL) animated;
@end


@protocol LDRewardedVideoRewardProtocol <NSObject>
@property (nonatomic, strong) NSString *currencyType;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *itmKey;
@end

typedef NSObject<LDRewardedVideoRewardProtocol> LDRewardedVideoReward;

@protocol LDAdRewardedVideoDelegate<NSObject>
@optional

/**
 *  Sent when an rewardedVideo successfully loads a new ad.
 *
 *  @param rewardedVideo The rewardedVideo.
 */
-(void) adRewardedVideoDidLoad:(LDAdRewardedVideo *) rewardedVideo;

/**
 *  Sent when an rewardedVideo ad object fails to load an ad.
 *
 *  @param rewardedVideo The rewardedVideo.
 *  @param error        The reported error.
 */
-(void) adRewardedVideoDidFailLoad:(LDAdRewardedVideo *) rewardedVideo withError:(NSError *) error;

/**
 *  Sent immediately before an rewardedVideo ad object is presented on the screen.
 *  Your implementation of this method should pause any application activity that requires user interaction.
 *
 *  @param rewardedVideo The rewardedVideo.
 */
- (void)adRewardedVideoWillAppear:(LDAdRewardedVideo *)rewardedVideo;

/**
 *  Sent after an rewardedVideo ad object has been dismissed from the screen, returning control to your application.
 *  Your implementation of this method should resume any application activity that was paused prior to the rewardedVideo being presented on-screen.
 *
 *  @param rewardedVideo The rewardedVideo.
 */
- (void)adRewardedVideoWillDisappear:(LDAdRewardedVideo *)rewardedVideo;


/**
 *  Sent when a rewarded video rewardedVideo is completed (either succeeded or skipped)
 *
 *  @param rewardedVideo The rewardedVideo.
 */
- (void)adRewardedVideoDidCompleteRewardedVideo:(LDAdRewardedVideo *)rewardedVideo withReward:(LDRewardedVideoReward*) reward andError:(NSError *) error;

@end
