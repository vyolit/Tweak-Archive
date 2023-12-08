#import "DVURootListController.h"

@implementation DVUAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed: 0.30 green: 0.58 blue: 0.58 alpha: 1.00];

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

    return [UIColor colorWithRed: 0.30 green: 0.58 blue: 0.58 alpha: 1.00];

}

- (BOOL)translucentNavigationBar {

    return YES;

}

@end