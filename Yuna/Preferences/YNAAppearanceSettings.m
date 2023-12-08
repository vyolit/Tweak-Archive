#import "YNARootListController.h"

@implementation YNAAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed:0.04 green:0.56 blue:0.37 alpha:1.00];

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

    return [UIColor clearColor];

}

- (UIColor *)navigationBarBackgroundColor {

    return [UIColor colorWithRed:0.04 green:0.56 blue:0.37 alpha:1.00];

}

- (BOOL)translucentNavigationBar {

    return YES;

}

@end