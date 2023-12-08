#include "BLTRootListController.h"

UIBlurEffect* blur  = nil;
UIVisualEffectView* blurView = nil;

TSKSettingItem* enableSwitch = nil;
TSKSettingItem* useImageWallpaperSwitch = nil;
TSKSettingItem* useVideoWallpaperSwitch = nil;
TSKSettingItem* respringButton = nil;
TSKSettingItem* resetButton = nil;

#define PLIST_PATH @"/var/mobile/Library/Preferences/love.litten.balletpreferences.plist"
inline NSString* GetPrefVal(NSString* key){
    return [[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key];
}

@implementation BLTRootListController

- (id)loadSettingGroups {
    
    id facade = [[NSClassFromString(@"TVSettingsPreferenceFacade") alloc] initWithDomain:@"love.litten.balletpreferences" notifyChanges:TRUE];
    
    NSMutableArray* _backingArray = [NSMutableArray new];
    
    // enable switch
    enableSwitch = [TSKSettingItem toggleItemWithTitle:@"Enabled" description:@"" representedObject:facade keyPath:@"Enabled" onTitle:@"Enabled" offTitle:@"Disabled"];
    
    TSKSettingGroup* enableGroup = [TSKSettingGroup groupWithTitle:@"Enable" settingItems:@[enableSwitch]];
    [_backingArray addObject:enableGroup];

    // settings
    useImageWallpaperSwitch = [TSKSettingItem toggleItemWithTitle:@"Use image wallpaper" description:@"" representedObject:facade keyPath:@"useImageWallpaper" onTitle:@"Enabled" offTitle:@"Disabled"];
    useVideoWallpaperSwitch = [TSKSettingItem toggleItemWithTitle:@"Use video wallpaper" description:@"" representedObject:facade keyPath:@"useVideoWallpaper" onTitle:@"Enabled" offTitle:@"Disabled"];
    
    TSKSettingGroup* settingsGroup = [TSKSettingGroup groupWithTitle:@"Wallpaper" settingItems:@[useImageWallpaperSwitch, useVideoWallpaperSwitch]];
    [_backingArray addObject:settingsGroup];

    // other options
    respringButton = [TSKSettingItem actionItemWithTitle:@"Respring" description:@"" representedObject:facade keyPath:PLIST_PATH target:self action:@selector(respring)];
    resetButton = [TSKSettingItem actionItemWithTitle:@"Reset Preferences" description:@"" representedObject:facade keyPath:PLIST_PATH target:self action:@selector(resetPrompt)];
    
    TSKSettingGroup* otherOptionsGroup = [TSKSettingGroup groupWithTitle:@"Other Options" settingItems:@[respringButton, resetButton]];
    [_backingArray addObject:otherOptionsGroup];

    [self setValue:_backingArray forKey:@"_settingGroups"];

    // gradient and custom icon
    NSString* imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"preferencesIcon" ofType:@"png"];
    UIImage* icon = [UIImage imageWithContentsOfFile:imagePath];
    if (icon != nil) {
        UIImageView* iconView = [[UIImageView alloc] initWithImage:icon];
        [iconView setContentMode:UIViewContentModeScaleAspectFit];
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = 5.0;
        [iconView setAlpha:0.0];
        [iconView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];

        [iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [iconView.widthAnchor constraintEqualToConstant:512].active = YES;
        [iconView.heightAnchor constraintEqualToConstant:512].active = YES;
        if (![iconView isDescendantOfView:[self view]]) [[self view] addSubview:iconView];
        [iconView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-425].active = YES;
        [iconView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-32].active = YES;

        [UIView animateWithDuration:0.5 delay:0.8 usingSpringWithDamping:300 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [iconView setAlpha:1.0];
            [iconView setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];


        CAGradientLayer* gradient = [CAGradientLayer new];
        [gradient setFrame:[[self view] bounds]];
        [gradient setStartPoint:CGPointMake(0.0, 0.5)];
        [gradient setEndPoint:CGPointMake(1.0, 0.5)];
        [gradient setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed: 1.00 green: 0.92 blue: 0.94 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.72 blue: 0.79 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.52 blue: 0.64 alpha: 1.00] CGColor], nil]];
        [gradient setLocations:[NSArray arrayWithObjects:@(-0.5), @(1.5), nil]];
            
        CABasicAnimation* animation = [CABasicAnimation new];
        [animation setKeyPath:@"colors"];
        [animation setFromValue:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed: 1.00 green: 0.92 blue: 0.94 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.72 blue: 0.79 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.52 blue: 0.64 alpha: 1.00] CGColor], nil]];
        [animation setToValue:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed: 1.00 green: 0.52 blue: 0.64 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.72 blue: 0.79 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.92 blue: 0.94 alpha: 1.00] CGColor], nil]];
        [animation setDuration:5.0];
        [animation setAutoreverses:YES];
        [animation setRepeatCount:INFINITY];

        [gradient addAnimation:animation forKey:nil];
        [[[self view] layer] insertSublayer:gradient atIndex:0];
    }

    
    return _backingArray;
    
}

- (void)resetPrompt {

    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Ballet"
	message:@"Do you really want to reset your preferences?"
	preferredStyle:UIAlertControllerStyleActionSheet];
	
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Yaw" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        [self resetPreferences];
	}];

	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Naw" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:confirmAction];
	[resetAlert addAction:cancelAction];

	[self presentViewController:resetAlert animated:YES completion:nil];

}

- (void)resetPreferences {

    [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/love.litten.balletpreferences.plist" error:nil];
    
    [self respring];

}

- (void)respring {

    blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [blurView setFrame:self.view.bounds];
    [blurView setAlpha:0.0];
    [[self view] addSubview:blurView];

    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [blurView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self respringUtil];
    }];

}

- (void)respringUtil {

    NSTask* task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [task launch];

}

- (TVSPreferences *)ourPreferences {

    return [TVSPreferences preferencesWithDomain:@"love.litten.balletpreferences"];

}

- (void)showViewController:(TSKSettingItem *)item {

    TSKTextInputViewController* testObject = [TSKTextInputViewController new];
    
    testObject.headerText = @"Ballet";
    testObject.initialText = [[self ourPreferences] stringForKey:item.keyPath];
    
    if ([testObject respondsToSelector:@selector(setEditingDelegate:)])
        [testObject setEditingDelegate:self];

    [testObject setEditingItem:item];
    [self.navigationController pushViewController:testObject animated:TRUE];

}

- (void)editingController:(id)arg1 didCancelForSettingItem:(TSKSettingItem *)arg2 {

    [super editingController:arg1 didCancelForSettingItem:arg2];

}

- (void)editingController:(id)arg1 didProvideValue:(id)arg2 forSettingItem:(TSKSettingItem *)arg3 {

    [super editingController:arg1 didProvideValue:arg2 forSettingItem:arg3];
    
    TVSPreferences* preferences = [TVSPreferences preferencesWithDomain:@"love.litten.balletpreferences"];
    
    [preferences setObject:arg2 forKey:arg3.keyPath];
    [preferences synchronize];
    
}

- (id)previewForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TSKPreviewViewController* item = [super previewForItemAtIndexPath:indexPath];
    
    NSString* imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"icon" ofType:@"png"];
    UIImage* icon = [UIImage imageWithContentsOfFile:imagePath];
    if (icon != nil) {
        TSKVibrantImageView* imageView = [[TSKVibrantImageView alloc] initWithImage:icon];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 5.0;
        [item setContentView:imageView];
    }

    return item;
    
}

@end
