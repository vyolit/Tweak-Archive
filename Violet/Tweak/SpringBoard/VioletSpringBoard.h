#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

UIImage* currentArtwork = nil;

// lock screen
BOOL lockscreenArtworkBackgroundSwitch = NO;
NSString* lockscreenArtworkBlurMode = @"0";
NSString* lockscreenArtworkBlurAmountValue = @"1.0";
NSString* lockscreenArtworkOpacityValue = @"1.0";
NSString* lockscreenArtworkDimValue = @"0.0";
BOOL lockscreenArtworkBackgroundTransitionSwitch = NO;
BOOL lockscreenPlayerArtworkBackgroundSwitch = NO;
NSString* lockscreenPlayerArtworkBlurMode = @"0";
NSString* lockscreenPlayerArtworkBlurAmountValue = @"1.0";
NSString* lockscreenPlayerArtworkOpacityValue = @"1.0";
NSString* lockscreenPlayerArtworkDimValue = @"0.0";
BOOL lockscreenPlayerArtworkBackgroundTransitionSwitch = NO;
NSString* lockscreenPlayerStyleOverrideValue = @"0";

UIImageView* lockScreenArtworkBackgroundImageView = nil;
UIVisualEffectView* lockScreenBlurView = nil;
UIBlurEffect* lockScreenBlur = nil;
UIView* lockScreenDimView = nil;
UIImageView* lockScreenPlayerArtworkBackgroundImageView = nil;
UIVisualEffectView* lockScreenPlayerBlurView = nil;
UIBlurEffect* lockScreenPlayerBlur = nil;
UIView* lockScreenPlayerDimView = nil;

// home screen
BOOL homescreenArtworkBackgroundSwitch = NO;
NSString* homescreenArtworkBlurMode = @"0";
NSString* homescreenArtworkBlurAmountValue = @"1.0";
NSString* homescreenArtworkOpacityValue = @"1.0";
NSString* homescreenArtworkDimValue = @"0.0";
BOOL homescreenArtworkBackgroundTransitionSwitch = NO;
BOOL zoomedViewSwitch = YES;

UIImageView* homeScreenArtworkBackgroundImageView = nil;
UIVisualEffectView* homeScreenBlurView = nil;
UIBlurEffect* homeScreenBlur = nil;
UIView* homeScreenDimView = nil;

// control center
BOOL controlCenterArtworkBackgroundSwitch = NO;
NSString* controlCenterArtworkBlurMode = @"0";
NSString* controlCenterArtworkBlurAmountValue = @"1.0";
NSString* controlCenterArtworkOpacityValue = @"1.0";
NSString* controlCenterArtworkDimValue = @"1.0";
BOOL controlCenterArtworkBackgroundTransitionSwitch = NO;
BOOL controlCenterModuleArtworkBackgroundSwitch = NO;
NSString* controlCenterModuleArtworkBlurMode = @"0";
NSString* controlCenterModuleArtworkBlurAmountValue = @"1.0";
NSString* controlCenterModuleArtworkOpacityValue = @"1.0";
NSString* controlCenterModuleArtworkDimValue = @"1.0";
BOOL controlCenterModuleArtworkBackgroundTransitionSwitch =  NO;

UIImageView* controlCenterArtworkBackgroundImageView = nil;
UIVisualEffectView* controlCenterBlurView = nil;
UIBlurEffect* controlCenterBlur = nil;
UIView* controlCenterDimView = nil;
UIImageView* controlCenterModuleArtworkBackgroundImageView = nil;
UIVisualEffectView* controlCenterModuleBlurView = nil;
UIBlurEffect* controlCenterModuleBlur = nil;
UIView* controlCenterModuleDimView = nil;

@interface CSCoverSheetViewController : UIViewController
@end

@interface MRPlatterViewController : UIViewController
@property(nonatomic, copy)NSString* label;
- (void)setMaterialViewBackground;
- (void)clearMaterialViewBackground;
@end

@interface MRUNowPlayingViewController : UIViewController
@property(assign, nonatomic)long long context;
- (void)setMaterialViewBackground;
- (void)clearMaterialViewBackground;
@end

@interface CSAdjunctItemView : UIView
@end

@interface MTMaterialView : UIView
@end

@interface CALayer (Violet)
@property(assign)BOOL continuousCorners;
@end

@interface CABackdropLayer : CALayer
@property(assign)double scale;
- (void)mt_setColorMatrixDrivenOpacity:(double)arg1 removingIfIdentity:(BOOL)arg2;
@end

@interface MTMaterialLayer : CABackdropLayer
@end

@interface UIView (Violet)
@property(nonatomic, assign, readwrite)MTMaterialView* backgroundMaterialView;
@end

@interface CSNotificationAdjunctListViewController : UIViewController
@end

@interface SBIconController : UIViewController
@end

@interface CCUIModularControlCenterOverlayViewController : UIViewController
@end

@interface CCUIContentModuleContentContainerView : UIView
@property(assign, nonatomic)double compactContinuousCornerRadius;
@end

@interface CCUIContentModuleContainerViewController : UIViewController
@property(nonatomic, retain)UIViewController* contentViewController;
@property(nonatomic, readonly)CCUIContentModuleContentContainerView* moduleContentView;
- (NSString *)moduleIdentifier;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPaused;
- (BOOL)isPlaying;
- (void)setNowPlayingInfo:(id)arg1;
@end
