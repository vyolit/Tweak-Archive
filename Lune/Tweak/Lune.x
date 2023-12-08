#import "Lune.h"

CSCoverSheetView* coverSheetView = nil;

%group LuneGlobal

%hook CSCoverSheetView

- (id)initWithFrame:(CGRect)frame { // get an instance of cscoversheetview

	if (!enableIconSwitch && (!darkenBackgroundSwitch && !alwaysDarkenBackgroundSwitch)) return %orig;
	id orig = %orig;
	coverSheetView = self;

	return orig;

}

%new
- (void)toggleLuneVisibility:(BOOL)visible { // toggle visibility

	if (visible) {
		[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			if (enableIconSwitch) [[self luneView] setAlpha:1];
			if ((darkenBackgroundSwitch || alwaysDarkenBackgroundSwitch) && !alwaysDarkenBackgroundSwitch) [[self luneDimView] setAlpha:[darkeningAmountValue doubleValue]];
		} completion:nil];
	} else {
		[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			if (enableIconSwitch) [[self luneView] setAlpha:0];
			if ((darkenBackgroundSwitch || alwaysDarkenBackgroundSwitch) && !alwaysDarkenBackgroundSwitch) [[self luneDimView] setAlpha:0];
		} completion:nil];
	}

}

%end

%hook DNDState

- (id)initWithCoder:(id)arg1 { // add a notification observer

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isActive) name:@"luneRefreshState" object:nil];

	return %orig;

}

- (BOOL)isActive { // get the do not disturb state

	isDNDActive = %orig;

	dispatch_async(dispatch_get_main_queue(), ^{
		if (isDNDActive)
			[coverSheetView toggleLuneVisibility:YES];
		else if (!isDNDActive)
			[coverSheetView toggleLuneVisibility:NO];
	});

	return isDNDActive;

}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 { // hide/unhide lune after a respring & reload data

	%orig;

	[[NSNotificationCenter defaultCenter] postNotificationName:@"luneRefreshState" object:nil];
	if (enableIconSwitch && useArtworkBasedColorSwitch) [[%c(SBMediaController) sharedInstance] setNowPlayingInfo:0];

}

%end

%end

%group LuneIcon

%hook CSCoverSheetView

%property(nonatomic, retain)UIImageView* luneView;

- (void)didMoveToWindow { // add the lune icon

	%orig;

	if ([self luneView]) return;
	self.luneView = [[UIImageView alloc] initWithFrame:CGRectMake([xPositionValue doubleValue], [yPositionValue doubleValue], [sizeValue doubleValue], [sizeValue doubleValue])];
	[[self luneView] setImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/PreferenceBundles/LunePreferences.bundle/icons/icon%d.png", [iconValue intValue]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[[self luneView] setContentMode:UIViewContentModeScaleAspectFill];
	[[self luneView] setAlpha:0];

	if (!useCustomColorSwitch) [[self luneView] setTintColor:[UIColor whiteColor]];
	else if (useCustomColorSwitch) [[self luneView] setTintColor:[GcColorPickerUtils colorWithHex:customColorValue]];

	if (glowSwitch) {
		if (!useCustomGlowColorSwitch) [[[self luneView] layer] setShadowColor:[[UIColor whiteColor] CGColor]];
		else if (useCustomGlowColorSwitch) [[[self luneView] layer] setShadowColor:[[GcColorPickerUtils colorWithHex:customGlowColorValue] CGColor]];
		[[[self luneView] layer] setShadowOffset:CGSizeZero];
		[[[self luneView] layer] setShadowRadius:[glowRadiusValue doubleValue]];
		[[[self luneView] layer] setShadowOpacity:[glowAlphaValue doubleValue]];
	}
	
	[self addSubview:[self luneView]];

}

%end

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // set artwork based color

    %orig;

	if (!useArtworkBasedColorSwitch) return;
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;
            if (dict) {
				if (![lastArtworkData isEqual:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]) {
					// get artwork based color
					backgroundArtworkColor = [libKitten backgroundColor:[UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]];

					// set artwork based color
					[[coverSheetView luneView] setTintColor:backgroundArtworkColor];
					[[[coverSheetView luneView] layer] setShadowColor:[backgroundArtworkColor CGColor]];
				}

				lastArtworkData = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData];
            }
        } else { // reset color if not playing
            if (!useCustomColorSwitch) {
				[[coverSheetView luneView] setTintColor:[UIColor whiteColor]];
				[[[coverSheetView luneView] layer] setShadowColor:[[UIColor whiteColor] CGColor]];
			} else if (useCustomColorSwitch) {
				[[coverSheetView luneView] setTintColor:[GcColorPickerUtils colorWithHex:customColorValue]];
				if (!useCustomGlowColorSwitch) [[[coverSheetView luneView] layer] setShadowColor:[[UIColor whiteColor] CGColor]];
				else if (useCustomGlowColorSwitch) [[[coverSheetView luneView] layer] setShadowColor:[[GcColorPickerUtils colorWithHex:customGlowColorValue] CGColor]];
			}
        }
  	});
    
}

