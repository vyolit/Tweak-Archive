//
//  PomPomAppearanceSettings.m
//  PomPom
//
//  Created by Alexandra (@Traurige)
//

#import "PomPomRootListController.h"

@implementation PomPomAppearanceSettings
- (UIColor *)tintColor {
    return [UIColor colorWithRed:0.94 green:0.6 blue:0.7 alpha:1];
}

- (UIStatusBarStyle)statusBarStyle {
    return UIStatusBarStyleDarkContent;
}

- (UIColor *)navigationBarTitleColor {
    return [UIColor whiteColor];
}

- (UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)tableViewCellSeparatorColor {
    return [[UIColor whiteColor] colorWithAlphaComponent:0];
}

- (UIColor *)navigationBarBackgroundColor {
    return [UIColor colorWithRed:0.94 green:0.6 blue:0.7 alpha:1];
}

- (BOOL)translucentNavigationBar {
    return YES;
}
@end
