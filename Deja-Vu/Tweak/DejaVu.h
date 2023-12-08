#import <UIKit/UIKit.h>
#import <BackBoardServices/BKSDisplayBrightness.h>
#import <Cephei/HBPreferences.h>

extern "C" void GSSendAppPreferencesChanged(CFStringRef bundleID, CFStringRef key);

HBPreferences* preferences = nil;
BOOL enabled = NO;

BOOL isDejaVuActive = NO;
int previousLowPowerModeState = 0;
BOOL wasAutoBrightnessEnabled = YES;

UIView* dejaVuView = nil;
UIImpactFeedbackGenerator* generator = nil;
NSTimer* inactivityTimer = nil;
NSTimer* pixelShiftTimer = nil;
NSTimer* dimTimer = nil;
BOOL loadedTimeAndDateFrame = NO;
CGRect originalTimeAndDateFrame;
float lastBrightness = 0;
BOOL hasAddedStatusBarObserver = NO;

// behavior
BOOL onlyWhenChargingSwitch = NO;
BOOL disableWhileChargingSwitch = YES;
BOOL deactivateWithTapSwitch = YES;
BOOL deactivateWithRaiseToWakeSwitch = YES;
BOOL deactivateAfterInactivitySwitch = YES;
NSUInteger inactivityAmountValue = 15;
BOOL enableHapticFeedbackSwitch = NO;
NSUInteger hapticFeedbackStrengthValue = 0;
BOOL disableBiometricsSwitch = YES;
BOOL pocketDetectionSwitch = YES;
BOOL pixelShiftSwitch = YES;
BOOL dimDisplaySwitch = NO;
BOOL enableLowPowerModeSwitch = YES;
BOOL enableDoNotDisturbSwitch = NO;
BOOL disableControlCenterSwitch = YES;

// customization
BOOL hideStatusBarSwitch = YES;
BOOL hideFaceIDLockSwitch = YES;
BOOL hideTimeAndDateSwitch = NO;
BOOL hideMediaPlayerSwitch = NO;
BOOL hideQuickActionsSwitch = YES;
BOOL hideUnlockTextAndHomebarSwitch = YES;

@interface CSCoverSheetViewController : UIViewController
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (BOOL)isLockScreenVisible;
- (void)setBiometricAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2;
- (void)activateDejaVu;
- (void)deactivateDejaVu;
- (void)initiatePixelShift;
- (void)dimDisplay;
- (void)undimDisplay;
@end

@interface SBProximitySensorManager : NSObject
- (void)_enableProx;
- (void)_disableProx;
@end

@interface SpringBoard : UIApplication
- (void)_simulateHomeButtonPress;
- (void)_simulateLockButtonPress;
- (SBProximitySensorManager *)proximitySensorManager;
@end

@interface _CDBatterySaver : NSObject
+ (id)sharedInstance;
- (long long)getPowerMode;
- (BOOL)setPowerMode:(long long)arg1 error:(id *)arg2;
@end

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (BOOL)isOnAC;
@end

@interface SBDashBoardIdleTimerProvider : NSObject
- (void)addDisabledIdleTimerAssertionReason:(id)arg1;
- (void)removeDisabledIdleTimerAssertionReason:(id)arg1;
@end

@interface SBUIBiometricResource : NSObject
+ (id)sharedInstance;
- (void)noteScreenDidTurnOff;
- (void)noteScreenWillTurnOn;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
- (BOOL)isPaused;
@end

@interface DNDModeAssertionService : NSObject
+ (id)serviceForClientIdentifier:(id)arg1;
- (id)takeModeAssertionWithDetails:(id)arg1 error:(id *)arg2;
- (BOOL)invalidateAllActiveModeAssertionsWithError:(id *)arg1;
@end

@interface DNDModeAssertionDetails : NSObject
+ (id)userRequestedAssertionDetailsWithIdentifier:(id)arg1 modeIdentifier:(id)arg2 lifetime:(id)arg3;
@end

@interface _UIStatusBar : UIView
@end

@interface UIStatusBar_Modern : UIView
- (_UIStatusBar *)statusBar;
- (void)setVisibility:(NSNotification *)notification;
@end

@interface SBUIProudLockIconView : UIView
- (void)setVisibility:(NSNotification *)notification;
@end

@interface SBFLockScreenDateView : UIView
- (void)setVisibility:(NSNotification *)notification;
- (void)shift;
- (void)resetShift;
@end

@interface CSAdjunctItemView : UIView
- (void)setVisibility:(NSNotification *)notification;
@end

@interface UICoverSheetButton : UIControl
@end

@interface CSQuickActionsButton : UICoverSheetButton
- (void)setVisibility:(NSNotification *)notification;
@end

@interface CSHomeAffordanceView : UIView
- (void)setVisibility:(NSNotification *)notification;
@end

@interface CSTeachableMomentsContainerView : UIView
- (void)setVisibility:(NSNotification *)notification;
@end