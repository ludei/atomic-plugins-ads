#pragma once

#include <string>

namespace ludei { namespace ads {
	
    class AdBannerListener;
    
    /**
     * Defines the different possible sizes of a banner. 
     */
    enum class AdBannerSize {
    	/**
    	 * Smart size. 
    	 */
        SMART_SIZE,
		/**
		 * Banner size. 
		 */
        BANNER_SIZE,
		/**
		 * Medium rectangular size. 
		 */
        MEDIUM_RECT_SIZE,
		/**
		 * Leaderboard size. 
		 */
        LEADERBOARD_SIZE
    };
    
    /**
     * Defines the different possible layouts of a banner. 
     */
    enum class AdBannerLayout {
    	/**
    	 * Top center.  
    	 */
        TOP_CENTER,
		/**
		 * Bottom center. 
		 */
        BOTTOM_CENTER,
		/**
		 * Custom layout. 
		 */
        CUSTOM
    };
    
    /**
     * Defines a banner ad. 
     */
    class AdBanner {
    public:

        virtual ~AdBanner(){};
        
        /**
         * Shows the banner. 
         */
        virtual void show() = 0;
        
        /**
         * Hides the banner. 
         */
        virtual void hide() = 0;
        
        /**
         * Returns the width of the banner. 
         * 
         * @return The width of the banner. 
         */
        virtual int32_t getWidth() const = 0;
        
        /**
         * Returns the height of the banner. 
         * 
         * @return The height of the banner.
         */
        virtual int32_t getHeight() const = 0;
        
        /**
         * Loads a new banner ad. 
         */
        virtual void load() = 0;
        
        /**
         * Sets a new listener for the banner. 
         * 
         * @param listener The listener to be set. 
         */
        virtual void setListener(AdBannerListener * listener) = 0;
        
        /**
         * Sets the layout of the banner. 
         * 
         * @param layout The layout of the banner. 
         */
        virtual void setLayout(AdBannerLayout layout) = 0;
        
        /**
         * Sets the position of the banner given x and y coords. 
         * For custom layouts only. 
         * 
         * @param x The x coord. 
         * @param y The y coord. 
         */
        virtual void setPosition(float x, float y) = 0; 
        
    };

	/**
	 * Allows to listen to events regarding banner ads. 
	 */
    class AdBannerListener {
    public:

        virtual ~AdBannerListener(){};
        
        /**
         * Triggered when the banner has loaded a new ad. 
         * 
         * @param banner The banner ad. 
         */
        virtual void onLoaded(AdBanner * banner) = 0;
        
        /**
         * Triggered when the banner has failed on loading a new ad.  
         * 
         * @param banner The banner ad. 
         * @param code The code of the error. 
         * @param message The error message. 
         */
        virtual void onFailed(AdBanner * banner, int32_t code, const std::string & message) = 0;
        
        /**
         * Triggered when the banner has been clicked. 
         * 
         * @param banner The banner ad. 
         */
        virtual void onClicked(AdBanner * banner) = 0;
        
        /**
         * Triggered when the banner has expanded to show the content. 
         * 
         * @param banner The banner ad. 
         */
        virtual void onExpanded(AdBanner * banner) = 0;
        
        /**
         * Triggered when the banner has been collapsed after showing the content. 
         * 
         * @param banner The banner ad. 
         */
        virtual void onCollapsed(AdBanner * banner) = 0;
    };
    
} }