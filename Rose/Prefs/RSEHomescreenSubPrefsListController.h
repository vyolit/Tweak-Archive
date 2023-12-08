#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSEditableTableCell.h>

@interface RSEAppearanceSettings : HBAppearanceSettings
@end

@interface RSEHomescreenSubPrefsListController : HBListController
@property(nonatomic, retain)UISwitch* enableSwitch;
@property(nonatomic, retain)UILabel* titleLabel;
- (void)toggleState;
- (void)setEnableSwitchState;
- (void)setCellForRowAtIndexPath:(NSIndexPath *)indexPath enabled:(BOOL)enabled;
@end

@interface PSEditableTableCell (Interface)
- (id)textField;
@end