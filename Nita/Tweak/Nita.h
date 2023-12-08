#import <UIKit/UIKit.h>
#import "libpddokdo.h"
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;

BOOL enabled = NO;

NSString* condition = nil;
NSString* weatherString = nil;

// position
BOOL replaceCarrierSwitch = YES;
BOOL replaceTimeSwitch = NO;
BOOL alongsideTimeSwitch = NO;

// visibility
BOOL showEmojiSwitch = YES;
BOOL showTemperatureSwitch = NO;

// miscellaneous
BOOL hideBreadcrumbsSwitch = YES;

@interface _UIStatusBarStringView : UIView
- (void)getEmojis;
@end

@interface _UIStatusBarDisplayItem : NSObject
@property (nonatomic, weak, readonly) id item;
@end

@interface WACurrentForecast : NSObject
@property(assign, nonatomic)long long conditionCode;
- (void)setConditionCode:(long long)arg1;
@end

@interface WAForecastModel : NSObject
@property(nonatomic,retain) WACurrentForecast* currentConditions;
@end

@interface WALockscreenWidgetViewController : UIViewController
- (WAForecastModel *)currentForecastModel;
@end

@interface PDDokdo (Nita)
@property(nonatomic, retain, readonly)WALockscreenWidgetViewController* weatherWidget;
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (BOOL)isLockScreenVisible;
@end