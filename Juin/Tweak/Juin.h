#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

// style
NSString* styleValue = @"0";

// background
BOOL backgroundArtworkSwitch = YES;
BOOL addBlurSwitch = NO;
NSString* blurModeValue = @"2";
NSString* blurAmountValue = @"1.0";

// gestures
BOOL leftSwipeSwitch = YES;
BOOL rightSwipeSwitch = YES;

// miscellaneous
NSString* newOffsetValue = @"0";
BOOL showDeviceNameSwitch = YES;

@interface CSCoverSheetView : UIView
@property(nonatomic, retain)UIView* juinView;
@property(nonatomic, retain)UIImageView* juinBackgroundArtwork;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)CAGradientLayer* gradient;
@property(nonatomic, retain)UILabel* sourceLabel;
@property(nonatomic, retain)UIButton* playPauseButton;
@property(nonatomic, retain)UIButton* rewindButton;
@property(nonatomic, retain)UIButton* skipButton;
@property(nonatomic, retain)UILabel* artistLabel;
@property(nonatomic, retain)UILabel* songLabel;
@property(nonatomic, retain)UIView* gestureView;
@property(nonatomic, retain)UITapGestureRecognizer* tap;
@property(nonatomic, retain)UISwipeGestureRecognizer* leftSwipe;
@property(nonatomic, retain)UISwipeGestureRecognizer* rightSwipe;
- (void)rewindSong;
- (void)skipSong;
- (void)pausePlaySong;
- (void)hideJuinView;
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender;
@end

@interface MediaControlsTimeControl : UIControl
- (id)_viewControllerForAncestor;
@end

@interface MRPlatterViewController : UIViewController
@property(assign, nonatomic)id delegate;
@end

@interface MRUNowPlayingTimeControlsView : UIView
- (id)_viewControllerForAncestor;
@end

@interface MRUNowPlayingViewController : UIViewController
@property(assign, nonatomic)id delegate;
@end

@interface CSMediaControlsViewController : UIViewController
@end

@interface CSAdjunctItemView : UIView
@end

@interface NCNotificationListView : UIView
@end

@interface CSNotificationAdjunctListViewController : UIViewController
@end

@interface CSQuickActionsButton : UIControl
- (void)receiveFadeNotification:(NSNotification *)notification;
@end

@interface CSPageControl : UIPageControl
- (void)receiveFadeNotification:(NSNotification *)notification;
@end

@interface SBUILegibilityLabel : UILabel
@end

@interface CSTeachableMomentsContainerView : UIView
@end

@interface SBUICallToActionLabel : UILabel
@end

@interface UILabel (Juin)
- (void)setMarqueeEnabled:(BOOL)arg1;
- (void)setMarqueeRunning:(BOOL)arg1;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (void)setNowPlayingInfo:(id)arg1;
- (BOOL)isPlaying;
- (BOOL)isPaused;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
@end