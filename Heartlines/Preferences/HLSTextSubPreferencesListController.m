#import "HLSTextSubPreferencesListController.h"

@implementation HLSTextSubPreferencesListController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.appearanceSettings = [HLSAppearanceSettings new];
    self.hb_appearanceSettings = [self appearanceSettings];
    

    self.preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.heartlinespreferences"];


    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[self blur]];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [[self blurView] setFrame:[[self view] bounds]];
    [[self blurView] setAlpha:1];
    [[self view] addSubview:[self blurView]];

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self blurView] setAlpha:0];
    } completion:nil];

}

- (id)specifiers {

    return _specifiers;

}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {

    NSString* sub = [specifier propertyForKey:@"HLSSub"];
    NSString* title = [specifier name];

    _specifiers = [self loadSpecifiersFromPlistName:sub target:self];

    [self setTitle:title];
    [[self navigationItem] setTitle:title];

}

- (void)setSpecifier:(PSSpecifier *)specifier {

    [self loadFromSpecifier:specifier];
    [super setSpecifier:specifier];

}

- (BOOL)shouldReloadSpecifiersOnResume {

    return false;

}

- (void)showFontPicker {
    
    self.fontPicker = [UIFontPickerViewController new];
    [[self fontPicker] setDelegate:self];
    [self presentViewController:[self fontPicker] animated:YES completion:nil];
    
}

- (void)fontPickerViewControllerDidPickFont:(UIFontPickerViewController *)viewController {
    
    UIFontDescriptor* descriptor = [viewController selectedFontDescriptor];
    UIFont* font = [UIFont fontWithDescriptor:descriptor size:17];

    [[self preferences] setObject:[font familyName] forKey:@"customFont"];
    
}

@end