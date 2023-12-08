#import "NTARootListController.h"

@implementation NTAAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed:0.76 green:0.67 blue:1 alpha:1];

}

- (UIStatusBarStyle)statusBarStyle {

    return UIStatusBarStyleLightContent;

}

- (UIColor *)navigationBarTitleColor {

    return [UIColor whiteColor];

}

- (UIColor *)navigationBarTintColor {

    return [UIColor whiteColor];

}

- (UIColor *)tableViewCellSeparatorColor {

    return [UIColor colorWithWhite:0 alpha:0];

}

- (UIColor *)navigationBarBackgroundColor {

    return [UIColor colorWithRed:0.76 green:0.67 blue:1 alpha:1];

}

- (BOOL)translucentNavigationBar {

    return YES;

}

@end