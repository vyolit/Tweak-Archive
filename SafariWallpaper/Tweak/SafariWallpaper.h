#import "GcUniversal/GcImagePickerUtils.h"
#import "GcUniversal/GcColorPickerUtils.h"
#import <Kitten/libKitten.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

BOOL isDarkWallpaper = YES;

// wallpaper
NSString* wallpaperAlphaValue = @"1.0";
NSString* blurModeValue = @"0";
NSString* blurAmountValue = @"1";

// bookmarks
BOOL hideBookmarksSwitch = NO;
BOOL hideBookmarkHeadersSwitch = NO;
BOOL hideBookmarkTitlesSwitch = NO;
BOOL useDynamicLabelColorSwitch = YES;
BOOL useCustomLabelColorSwitch = NO;
NSString* customLabelColorValue = @"000000";

// miscellaneous
BOOL automaticFocusOnBlankTabSwitch = NO;

@interface CatalogViewController : UIViewController
@property(nonatomic, retain)UIImageView* safariWallpaperWallpaperView;
@property(nonatomic, retain)UIImage* safariWallpaperWallpaper;
@property(nonatomic, retain)UIBlurEffect* safariWallpaperBlur;
@property(nonatomic, retain)UIVisualEffectView* safariWallpaperBlurView;
@end

@interface BookmarkFavoritesGridView : UIView
@end

@interface VibrantLabelView : UILabel
@end

@interface BookmarkFavoritesGridSectionHeaderView : UIView
- (void)updateDynamicLabelColor;
@end

@interface BookmarkFavoriteView : UIView
- (void)updateDynamicLabelColor;
@end

@interface _SFNavigationBar : UINavigationBar
- (void)_URLTapped:(id)arg1;
@end

@interface TabDocument : NSObject
@end