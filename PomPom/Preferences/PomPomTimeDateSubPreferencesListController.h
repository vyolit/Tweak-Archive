//
//  PomPomTimeDateSubPreferencesListController.h
//  PomPom
//
//  Created by Alexandra (@Traurige)
//

#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

@interface PomPomAppearanceSettings : HBAppearanceSettings
@end

@interface PomPomTimeDateSubPreferencesListController : HBListController
@property(nonatomic, retain)PomPomAppearanceSettings* appearanceSettings;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@end
