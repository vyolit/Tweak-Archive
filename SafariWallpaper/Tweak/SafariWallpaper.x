#import "SafariWallpaper.h"

_SFNavigationBar* navigationBar = nil;

%group SafariWallpaper

%hook CatalogViewController

%property(nonatomic, retain)UIImageView* safariWallpaperWallpaperView;
%property(nonatomic, retain)UIImage* safariWallpaperWallpaper;
%property(nonatomic, retain)UIBlurEffect* safariWallpaperBlur;
%property(nonatomic, retain)UIVisualEffectView* safariWallpaperBlurView;

- (void)viewDidAppear:(BOOL)animated { // add safariwallpaper

	%orig;


	// wallpaper
	if (![self safariWallpaperWallpaperView]) {
		self.safariWallpaperWallpaperView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
		[[self safariWallpaperWallpaperView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[[self safariWallpaperWallpaperView] setContentMode:UIViewContentModeScaleAspectFill];
		[[self safariWallpaperWallpaperView] setAlpha:0.0];
		if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight)
			self.safariWallpaperWallpaper = [GcImagePickerUtils imageFromDefaults:@"love.litten.safariwallpaperpreferences" withKey:@"wallpaperImageLight"];
		else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark)
			self.safariWallpaperWallpaper = [GcImagePickerUtils imageFromDefaults:@"love.litten.safariwallpaperpreferences" withKey:@"wallpaperImageDark"];
	}
	[[self safariWallpaperWallpaperView] setImage:[self safariWallpaperWallpaper]];
	if (![[self safariWallpaperWallpaperView] isDescendantOfView:[self view]]) [[self view] insertSubview:[self safariWallpaperWallpaperView] atIndex:0];


	// blur
	if ([blurModeValue intValue] != 0 && ![self safariWallpaperBlur]) {
		if ([blurModeValue intValue] == 1) self.safariWallpaperBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        if ([blurModeValue intValue] == 2) self.safariWallpaperBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        else if ([blurModeValue intValue] == 3) self.safariWallpaperBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		self.safariWallpaperBlurView = [[UIVisualEffectView alloc] initWithEffect:[self safariWallpaperBlur]];
		[[self safariWallpaperBlurView] setFrame:[[self safariWallpaperWallpaperView] bounds]];
        [[self safariWallpaperBlurView] setAlpha:[blurAmountValue doubleValue]];
	}
	if (![[self safariWallpaperBlurView] isDescendantOfView:[self safariWallpaperWallpaperView]]) [[self safariWallpaperWallpaperView] addSubview:[self safariWallpaperBlurView]];


	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[self safariWallpaperWallpaperView] setAlpha:[wallpaperAlphaValue doubleValue]];
    } completion:nil];

	if (useDynamicLabelColorSwitch && !useCustomLabelColorSwitch && [self safariWallpaperWallpaper]) {
		isDarkWallpaper = [libKitten isDarkImage:[self safariWallpaperWallpaper]];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"safariWallpaperUpdateDynamicLabelColor" object:nil];
	}

}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // change wallpaper when switching between light and dark mode

	%orig;

	if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight)
		self.safariWallpaperWallpaper = [GcImagePickerUtils imageFromDefaults:@"love.litten.safariwallpaperpreferences" withKey:@"wallpaperImageLight"];
	else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark)
		self.safariWallpaperWallpaper = [GcImagePickerUtils imageFromDefaults:@"love.litten.safariwallpaperpreferences" withKey:@"wallpaperImageDark"];

	[UIView transitionWithView:[self safariWallpaperWallpaperView] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[[self safariWallpaperWallpaperView] setImage:[self safariWallpaperWallpaper]];
	} completion:nil];

	if (useDynamicLabelColorSwitch && !useCustomLabelColorSwitch && [self safariWallpaperWallpaper]) {
		isDarkWallpaper = [libKitten isDarkImage:[self safariWallpaperWallpaper]];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"safariWallpaperUpdateDynamicLabelColor" object:nil];
	}

}

%end

%end

%group SafariWallpaperBookmarks

%hook BookmarkFavoritesGridView

- (void)didMoveToWindow { // hide bookmarks

	%orig;

	[self setHidden:hideBookmarksSwitch];

}

%end

%hook BookmarkFavoritesGridSectionHeaderView

- (id)initWithFrame:(CGRect)frame { // register a notification observer

	id orig = %orig;

	if (useDynamicLabelColorSwitch && !useCustomLabelColorSwitch) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDynamicLabelColor) name:@"safariWallpaperUpdateDynamicLabelColor" object:nil];

	return orig;

}

- (void)didMoveToWindow { // hide bookmark headers and apply custom color

	%orig;

	UILabel* title = [self valueForKey:@"_titleLabel"];

	[title setHidden:hideBookmarkHeadersSwitch];

	if (useCustomLabelColorSwitch && !useDynamicLabelColorSwitch)
		[title setTextColor:[GcColorPickerUtils colorWithHex:customLabelColorValue]];

}

