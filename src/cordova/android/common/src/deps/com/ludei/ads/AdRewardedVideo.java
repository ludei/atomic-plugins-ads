package com.ludei.ads;

/**
 * Defines a rewarded video ad.
 *
 * @author Imanol Fernández (@MortimerGoro)
 * @version 1.1
 */
public interface AdRewardedVideo {

    class Reward {
        public long amount;
        public String currency;
        public String itmKey;
    }

    class Error {
        public long code;
        public String message;
    }

    /**
     * Sets a listener for a rewarded video.
     *
     * @param listener A rewarded video listener.
     */
    void setListener(RewardedVideoListener listener);

    /**
     * Loads a rewarded video.
     */
    void loadAd();

    /**
     * Shows the rewarded video.
     */
    void show();

    /**
     * Destroys the rewarded video.
     */
    void destroy();

    /**
     * Allows to listen to rewarded video ads events.
     */
    interface RewardedVideoListener {

        /**
         * Sent when the rewarded video has loaded an ad.
         *
         * @param rewardedVideo A rewarded video ad.
         */
        void onLoaded(AdRewardedVideo rewardedVideo);

        /**
         * Sent when the rewarded video has failed to retrieve an ad.
         *
         * @param rewardedVideo A rewarded video ad.
         * @param error         Error code and message.
         */
        void onFailed(AdRewardedVideo rewardedVideo, Error error);

        /**
         * Sent when the user has tapped on the rewarded video.
         *
         * @param rewardedVideo A rewarded video ad.
         */
        void onClicked(AdRewardedVideo rewardedVideo);

        /**
         * Sent when the rewarded video has just taken over the screen.
         */
        void onShown(AdRewardedVideo rewardedVideo);

        /**
         * Sent when the rewarded video is closed.
         *
         * @param rewardedVideo A rewarded video ad.
         */
        void onDismissed(AdRewardedVideo rewardedVideo);

        /**
         * Sent when the rewarded video is completed.
         *
         * @param rewardedVideo A rewarded video ad.
         * @param reward        Reward from the rewarded video.
         * @param error         Error code and message.
         */
        void onRewardCompleted(AdRewardedVideo rewardedVideo, Reward reward, Error error);
    }
}
