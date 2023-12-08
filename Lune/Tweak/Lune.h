#import <MediaRemote/MediaRemote.h>
#import <Kitten/libKitten.h>
#import "GcUniversal/GcColorPickerUtils.h"
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

BOOL isDNDActive = NO;
NSData* lastArtworkData = nil;
UIColor* backgroundArtworkColor = nil;

// icon
BOOL enableIconSwitch = YES;
NSString* xPositionValue = @"150";
NSString* yPositionValue = @"100";
NSString* sizeValue = @"50";
NSString* iconValue = @"0";
NSString* customColorValue = @"FFFFFF";
BOOL glowSwitch = YES;
BOOL useCustomGlowColorSwitch = NO;
NSString* customGlowColorValue = @"FFFFFF";
NSString* glowRadiusValue = @"10";
NSString* glowAlphaValue = @"1";
BOOL useCustomColorSwitch = NO;
BOOL useArtworkBasedColorSwitch = YES;

// background
BOOL darkenBackgroundSwitch = YES;
BOOL alwaysDarkenBackgroundSwitch = NO;
NSString* darkeningAmountValue = @"0.5";

// status bar
BOOL showStatusBarIconSwitch = NO;

// banner
BOOL hideDNDBannerSwitch = NO;
BOOL indicatorPillSwitch = NO;

@interface CSCoverSheetView : UIView
@property(nonatomic, retain)UIImageView* luneView;
@property(nonatomic, retain)UIView* luneDimView;
- (void)toggleLuneVisibility:(BOOL)visible;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (void)setNowPlayingInfo:(id)arg1;
@end