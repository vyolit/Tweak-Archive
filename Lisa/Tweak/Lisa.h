#import <UIKit/UIKit.h>
#import "LisaView.h"
#import <dlfcn.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

LisaView* lisaView = nil;

// global
BOOL isScreenOn = NO;
int previousNotificationStyle = 0;
BOOL hasAddedStatusBarObserver = NO;
int notificationCount = 0;
BOOL isDNDActive = NO;

// customization
BOOL onlyWhenDNDIsActiveSwitch = NO;
BOOL whenNotificationArrivesSwitch = YES;
BOOL alwaysWhenNotificationsArePresentedSwitch = YES;
BOOL whenPlayingMusicSwitch = YES;
BOOL onlyWhileChargingSwitch = NO;
BOOL hideStatusBarSwitch = YES;
BOOL hideControlCenterIndicatorSwitch = YES;
BOOL hideFaceIDLockSwitch = YES;
BOOL hideTimeAndDateSwitch = YES;
BOOL hideQuickActionsSwitch = YES;
BOOL hideUnlockTextSwitch = YES;
BOOL hideHomebarSwitch = YES;
BOOL hidePageDotsSwitch = YES;
BOOL hideComplicationsSwitch = YES;
BOOL hideKaiSwitch = YES;
BOOL hideAperioSwitch = YES;
BOOL hideLibellumSwitch = YES;
BOOL hideVezaSwitch = YES;
BOOL hideAxonSwitch = YES;
BOOL disableTodaySwipeSwitch = NO;
BOOL disableCameraSwipeSwitch = NO;
BOOL blurredBackgroundSwitch = NO;
BOOL tapToDismissLisaSwitch = YES;
NSString* backgroundAlphaValue = @"1";
NSString* notificationStyleValue = @"0";

// animations
BOOL lisaFadeOutAnimationSwitch = YES;
NSString* lisaFadeOutAnimationValue = @"0.5";

// haptic feedback
BOOL hapticFeedbackSwitch = NO;
NSString* hapticFeedbackStrengthValue = @"0";

@interface CSCoverSheetViewController : UIViewController
@end

@interface NCNotificationViewControllerView : UIView
- (void)updateNotificationStyle;
@end

@interface SBFLockScreenDateView : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface SBUIProudLockIconView : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface _UIStatusBar : UIView
@end

@interface UIStatusBar_Modern : UIView
- (_UIStatusBar *)statusBar;
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface CSQuickActionsButton : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface CSTeachableMomentsContainerView : UIView
@property(nonatomic, strong, readwrite)UIView* controlCenterGrabberContainerView;
@property(nonatomic, retain)UIView* callToActionLabelContainerView;
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface SBUICallToActionLabel : UILabel
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface CSHomeAffordanceView : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface CSPageControl : UIPageControl
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface ComplicationsView : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface KAIBatteryPlatter : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface APEPlatter : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface LibellumView : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface VezaView : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface AXNView : UIView
- (void)receiveHideNotification:(NSNotification *)notification;
@end

@interface SBUILegibilityLabel : UIView
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (BOOL)isLockScreenVisible;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
@end

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (BOOL)isOnAC;
@end

@interface BBAction : NSObject
+ (id)actionWithLaunchBundleID:(id)arg1 callblock:(id)arg2;
@end

@interface BBBulletin : NSObject
@property(nonatomic, copy)NSString* sectionID;
@property(nonatomic, copy)NSString* recordID;
@property(nonatomic, copy)NSString* publisherBulletinID;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* message;
@property(nonatomic, retain)NSDate* date;
@property(assign, nonatomic)BOOL clearable;
@property(nonatomic)BOOL showsMessagePreview;
@property(nonatomic, copy)BBAction* defaultAction;
@property(nonatomic, copy)NSString* bulletinID;
@property(nonatomic, retain)NSDate* lastInterruptDate;
@property(nonatomic, retain)NSDate* publicationDate;
@end

@interface BBServer : NSObject
- (void)publishBulletin:(BBBulletin *)arg1 destinations:(NSUInteger)arg2 alwaysToLockScreen:(BOOL)arg3;
- (void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2;
@end

@interface BBObserver : NSObject
@end

@interface NCBulletinNotificationSource : NSObject
- (BBObserver *)observer;
@end

@interface SBNCNotificationDispatcher : NSObject
- (NCBulletinNotificationSource *)notificationSource;
@end

@interface SpringBoard : UIApplication
- (void)_simulateLockButtonPress;
- (void)_simulateHomeButtonPress;
@end