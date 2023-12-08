#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <AppList/AppList.h>
#import "libpddokdo.h"
#import "GcUniversal/GcColorPickerUtils.h"
#import <Cephei/HBPreferences.h>
#import <sys/utsname.h>

HBPreferences* preferences = nil;
HBPreferences* notesPreferences = nil;

BOOL enabled = NO;

BOOL shouldAnimateIn = YES;
int availableEvents = 0;
int availableReminders = 0;
int availableAlarms = 0;

// upcoming & notes
BOOL showIconsSwitch = YES;
NSString* upcomingNotesXAxisValue = @"100";
NSString* upcomingNotesYAxisValue = @"100";
NSString* upcomingNotesAnimationValue = @"1";
BOOL showEventsSwitch = YES;
BOOL showRemindersSwitch = YES;
BOOL showAlarmsSwitch = YES;
NSString* upcomingHeaderTitleValue = @"Upcoming";
NSString* upcomingHeaderColorValue = @"ffffffff";
NSString* upcomingHeaderAlphaValue = @"1";
NSString* eventsTitleValue = @"Events";
NSString* eventsRangeValue = @"3";
NSString* eventsAmountValue = @"2";
NSString* eventsTitleColorValue = @"ffffffff";
NSString* eventsListColorValue = @"ffffffff";
NSString* eventsTitleAlphaValue = @"0.9";
NSString* eventsListAlphaValue = @"0.8";
NSString* remindersTitleValue = @"Reminders";
NSString* remindersRangeValue = @"3";
NSString* remindersAmountValue = @"5";
NSString* remindersTitleColorValue = @"ffffffff";
NSString* remindersListColorValue = @"ffffffff";
NSString* remindersTitleAlphaValue = @"0.9";
NSString* remindersListAlphaValue = @"0.8";
NSString* alarmsTitleValue = @"Alarms";
NSString* alarmsAmountValue = @"1";
NSString* alarmsTitleColorValue = @"ffffffff";
NSString* alarmsListColorValue = @"ffffffff";
NSString* alarmsTitleAlphaValue = @"0.9";
NSString* alarmsListAlphaValue = @"0.8";
BOOL showNotesSwitch = YES;
NSString* notesHeaderTitleValue = @"Notes";
NSString* notesAnimationValue = @"1";
NSString* notesHeaderColorValue = @"ffffffff";
NSString* notesHeaderAlphaValue = @"1";
NSString* notesTextColorValue = @"ffffffff";
NSString* notesTextAlphaValue = @"1";
NSString* notes = @"";

// weather
BOOL showWeatherSwitch = YES;
NSString* weatherXAxisValue = @"100";
NSString* weatherYAxisValue = @"100";
NSString* weatherAnimationValue = @"1";
NSString* weatherIconColorValue = @"ffffffff";
NSString* weatherIconAlphaValue = @"1";
NSString* weatherTemperatureColorValue = @"ffffffff";
NSString* weatherTemperatureAlphaValue = @"0.9";
NSString* weatherConditionColorValue = @"ffffffff";
NSString* weatherConditionAlphaValue = @"0.8";

@interface CCUIModularControlCenterOverlayViewController : UIViewController
@property(nonatomic, retain)UIView* yunaView;
@property(nonatomic, retain)UILabel* upcomingHeaderLabel;
@property(nonatomic, retain)UIImageView* upcomingHeaderIcon;
@property(nonatomic, retain)UILabel* eventsTitleLabel;
@property(nonatomic, retain)UITextView* eventsList;
@property(nonatomic, retain)UILabel* remindersTitleLabel;
@property(nonatomic, retain)UITextView* remindersList;
@property(nonatomic, retain)UILabel* alarmsTitleLabel;
@property(nonatomic, retain)UITextView* alarmsList;
@property(nonatomic, retain)UILabel* notesHeaderLabel;
@property(nonatomic, retain)UIImageView* notesHeaderIcon;
@property(nonatomic, retain)UITextView* notesView;
@property(nonatomic, retain)UIView* weatherIconView;
@property(nonatomic, retain)UIImageView* weatherIcon;
@property(nonatomic, retain)UILabel* weatherTemperatureLabel;
@property(nonatomic, retain)UILabel* weatherConditionLabel;
- (void)presentYunaWithUpcomingAndNotesAnimation:(BOOL)bouncy andWeatherAnimation:(BOOL)fancy;
- (void)dismissYunaWithUpcomingAndNotesAnimation:(BOOL)bouncy andWeatherAnimation:(BOOL)fancy;
- (void)saveNotes;
- (void)fetchEvents;
- (void)fetchReminders;
- (void)fetchAlarms;
- (void)updateWeather;
@end

@interface MTAlarm : NSObject
@property(nonatomic, readonly)NSDate* nextFireDate;
@end

@interface MTMutableAlarm : MTAlarm
@end

@interface MTAlarmCache : NSObject
- (NSMutableArray *)orderedAlarms;
- (void)setOrderedAlarms:(NSMutableArray *)arg1;
@end

@interface MTAlarmManager : NSObject
@property(nonatomic, retain)MTAlarmCache* cache;
@end

@interface SBScheduledAlarmObserver : NSObject {
    MTAlarmManager* _alarmManager;
}
+ (id)sharedInstance;
@end

@interface WACurrentForecast : NSObject
@property(assign, nonatomic)long long conditionCode;
- (void)setConditionCode:(long long)arg1;
@end

@interface WAForecastModel : NSObject
@property(nonatomic, retain)WACurrentForecast* currentConditions;
@end

@interface WALockscreenWidgetViewController : UIViewController
- (WAForecastModel *)currentForecastModel;
@end

@interface PDDokdo (Yuna)
@property(nonatomic, retain, readonly)WALockscreenWidgetViewController* weatherWidget;
@end



@implementation UIImage (scale)

- (UIImage *)scaleImageToSize:(CGSize)newSize {
  
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / self.size.width;
    CGFloat aspectHeight = newSize.height / self.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    
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