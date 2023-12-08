#import <UIKit/UIKit.h>
#import "TVSettingsKit/TSKViewController.h"
#import "TVSettingsKit/TSKSettingGroup.h"
#import "TVSettingsKit/TSKVibrantImageView.h"
#import "TVSettingsKit/TSKPreviewViewController.h"

@interface TVSettingsPreferenceFacade : NSObject
{
    NSString* _domain;
    NSString* _containerPath;
}
@property(readonly, copy, nonatomic)NSString* containerPath;
@property(readonly, copy, nonatomic)NSString* domain;
- (id)valueForUndefinedKey:(id)arg1;
- (void)setValue:(id)arg1 forUndefinedKey:(id)arg2;
- (id)_initWithDomain:(id)arg1 containerPath:(id)arg2 notifyChanges:(_Bool)arg3;
- (id)initWithDomain:(id)arg1 notifyChanges:(_Bool)arg2;
- (id)initWithDomain:(id)arg1 containerPath:(id)arg2;
@end

@interface TVSPreferences : NSObject
+ (id)preferencesWithDomain:(id)arg1;
- (_Bool)setBool:(_Bool)arg1 forKey:(id)arg2;
- (_Bool)boolForKey:(id)arg1 defaultValue:(_Bool)arg2;
- (_Bool)boolForKey:(id)arg1;
- (_Bool)setDouble:(double)arg1 forKey:(id)arg2;
- (double)doubleForKey:(id)arg1 defaultValue:(double)arg2;
- (double)doubleForKey:(id)arg1;
- (_Bool)setFloat:(float)arg1 forKey:(id)arg2;
- (float)floatForKey:(id)arg1 defaultValue:(float)arg2;
- (float)floatForKey:(id)arg1;
- (_Bool)setInteger:(int)arg1 forKey:(id)arg2;
- (int)integerForKey:(id)arg1 defaultValue:(int)arg2;
- (int)integerForKey:(id)arg1;
- (id)stringForKey:(id)arg1;
- (_Bool)setObject:(id)arg1 forKey:(id)arg2;
- (id)objectForKey:(id)arg1;
- (_Bool)synchronize;
- (id)initWithDomain:(id)arg1;
@end

@interface TSKTextInputViewController : UIViewController
@property(assign,nonatomic)BOOL supportsPasswordSharing;
@property(nonatomic,retain)NSString* networkName;
@property(assign,nonatomic)BOOL secureTextEntry;
@property(nonatomic,copy)NSString* headerText;
@property(nonatomic,copy)NSString* messageText;
@property(nonatomic,copy)NSString* initialText;
@property(assign,nonatomic)long long capitalizationType;
@property(assign,nonatomic)long long keyboardType;
@property(nonatomic,retain)TSKSettingItem* editingItem;
@property(assign,nonatomic,weak)id<TSKSettingItemEditingControllerDelegate> editingDelegate;
@end

@interface BLTRootListController : TSKViewController
- (void)resetPrompt;
- (void)resetPreferences;
- (void)respring;
- (void)respringUtil;
@end

@interface NSTask : NSObject
@property(copy)NSArray* arguments;
@property(copy)NSString* launchPath;
- (void)launch;
@end