- (void)layoutSubviews { // update label colors

	%orig;
	
	if (useDynamicLabelColorSwitch) {
		[self updateDynamicLabelColor];
		return;
	}

	if (useCustomLabelColorSwitch && !useDynamicLabelColorSwitch) {
		UILabel* title = [self valueForKey:@"_titleLabel"];
		[title setTextColor:[GcColorPickerUtils colorWithHex:customLabelColorValue]];
	}

}

%new
- (void)updateDynamicLabelColor { // update dynamic label color

	if (!useDynamicLabelColorSwitch) return;

	UILabel* title = [self valueForKey:@"_titleLabel"];

	if (isDarkWallpaper)
		[title setTextColor:[UIColor whiteColor]];
	else
		[title setTextColor:[UIColor blackColor]];

}

%end

%hook BookmarkFavoriteView

- (id)initWithFrame:(CGRect)frame { // register a notification observer

	id orig = %orig;

	if (useDynamicLabelColorSwitch && !useCustomLabelColorSwitch) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDynamicLabelColor) name:@"safariWallpaperUpdateDynamicLabelColor" object:nil];

	return orig;

}

- (void)didMoveToWindow { // hide bookmark titles and apply custom color

	%orig;

	VibrantLabelView* title = [self valueForKey:@"_titleLabel"];

	[title setHidden:hideBookmarkTitlesSwitch];

	if (useCustomLabelColorSwitch && !useDynamicLabelColorSwitch)
		[title setTextColor:[GcColorPickerUtils colorWithHex:customLabelColorValue]];

}

- (void)layoutSubviews { // update label colors

	%orig;
	
	if (useDynamicLabelColorSwitch) {
		[self updateDynamicLabelColor];
		return;
	}

	if (useCustomLabelColorSwitch && !useDynamicLabelColorSwitch) {
		VibrantLabelView* title = [self valueForKey:@"_titleLabel"];
		[title setTextColor:[GcColorPickerUtils colorWithHex:customLabelColorValue]];
	}

}

%new
- (void)updateDynamicLabelColor { // update dynamic label color
	
	if (!useDynamicLabelColorSwitch) return;

	VibrantLabelView* title = [self valueForKey:@"_titleLabel"];

	if (isDarkWallpaper)
		[title setTextColor:[UIColor whiteColor]];
	else
		[title setTextColor:[UIColor blackColor]];

}

%end

%end

%group SafariWallpaperMiscellaneous

%hook _SFNavigationBar

- (id)initWithFrame:(CGRect)frame { // get an instance of _SFNavigationBar

	id orig = %orig;

	navigationBar = self;

	return orig;

}

%end

%hook TabDocument

- (void)setActive:(BOOL)arg1 { // automatically focus the url bar

	%orig;

	if (arg1) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			if ([[self valueForKey:@"_isBlank"] boolValue] && ![[self valueForKey:@"_webViewIsLoading"] boolValue]) [navigationBar _URLTapped:nil];
		});
	}

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.safariwallpaperpreferences"];

	[preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

	// wallpaper
	[preferences registerObject:&wallpaperAlphaValue default:@"1.0" forKey:@"wallpaperAlpha"];
	[preferences registerObject:&blurModeValue default:@"0" forKey:@"blurMode"];
	[preferences registerObject:&blurAmountValue default:@"1" forKey:@"blurAmount"];

	// bookmarks
	[preferences registerBool:&hideBookmarksSwitch default:NO forKey:@"hideBookmarks"];
	[preferences registerBool:&hideBookmarkHeadersSwitch default:NO forKey:@"hideBookmarkHeaders"];
	[preferences registerBool:&hideBookmarkTitlesSwitch default:NO forKey:@"hideBookmarkTitles"];
	[preferences registerBool:&useDynamicLabelColorSwitch default:YES forKey:@"useDynamicLabelColor"];
	[preferences registerBool:&useCustomLabelColorSwitch default:NO forKey:@"useCustomLabelColor"];
	[preferences registerObject:&customLabelColorValue default:@"000000" forKey:@"customLabelColor"];
	
	// miscellaneous
	[preferences registerBool:&automaticFocusOnBlankTabSwitch default:NO forKey:@"automaticFocusOnBlankTab"];

	%init(SafariWallpaper);
	if (hideBookmarksSwitch || hideBookmarkHeadersSwitch || hideBookmarkTitlesSwitch || useDynamicLabelColorSwitch || useCustomLabelColorSwitch) %init(SafariWallpaperBookmarks);
	if (automaticFocusOnBlankTabSwitch) %init(SafariWallpaperMiscellaneous);

}