%end

%end

%group LuneBackground

%hook CSCoverSheetView

%property(nonatomic, retain)UIView* luneDimView;

- (void)didMoveToWindow { // add lune dim view

	%orig;

	if ([self luneDimView]) return;
	self.luneDimView = [[UIView alloc] initWithFrame:[self bounds]];
	[[self luneDimView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self luneDimView] setBackgroundColor:[UIColor blackColor]];
	if (!alwaysDarkenBackgroundSwitch) [[self luneDimView] setAlpha:0];
	else [[self luneDimView] setAlpha:[darkeningAmountValue doubleValue]];
	[self insertSubview:[self luneDimView] atIndex:0];

}

%end

%end

%group LuneStatusBar

%hook _UIStatusBarStringView

- (void)setText:(id)arg1 { // add a moon emoji next to the status bar time

	if (!isDNDActive) return %orig;
	if (isDNDActive && [arg1 containsString:@":"]) return %orig([NSString stringWithFormat:@"%@ 🌙", arg1]);
	else return %orig;

}

%end

%end

%group LuneBanner

%hook DNDNotificationsService

- (void)_queue_postOrRemoveNotificationWithUpdatedBehavior:(BOOL)arg1 significantTimeChange:(BOOL)arg2 { // hide the dnd banner

	if (hideDNDBannerSwitch)
		return;
	else
		%orig;

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.lunepreferences"];
	
	[preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

	// icon
	[preferences registerBool:&enableIconSwitch default:YES forKey:@"enableIcon"];
	if (enableIconSwitch) {
		[preferences registerObject:&xPositionValue default:@"150" forKey:@"xPosition"];
		[preferences registerObject:&yPositionValue default:@"100" forKey:@"yPosition"];
		[preferences registerObject:&sizeValue default:@"50" forKey:@"size"];
		[preferences registerObject:&iconValue default:@"0" forKey:@"icon"];
		[preferences registerObject:&customColorValue default:@"FFFFFF" forKey:@"customColor"];
		[preferences registerBool:&glowSwitch default:YES forKey:@"glow"];
		if (glowSwitch) {
			[preferences registerBool:&useCustomGlowColorSwitch default:NO forKey:@"useCustomGlowColor"];
			[preferences registerObject:&customGlowColorValue default:@"FFFFFF" forKey:@"customGlowColor"];
			[preferences registerObject:&glowRadiusValue default:@"10" forKey:@"glowRadius"];
			[preferences registerObject:&glowAlphaValue default:@"1" forKey:@"glowAlpha"];
		}
		[preferences registerBool:&useCustomColorSwitch default:NO forKey:@"useCustomColor"];
		[preferences registerBool:&useArtworkBasedColorSwitch default:YES forKey:@"useArtworkBasedColor"];
	}

	// background
	[preferences registerBool:&darkenBackgroundSwitch default:YES forKey:@"darkenBackground"];
	[preferences registerBool:&alwaysDarkenBackgroundSwitch default:NO forKey:@"alwaysDarkenBackground"];
	if (darkenBackgroundSwitch || alwaysDarkenBackgroundSwitch) {
		[preferences registerObject:&darkeningAmountValue default:@"0.5" forKey:@"darkeningAmount"];
	}

	// status bar
	[preferences registerBool:&showStatusBarIconSwitch default:NO forKey:@"showStatusBarIcon"];

	// banner
	[preferences registerBool:&hideDNDBannerSwitch default:NO forKey:@"hideDNDBanner"];
	[preferences registerBool:&indicatorPillSwitch default:NO forKey:@"indicatorPill"];

	if (enableIconSwitch || (darkenBackgroundSwitch || alwaysDarkenBackgroundSwitch) || showStatusBarIconSwitch) %init(LuneGlobal);
	if (enableIconSwitch) %init(LuneIcon);
	if (darkenBackgroundSwitch || alwaysDarkenBackgroundSwitch) %init(LuneBackground);
	if (showStatusBarIconSwitch) %init(LuneStatusBar);
	if (hideDNDBannerSwitch || indicatorPillSwitch) %init(LuneBanner);

}