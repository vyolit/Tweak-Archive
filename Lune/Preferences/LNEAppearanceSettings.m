#import "LNERootListController.h"

@implementation LNEAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed: 0.71 green: 0.73 blue: 0.99 alpha: 1.00];

}

- (UIColor *)statusBarTintColor {

    return [UIColor whiteColor];

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

    return [UIColor colorWithRed: 0.71 green: 0.73 blue: 0.99 alpha: 1.00];

}

- (BOOL)translucentNavigationBar {

    return YES;

}

@end