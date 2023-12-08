#include "RSERootListController.h"
#import "../Tweak/Rose.h"

UIBlurEffect* blur;
UIVisualEffectView* blurView;

BOOL enabled = NO;
BOOL enableTapticEngineSwitch;
BOOL enableHapticEngineSwitch;
BOOL enableLegacyEngineSwitch;

UIImpactFeedbackGenerator* gen;

@implementation RSERootListController

- (instancetype)init {

    self = [super init];

    if (self) {
        RSEAppearanceSettings *appearanceSettings = [[RSEAppearanceSettings alloc] init];
        self.hb_appearanceSettings = appearanceSettings;
        self.enableSwitch = [[UISwitch alloc] init];
        self.enableSwitch.onTintColor = [UIColor colorWithRed: 0.64 green: 0.49 blue: 1.00 alpha: 1.00];
        [self.enableSwitch addTarget:self action:@selector(toggleState) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* switchy = [[UIBarButtonItem alloc] initWithCustomView: self.enableSwitch];
        self.navigationItem.rightBarButtonItem = switchy;

        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"1.0.9";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/RosePrefs.bundle/icon@2x.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 0.0;
        [self.navigationItem.titleView addSubview:self.iconView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];
    }

    return self;

}

- (NSArray *)specifiers {

	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
        
	}

	return _specifiers;
    
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/RosePrefs.bundle/Banner.png"];
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerImageView.clipsToBounds = YES;

    [self.headerView addSubview:self.headerImageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    _table.tableHeaderView = self.headerView;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 0.62 green: 0.67 blue: 0.98 alpha: 1.00];
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationController.navigationBar.translucent = YES;

    self.enableSwitch.enabled = YES;

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [self setEnableSwitchState];

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];

    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];

    }
    
    if (offsetY > 0) offsetY = 0;
    self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);

}

