#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

BOOL enabled = NO;

// settings
BOOL useImageWallpaperSwitch = NO;
BOOL useVideoWallpaperSwitch = NO;

@interface HBAppGridViewController : UIViewController
@property(nonatomic, retain)UIImageView* wallpaperView;
@property(nonatomic, retain)AVQueuePlayer* player;
@property(nonatomic, retain)AVPlayerItem* playerItem;
@property(nonatomic, retain)AVPlayerLooper* playerLooper;
@property(nonatomic, retain)AVPlayerLayer* playerLayer;
@end

@interface HBUIMainAppGridTopShelfContainerView : UIView
@end

@interface HBBadgeOverlayView : UIView
@end