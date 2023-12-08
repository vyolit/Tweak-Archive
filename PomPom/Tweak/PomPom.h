//
//  PomPom.h
//  PomPom
//
//  Created by Alexandra (@Traurige)
//

#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import "PeterDev/libpddokdo.h"
#import <MediaRemote/MediaRemote.h>
#import <AppList/AppList.h>
#import <EventKit/EventKit.h>

HBPreferences* preferences;
BOOL enabled;

NSTimer* updateTimer;
BOOL timerRunning = NO;
BOOL isDisplayingBatteryLevel = NO;

// appearance
BOOL hideFaceIDLock;
BOOL hideFlashlight;
BOOL hideCamera;
BOOL hideQuickActionsBackground;
BOOL hideUnlockText;
BOOL hidePageDots;
BOOL hideHomebar;

// media player
BOOL replaceMediaPlayer;
BOOL displayRewindButton;
BOOL displayPlayButton;
BOOL displaySkipButton;
BOOL displayTimeSlider;
NSUInteger timeSliderOverrideStyle;

// notifications
BOOL hideNotificationsHeader;
BOOL hideNoOlderNotifications;
NSInteger additionalNotificationsOffset;
BOOL alwaysRevealNotifications;

// time and date
NSString* timeFormat;
NSString* dateFormat;
NSString* dateLocale;
BOOL displayWeather;

// up next
BOOL displayUpNext;
BOOL fetchEvents;
NSUInteger eventsRange;
BOOL useAmericanDateFormat;

@interface SBUIProudLockIconView : UIView
- (void)alignLeft;
- (void)alignCenter;
@end

@interface SBFLockScreenDateSubtitleView : UIView
@end

@interface SBLockScreenTimerDialView : UIView
@end

@interface SBFLockScreenDateSubtitleDateView : UIView
@end

@interface SBUILegibilityLabel : UIView
@end

@interface SBFLockScreenAlternateDateLabel : UIView
@end

@interface CSAdjunctItemView : UIView
@end

@interface CSNotificationAdjunctListViewController : UIViewController
@end

@interface CSQuickActionsView : UIView
@end

@interface UICoverSheetButton : UIControl
@end

@interface CSQuickActionsButton : UICoverSheetButton
@end

@interface CSTeachableMomentsContainerView : UIView
@end

@interface SBUICallToActionLabel : UIView
@end

@interface CSPageControl : UIControl
@end

@interface CSHomeAffordanceView : UIView
@end

@interface SBFLockScreenDateView : UIView
@property(nonatomic, retain)UILabel* pompomTimeLabel;
@property(nonatomic, retain)UIImageView* pompomWeatherIconView;
@property(nonatomic, retain)UILabel* pompomDateLabel;
@property(nonatomic, retain)UIView* pompomPlayerView;
@property(nonatomic, retain)UIView* pompomArtworkContainerView;
@property(nonatomic, retain)UIButton* pompomArtworkButton;
@property(nonatomic, retain)UILabel* pompomSongTitleLabel;
@property(nonatomic, retain)UILabel* pompomArtistLabel;
@property(nonatomic, retain)UIButton* pompomRewindButton;
@property(nonatomic, retain)UIButton* pompomPlayButton;
@property(nonatomic, retain)UIButton* pompomSkipButton;
@property(nonatomic, retain)UIView* pompomTimeSliderView;
@property(nonatomic, retain)UIView* pompomUpNextView;
@property(nonatomic, retain)UILabel* pompomUpNextLabel;
@property(nonatomic, retain)UIButton* pompomUpNextIconButton;
@property(nonatomic, retain)UILabel* pompomUpNextEventLabel;
@property(nonatomic, retain)UILabel* pompomUpNextDateLabel;
- (void)updatePomPomTimeAndDate;
- (void)updatePomPomWeather;
- (void)updatePomPomMediaPlayer:(UIImage *)artwork :(NSString *)title :(NSString *)artist :(NSString *)album;
- (void)updatePomPomPlayButton:(BOOL)isPlaying;
- (void)rewindSong;
- (void)togglePlayback;
- (void)skipSong;
- (void)openUpNextApplication;
- (void)updatePomPomUpNext;
- (EKEvent *)fetchEvent;
@end

@interface UILabel (PomPom)
- (void)setMarqueeEnabled:(BOOL)arg1;
- (void)setMarqueeRunning:(BOOL)arg1;
@end

@interface MRUNowPlayingViewController : UIViewController
@property(assign, nonatomic)id delegate;
@end

@interface MRUNowPlayingTimeControlsView : UIView
- (id)_viewControllerForAncestor;
@end

@interface SBUIController : NSObject
- (BOOL)isOnAC;
- (int)batteryCapacityAsPercentage;
@end

@interface WACurrentForecast : NSObject
@property(assign, nonatomic)long long conditionCode;
@end

@interface WAForecastModel : NSObject
@property(nonatomic, retain)WACurrentForecast* currentConditions;
@end

@interface WALockscreenWidgetViewController : UIViewController
- (WAForecastModel *)currentForecastModel;
@end

@interface PDDokdo (PomPom)
@property(nonatomic, retain, readonly)WALockscreenWidgetViewController* weatherWidget;
@end

@interface CSCoverSheetViewController : UIViewController
- (void)updatePomPomTimeAndDate;
@end

@interface SBLockScreenManager : NSObject
@property(nonatomic, assign)NSString* queuedPomPomBundleIdentifier;
+ (id)sharedInstance;
- (BOOL)isLockScreenVisible;
- (BOOL)isUILocked;
- (BOOL)unlockUIFromSource:(int)arg1 withOptions:(id)arg2;
- (void)setPomPomQueueApplication:(NSString *)bundleIdentifier;
@end

@interface SBBacklightController : NSObject
- (void)updatePomPomTimeAndDate;
@end

@interface SBApplication : NSObject
- (NSString *)bundleIdentifier;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (SBApplication *)nowPlayingApplication;
- (BOOL)isPlaying;
- (BOOL)playForEventSource:(long long)arg1;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (void)setNowPlayingInfo:(id)arg1;
- (id)_nowPlayingInfo;
- (void)updatePomPomPlayButton;
@end

@interface UIApplication (PomPom)
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@implementation UIImage (scale)
- (UIImage *)scaleImageToSize:(CGSize)newSize {
    CGRect scaledImageRect = CGRectZero;
    CGFloat aspectWidth = newSize.width / self.size.width;
    CGFloat aspectHeight = newSize.height / self.size.height;
    CGFloat aspectRatio = MIN(aspectWidth, aspectHeight);
    
    scaledImageRect.size.width = self.size.width*  aspectRatio;
    scaledImageRect.size.height = self.size.height*  aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
@end
