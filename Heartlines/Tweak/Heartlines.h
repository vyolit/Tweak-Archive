#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <MediaRemote/MediaRemote.h>
#import <Kitten/libKitten.h>
#import "libpddokdo.h"
#import "GcUniversal/GcColorPickerUtils.h"
#import "HLSLocalization.h"
#import <dlfcn.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void *, int, void *);

BOOL isScreenOn = YES;
BOOL firstTimeLoaded = NO;
BOOL isLocked = NO;
BOOL justPluggedIn = NO;
BOOL isTimerRunning = NO;
NSTimer* timeAndDateTimer = nil;
UIColor* backgroundWallpaperColor = nil;
UIColor* primaryWallpaperColor = nil;
UIColor* secondaryWallpaperColor = nil;
UIColor* darkBackgroundWallpaperColor = nil;
UIColor* darkPrimaryWallpaperColor = nil;
UIColor* darkSecondaryWallpaperColor = nil;
UIImage* currentArtwork = nil;
NSData* lastArtworkData = nil;
UIColor* backgroundArtworkColor = nil;
UIColor* primaryArtworkColor = nil;
UIColor* secondaryArtworkColor = nil;

// style & position
NSString* styleValue = @"0";
NSString* positionValue = @"0";

// faceid lock
BOOL hideFaceIDLockSwitch = NO;
BOOL alignFaceIDLockSwitch = YES;
BOOL smallerFaceIDLockSwitch = YES;

// text
BOOL useCustomFontSwitch = NO;
NSString* timeFormatValue = @"HH:mm";
NSString* dateFormatValue = @"EEEE d MMMM";
BOOL useCustomDateLocaleSwitch = NO;
NSString* customDateLocaleValue = @"";
BOOL useCustomUpNextFontSizeSwitch = NO;
NSString* customUpNextFontSizeValue = @"19.0";
BOOL useCustomUpNextEventFontSizeSwitch = NO;
NSString* customUpNextEventFontSizeValue = @"15.0";
BOOL useCustomTimeFontSizeSwitch = NO;
NSString* customTimeFontSizeValue = @"61.0";
BOOL useCustomDateFontSizeSwitch = NO;
NSString* customDateFontSizeValue = @"17.0";
BOOL useCustomWeatherReportFontSizeSwitch = NO;
NSString* customWeatherReportFontSizeValue = @"14.0";
BOOL useCustomWeatherConditionFontSizeSwitch = NO;
NSString* customWeatherConditionFontSizeValue = @"14.0";

// colors
NSString* faceIDLockColorValue = @"3";
NSString* customFaceIDLockColorValue = @"FFFFFF";
NSString* upNextColorValue = @"3";
NSString* customUpNextColorValue = @"FFFFFF";
NSString* upNextEventColorValue = @"1";
NSString* customUpNextEventColorValue = @"FFFFFF";
NSString* timeColorValue = @"3";
NSString* customTimeColorValue = @"FFFFFF";
NSString* dateColorValue = @"3";
NSString* customDateColorValue = @"FFFFFF";
NSString* weatherReportColorValue = @"1";
NSString* customWeatherReportColorValue = @"FFFFFF";
NSString* weatherConditionColorValue = @"1";
NSString* customWeatherConditionColorValue = @"FFFFFF";
BOOL artworkBasedColorsSwitch = YES;
NSString* faceIDLockArtworkColorValue = @"0";
NSString* upNextArtworkColorValue = @"0";
NSString* upNextEventArtworkColorValue = @"2";
NSString* timeArtworkColorValue = @"0";
NSString* dateArtworkColorValue = @"0";
NSString* weatherReportArtworkColorValue = @"2";
NSString* weatherConditionArtworkColorValue = @"2";

// weather
BOOL showWeatherSwitch = YES;

// up next
BOOL showUpNextSwitch = YES;
BOOL showCalendarEventsSwitch = YES;
BOOL showRemindersSwitch = YES;
BOOL showNextAlarmSwitch = YES;
BOOL prioritizeRemindersSwitch = NO;
BOOL prioritizeAlarmsSwitch = YES;
NSString* dayRangeValue = @"3";
BOOL hideUntilAuthenticatedSwitch = NO;
BOOL invisibleInkEffectSwitch = YES;

// miscellaneous
BOOL magsafeCompatibilitySwitch = NO;

@interface SBUIProudLockIconView : UIView
- (void)setContentColor:(UIColor *)arg1;
@end

@interface UIMorphingLabel : UIView
- (id)_viewControllerForAncestor;
@end

@interface SBUILegibilityLabel : UILabel
@end

@interface SBFLockScreenAlternateDateLabel : UILabel
@end

@interface SBFLockScreenDateSubtitleView : UIView
@end

@interface SBLockScreenTimerDialView : UIView
@end

@interface SBFLockScreenDateSubtitleDateView : UIView
@end

@interface SBFLockScreenDateView : UIView
@property(nonatomic, retain)UILabel* heartlinesWeatherReportLabel;
@property(nonatomic, retain)UILabel* heartlinesWeatherConditionLabel;
@property(nonatomic, retain)UILabel* heartlinesTimeLabel;
@property(nonatomic, retain)UILabel* heartlinesDateLabel;
@property(nonatomic, retain)UILabel* heartlinesUpNextLabel;
@property(nonatomic, retain)UILabel* heartlinesUpNextEventLabel;
@property(nonatomic, retain)UIView* heartlinesInvisibleInk;
- (void)updateHeartlinesTimeAndDate;
- (void)updateHeartlinesUpNext;
@end

@interface CSCoverSheetViewController : UIViewController
- (void)requestHeartlinesTimeAndDateUpdate;
@end

@interface SBBacklightController : NSObject
- (void)requestHeartlinesTimeAndDateUpdate;
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (BOOL)isLockScreenVisible;
@end

@interface SBUIController : NSObject
- (BOOL)isOnAC;
- (int)batteryCapacityAsPercentage;
@end

@interface MTAlarm
@property(nonatomic, readonly)NSDate* nextFireDate;
@end

@interface MTAlarmCache
@property(nonatomic, retain)MTAlarm* nextAlarm; 
@end

@interface MTAlarmManager
@property(nonatomic, retain)MTAlarmCache* cache;
@end

@interface SBScheduledAlarmObserver : NSObject {
    MTAlarmManager* _alarmManager;
}
+ (id)sharedInstance;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
- (BOOL)isPaused;
- (void)setNowPlayingInfo:(id)arg1;
@end