- (void)toggleState {

    [[self enableSwitch] setEnabled:NO];

    NSString* path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/love.litten.rosepreferences.plist"];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSSet* allKeys = [NSSet setWithArray:[dictionary allKeys]];
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.rosepreferences"];
    
    if (!([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/love.litten.rosepreferences.plist"])) {
        enabled = YES;
        [preferences setBool:enabled forKey:@"Enabled"];
        [self respring];
    } else if (!([allKeys containsObject:@"Enabled"])) {
        enabled = YES;
        [preferences setBool:enabled forKey:@"Enabled"];
        [self respring];
    } else if ([[preferences objectForKey:@"Enabled"] isEqual:@(NO)]) {
        enabled = YES;
        [preferences setBool:enabled forKey:@"Enabled"];
        [self respring];
    } else if ([[preferences objectForKey:@"Enabled"] isEqual:@(YES)]) {
        enabled = NO;
        [preferences setBool:enabled forKey:@"Enabled"];
        [self respring];
    }

}

- (void)setEnableSwitchState {

    NSString* path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/love.litten.rosepreferences.plist"];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSSet* allKeys = [NSSet setWithArray:[dictionary allKeys]];
    HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.rosepreferences"];
    
    if (!([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/love.litten.rosepreferences.plist"]))
        [[self enableSwitch] setOn:NO animated:YES];
    else if (!([allKeys containsObject:@"Enabled"]))
        [[self enableSwitch] setOn:NO animated:YES];
    else if ([[preferences objectForKey:@"Enabled"] isEqual:@(YES)])
        [[self enableSwitch] setOn:YES animated:YES];
    else if ([[preferences objectForKey:@"Enabled"] isEqual:@(NO)])
        [[self enableSwitch] setOn:NO animated:YES];

}

- (void)resetPrompt {

    UIAlertController *resetAlert = [UIAlertController alertControllerWithTitle:@"Rose"
	message:@"Do You Really Want To Reset Your Preferences?"
	preferredStyle:UIAlertControllerStyleActionSheet];
	
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Yaw" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [self resetPreferences];
	}];

	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Naw" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:confirmAction];
	[resetAlert addAction:cancelAction];

	[self presentViewController:resetAlert animated:YES completion:nil];

}

- (void)resetPreferences {

    HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.rosepreferences"];
    [preferences removeAllObjects];

    [self respring];

}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier{

	[super setPreferenceValue:value specifier:specifier];
	
    if ([specifier.properties[@"key"] isEqualToString:@"TapticStrength"] && [value isEqual:@(0)]) {
        UIImpactFeedbackGenerator* gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
		[gen prepare];
        [gen impactOccurred];
    } else if ([specifier.properties[@"key"] isEqualToString:@"TapticStrength"] && [value isEqual:@(1)]) {
        UIImpactFeedbackGenerator* gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
		[gen prepare];
        [gen impactOccurred];
    } else if ([specifier.properties[@"key"] isEqualToString:@"TapticStrength"] && [value isEqual:@(2)]) {
        UIImpactFeedbackGenerator* gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
		[gen prepare];
        [gen impactOccurred];
    } else if ([specifier.properties[@"key"] isEqualToString:@"TapticStrength"] && [value isEqual:@(3)]) {
        UIImpactFeedbackGenerator* gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleSoft];
		[gen prepare];
        [gen impactOccurred];
    } else if ([specifier.properties[@"key"] isEqualToString:@"TapticStrength"] && [value isEqual:@(4)]) {
        UIImpactFeedbackGenerator* gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleRigid];
		[gen prepare];
        [gen impactOccurred];
    } else if ([specifier.properties[@"key"] isEqualToString:@"HapticStrength"] && [value isEqual:@(0)]) {
        AudioServicesPlaySystemSound(1519);
    } else if ([specifier.properties[@"key"] isEqualToString:@"HapticStrength"] && [value isEqual:@(1)]) {
        AudioServicesPlaySystemSound(1520);
    } else if ([specifier.properties[@"key"] isEqualToString:@"HapticStrength"] && [value isEqual:@(2)]) {
        AudioServicesPlaySystemSound(1521);
    }

}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (event.type == UIEventSubtypeMotionShake) {
        HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.rosepreferences"];
        enableTapticEngineSwitch = [[preferences objectForKey:@"enableTapticEngine"] boolValue];
        enableHapticEngineSwitch = [[preferences objectForKey:@"enableHapticEngine"] boolValue];
        enableLegacyEngineSwitch = [[preferences objectForKey:@"enableLegacyEngine"] boolValue];
        int tapticLVL = [[preferences objectForKey:@"TapticStrength"] intValue];
		int hapticLVL = [[preferences objectForKey:@"HapticStrength"] intValue];
		int selectedLegacyMode = [[preferences objectForKey:@"LegacyStrength"] intValue];
		double customLegacyDuration = [[preferences objectForKey:@"customLegacyDuration"] doubleValue];
		double customLegacyStrength = [[preferences objectForKey:@"customLegacyStrength"] doubleValue];

        if (enableTapticEngineSwitch || enableHapticEngineSwitch) {
            [libRose prepareForHaptic:enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [libRose prepareForHaptic:enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [libRose prepareForHaptic:enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
                });
            });
        } else if (enableLegacyEngineSwitch && selectedLegacyMode == 0) {
            [libRose prepareLegacyFeedback:0.025 intensivity:0.05 count:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [libRose prepareLegacyFeedback:0.025 intensivity:0.05 count:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [libRose prepareLegacyFeedback:0.025 intensivity:0.05 count:1];
                });
            });
        } else if (enableLegacyEngineSwitch && selectedLegacyMode != 0) {
            [libRose prepareLegacyFeedback:customLegacyDuration intensivity:customLegacyStrength count:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [libRose prepareLegacyFeedback:customLegacyDuration intensivity:customLegacyStrength count:1];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [libRose prepareLegacyFeedback:customLegacyDuration intensivity:customLegacyStrength count:1];
                    });
            });
        }
    }

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

    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/sbreload"];

    [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Rose"]];

    [task launch];

}

@end