#import "VioletSpringBoard.h"

%group VioletLockScreenBackground

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add violet to the lock screen background

	%orig;

	lockScreenArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	[lockScreenArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[lockScreenArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[lockScreenArtworkBackgroundImageView setHidden:currentArtwork ? NO : YES];
	[lockScreenArtworkBackgroundImageView setAlpha:[lockscreenArtworkOpacityValue doubleValue]];
	[[self view] insertSubview:lockScreenArtworkBackgroundImageView atIndex:0];

	if ([lockscreenArtworkBlurMode intValue] != 0) {
		if ([lockscreenArtworkBlurMode intValue] == 1)
			lockScreenBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		else if ([lockscreenArtworkBlurMode intValue] == 2)
			lockScreenBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		else if ([lockscreenArtworkBlurMode intValue] == 3)
			lockScreenBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		lockScreenBlurView = [[UIVisualEffectView alloc] initWithEffect:lockScreenBlur];
		[lockScreenBlurView setFrame:[lockScreenArtworkBackgroundImageView bounds]];
		[lockScreenBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[lockScreenBlurView setAlpha:[lockscreenArtworkBlurAmountValue doubleValue]];
		[lockScreenArtworkBackgroundImageView addSubview:lockScreenBlurView];
	}

	if ([lockscreenArtworkDimValue doubleValue] != 0.0) {
		lockScreenDimView = [[UIView alloc] init];
		[lockScreenDimView setFrame:[lockScreenArtworkBackgroundImageView bounds]];
		[lockScreenDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[lockScreenDimView setBackgroundColor:[UIColor blackColor]];
		[lockScreenDimView setAlpha:[lockscreenArtworkDimValue doubleValue]];
		[lockScreenArtworkBackgroundImageView addSubview:lockScreenDimView];
	}

}

%end

%end

%group VioletLockScreenPlayer

%hook MRUNowPlayingViewController

- (void)viewDidAppear:(BOOL)animated { // add violet to the lock screen player

	%orig;

	if ([self context] == 2) {
		UIView* AdjunctItemView = [[[[[[self view] superview] superview] superview] superview] superview];
		UIView* platterView = [AdjunctItemView valueForKey:@"_platterView"];
		MTMaterialView* backgroundMaterialView = [platterView valueForKey:@"_backgroundView"];
		
		if (currentArtwork) [self clearMaterialViewBackground];
		else [self setMaterialViewBackground];

		if (!lockScreenPlayerArtworkBackgroundImageView) lockScreenPlayerArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[AdjunctItemView bounds]];
		[lockScreenPlayerArtworkBackgroundImageView setImage:currentArtwork];
		[lockScreenPlayerArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
		[lockScreenPlayerArtworkBackgroundImageView setHidden:currentArtwork ? NO : YES];
		[lockScreenPlayerArtworkBackgroundImageView setClipsToBounds:YES];
		[[lockScreenPlayerArtworkBackgroundImageView layer] setCornerRadius:[[platterView layer] cornerRadius]];
		[[lockScreenPlayerArtworkBackgroundImageView layer] setContinuousCorners:YES];
		[lockScreenPlayerArtworkBackgroundImageView setAlpha:[lockscreenPlayerArtworkOpacityValue doubleValue]];
		[[lockScreenPlayerArtworkBackgroundImageView layer] setCornerRadius:[[backgroundMaterialView layer] cornerRadius]];
		[[lockScreenPlayerArtworkBackgroundImageView layer] setMasksToBounds:YES];
		if (![lockScreenPlayerArtworkBackgroundImageView isDescendantOfView:AdjunctItemView]) [AdjunctItemView insertSubview:lockScreenPlayerArtworkBackgroundImageView atIndex:0];

		if ([lockscreenPlayerArtworkBlurMode intValue] != 0) {
			if (!lockScreenPlayerBlur) {
				if ([lockscreenPlayerArtworkBlurMode intValue] == 1)
					lockScreenPlayerBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				else if ([lockscreenPlayerArtworkBlurMode intValue] == 2)
					lockScreenPlayerBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				else if ([lockscreenPlayerArtworkBlurMode intValue] == 3)
					lockScreenPlayerBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			}
			if (!lockScreenPlayerBlurView) lockScreenPlayerBlurView = [[UIVisualEffectView alloc] initWithEffect:lockScreenPlayerBlur];
			[lockScreenPlayerBlurView setFrame:[lockScreenPlayerArtworkBackgroundImageView bounds]];
			[lockScreenPlayerBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[lockScreenPlayerBlurView setAlpha:[lockscreenPlayerArtworkBlurAmountValue doubleValue]];
			if (![lockScreenPlayerBlurView isDescendantOfView:lockScreenPlayerArtworkBackgroundImageView]) [lockScreenPlayerArtworkBackgroundImageView addSubview:lockScreenPlayerBlurView];
		}

		if ([lockscreenPlayerArtworkDimValue doubleValue] != 0.0) {
			if (!lockScreenPlayerDimView) lockScreenPlayerDimView = [[UIView alloc] initWithFrame:[lockScreenPlayerArtworkBackgroundImageView bounds]];
			[lockScreenPlayerDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[lockScreenPlayerDimView setBackgroundColor:[UIColor blackColor]];
			[lockScreenPlayerDimView setAlpha:[lockscreenPlayerArtworkDimValue doubleValue]];
			if (![lockScreenPlayerDimView isDescendantOfView:lockScreenPlayerArtworkBackgroundImageView]) [lockScreenPlayerArtworkBackgroundImageView addSubview:lockScreenPlayerDimView];
		}
	}

}

%new
- (void)clearMaterialViewBackground { // clear the material view

	UIView* AdjunctItemView = [[[[[[self view] superview] superview] superview] superview] superview];

	UIView* platterView = [AdjunctItemView valueForKey:@"_platterView"];
	MTMaterialView* MTView = [platterView valueForKey:@"_backgroundView"];
	MTMaterialLayer* MTLayer = (MTMaterialLayer *)[MTView layer];
	[MTLayer setScale:0];
	[MTLayer mt_setColorMatrixDrivenOpacity:0 removingIfIdentity:false];
	[MTView setBackgroundColor:[UIColor clearColor]];

}

%new
- (void)setMaterialViewBackground { // set the material view

	UIView* AdjunctItemView = [[[[[[self view] superview] superview] superview] superview] superview];

	UIView* platterView = [AdjunctItemView valueForKey:@"_platterView"];
	MTMaterialView* MTView = [platterView valueForKey:@"_backgroundView"];
	MTMaterialLayer* MTLayer = (MTMaterialLayer *)[MTView layer];
	[MTLayer setScale:1];
	[MTLayer mt_setColorMatrixDrivenOpacity:1 removingIfIdentity:false];

}

%end

%hook CSNotificationAdjunctListViewController

- (void)viewDidLoad { // override the appearance style of the player

	%orig;

	if ([lockscreenPlayerStyleOverrideValue intValue] != 0) [self setOverrideUserInterfaceStyle:[lockscreenPlayerStyleOverrideValue intValue]];

}

%end

%end

%group VioletHomeScreen

%hook SBIconController

- (void)viewDidLoad { // add violet to the home screen background

	%orig;

	homeScreenArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	if (zoomedViewSwitch) homeScreenArtworkBackgroundImageView.bounds = CGRectInset(homeScreenArtworkBackgroundImageView.frame, -50, -50);
	[homeScreenArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[homeScreenArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[homeScreenArtworkBackgroundImageView setHidden:currentArtwork ? NO : YES];
	[homeScreenArtworkBackgroundImageView setAlpha:[homescreenArtworkOpacityValue doubleValue]];
	[[self view] insertSubview:homeScreenArtworkBackgroundImageView atIndex:0];

	if ([homescreenArtworkBlurMode intValue] != 0) {
		if ([homescreenArtworkBlurMode intValue] == 1)
			homeScreenBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		else if ([homescreenArtworkBlurMode intValue] == 2)
			homeScreenBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		else if ([homescreenArtworkBlurMode intValue] == 3)
			homeScreenBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		homeScreenBlurView = [[UIVisualEffectView alloc] initWithEffect:homeScreenBlur];
		[homeScreenBlurView setFrame:[homeScreenArtworkBackgroundImageView bounds]];
		[homeScreenBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[homeScreenBlurView setAlpha:[homescreenArtworkBlurAmountValue doubleValue]];
		[homeScreenArtworkBackgroundImageView addSubview:homeScreenBlurView];
	}

	if ([homescreenArtworkDimValue doubleValue] != 0.0) {
		homeScreenDimView = [[UIView alloc] initWithFrame:[homeScreenArtworkBackgroundImageView bounds]];
		[homeScreenDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[homeScreenDimView setBackgroundColor:[UIColor blackColor]];
		[homeScreenDimView setAlpha:[homescreenArtworkDimValue doubleValue]];
		[homeScreenArtworkBackgroundImageView addSubview:homeScreenDimView];
	}

}

%end

%end

%group VioletControlCenterBackground

%hook CCUIModularControlCenterOverlayViewController

- (void)viewWillAppear:(BOOL)animated { // add violet to the control center background

	%orig;

	if (!controlCenterArtworkBackgroundImageView) controlCenterArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	[controlCenterArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[controlCenterArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[controlCenterArtworkBackgroundImageView setHidden:currentArtwork ? NO : YES];
	[controlCenterArtworkBackgroundImageView setAlpha:[controlCenterArtworkOpacityValue doubleValue]];
	if (![controlCenterArtworkBackgroundImageView isDescendantOfView:[self view]]) [[self view] insertSubview:controlCenterArtworkBackgroundImageView atIndex:1];

	if ([controlCenterArtworkBlurMode intValue] != 0) {
		if (!controlCenterBlur) {
			if ([controlCenterArtworkBlurMode intValue] == 1)
				controlCenterBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([controlCenterArtworkBlurMode intValue] == 2)
				controlCenterBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			else if ([controlCenterArtworkBlurMode intValue] == 3)
				controlCenterBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		}
		if (!controlCenterBlurView) controlCenterBlurView = [[UIVisualEffectView alloc] initWithEffect:controlCenterBlur];
		[controlCenterBlurView setFrame:[controlCenterArtworkBackgroundImageView bounds]];
		[controlCenterBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[controlCenterBlurView setAlpha:[controlCenterArtworkBlurAmountValue doubleValue]];
		if (![controlCenterBlurView isDescendantOfView:controlCenterArtworkBackgroundImageView]) [controlCenterArtworkBackgroundImageView addSubview:controlCenterBlurView];
	}

	if ([controlCenterArtworkDimValue doubleValue] != 0.0) {
		if (!controlCenterDimView) controlCenterDimView = [[UIView alloc] initWithFrame:[controlCenterArtworkBackgroundImageView bounds]];
		[controlCenterDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[controlCenterDimView setBackgroundColor:[UIColor blackColor]];
		[controlCenterDimView setAlpha:[controlCenterArtworkDimValue doubleValue]];
		if (![controlCenterDimView isDescendantOfView:controlCenterArtworkBackgroundImageView]) [controlCenterArtworkBackgroundImageView addSubview:controlCenterDimView];
	}

}

- (void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 { // hide cc background earlier than it would otherwise

	%orig;

	[controlCenterArtworkBackgroundImageView setHidden:YES];

}

%end

%end

%group VioletControlCenterNowPlayingModule

%hook CCUIContentModuleContainerViewController

- (void)viewWillAppear:(BOOL)animated { // add violet to the control center now playing module

	%orig;
	
	if (![[self moduleIdentifier] isEqual:@"com.apple.mediaremote.controlcenter.nowplaying"]) return;
	if (!controlCenterModuleArtworkBackgroundImageView) controlCenterModuleArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[[self contentViewController] view] bounds]];
	[controlCenterModuleArtworkBackgroundImageView setImage:currentArtwork];
	[controlCenterModuleArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[controlCenterModuleArtworkBackgroundImageView setHidden:currentArtwork ? NO : YES];
	[controlCenterModuleArtworkBackgroundImageView setClipsToBounds:YES];
	[[controlCenterModuleArtworkBackgroundImageView layer] setCornerRadius:[[self moduleContentView] compactContinuousCornerRadius]];
	[[controlCenterModuleArtworkBackgroundImageView layer] setCornerCurve:kCACornerCurveContinuous];
	[controlCenterModuleArtworkBackgroundImageView setAlpha:[controlCenterModuleArtworkOpacityValue doubleValue]];
	if (![controlCenterModuleArtworkBackgroundImageView isDescendantOfView:[self view]]) [[self view] insertSubview:controlCenterModuleArtworkBackgroundImageView atIndex:0];

	if ([controlCenterModuleArtworkBlurMode intValue] != 0) {
		if (!controlCenterModuleBlur) {
			if ([controlCenterModuleArtworkBlurMode intValue] == 1)
				controlCenterModuleBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([controlCenterModuleArtworkBlurMode intValue] == 2)
				controlCenterModuleBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			else if ([controlCenterModuleArtworkBlurMode intValue] == 3)
				controlCenterModuleBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		}
		if (!controlCenterModuleBlurView) controlCenterModuleBlurView = [[UIVisualEffectView alloc] initWithEffect:controlCenterModuleBlur];
		[controlCenterModuleBlurView setFrame:[controlCenterModuleArtworkBackgroundImageView bounds]];
		[controlCenterModuleBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[controlCenterModuleBlurView setAlpha:[controlCenterModuleArtworkBlurAmountValue doubleValue]];
		if (![controlCenterModuleBlurView isDescendantOfView:controlCenterModuleArtworkBackgroundImageView]) [controlCenterModuleArtworkBackgroundImageView addSubview:controlCenterModuleBlurView];
	}

	if ([controlCenterModuleArtworkDimValue doubleValue] != 0.0) {
		if (!controlCenterModuleDimView) controlCenterModuleDimView = [[UIView alloc] initWithFrame:[controlCenterModuleArtworkBackgroundImageView bounds]];
		[controlCenterModuleDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[controlCenterModuleDimView setBackgroundColor:[UIColor blackColor]];
		[controlCenterModuleDimView setAlpha:[controlCenterModuleArtworkDimValue doubleValue]];
		[controlCenterModuleDimView setHidden:currentArtwork ? NO : YES];
		if (![controlCenterModuleDimView isDescendantOfView:controlCenterModuleArtworkBackgroundImageView]) [controlCenterModuleArtworkBackgroundImageView addSubview:controlCenterModuleDimView];
	}

}

- (void)setExpanded:(BOOL)arg1 { // hide the artwork when the now playing module was expanded

	%orig;

	if (arg1 && [[self moduleIdentifier] isEqual:@"com.apple.mediaremote.controlcenter.nowplaying"]) [controlCenterModuleArtworkBackgroundImageView setHidden:YES];

}

%end

%end

%group VioletCompletion

%hook CSAdjunctItemView

- (void)removeFromSuperview { // hide the backgrounds after the lock screen player disappeared due to inactivity

	%orig;

	if (lockscreenArtworkBackgroundSwitch) [lockScreenArtworkBackgroundImageView setHidden:YES];
	if (lockscreenPlayerArtworkBackgroundSwitch) [lockScreenPlayerArtworkBackgroundImageView setHidden:YES];
	if (homescreenArtworkBackgroundSwitch) [homeScreenArtworkBackgroundImageView setHidden:YES];
	if (controlCenterArtworkBackgroundSwitch) [controlCenterArtworkBackgroundImageView setHidden:YES];
	if (controlCenterModuleArtworkBackgroundSwitch) [controlCenterModuleArtworkBackgroundImageView setHidden:YES];

}

%end

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // get and set the artwork

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		if (information) {
			NSDictionary* dictionary = (__bridge NSDictionary *)information;
			currentArtwork = [UIImage imageWithData:[dictionary objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
			if (currentArtwork) {
				if (lockscreenArtworkBackgroundSwitch) {
					if (lockscreenArtworkBackgroundTransitionSwitch) {
						[UIView transitionWithView:lockScreenArtworkBackgroundImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
							[lockScreenArtworkBackgroundImageView setImage:currentArtwork];
						} completion:nil];
					} else {
						[lockScreenArtworkBackgroundImageView setImage:currentArtwork];
					}
					[lockScreenArtworkBackgroundImageView setHidden:NO];
				}

				if (lockscreenPlayerArtworkBackgroundSwitch) {
					if (lockscreenPlayerArtworkBackgroundTransitionSwitch) {
						[UIView transitionWithView:lockScreenPlayerArtworkBackgroundImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
							[lockScreenPlayerArtworkBackgroundImageView setImage:currentArtwork];
						} completion:nil];
					} else {
						[lockScreenPlayerArtworkBackgroundImageView setImage:currentArtwork];
					}
					[lockScreenPlayerArtworkBackgroundImageView setHidden:NO];
				}

				if (homescreenArtworkBackgroundSwitch) {
					if (homescreenArtworkBackgroundTransitionSwitch) {
						[UIView transitionWithView:homeScreenArtworkBackgroundImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
							[homeScreenArtworkBackgroundImageView setImage:currentArtwork];
						} completion:nil];
					} else {
						[homeScreenArtworkBackgroundImageView setImage:currentArtwork];
					}
					[homeScreenArtworkBackgroundImageView setHidden:NO];
				}

				if (controlCenterArtworkBackgroundSwitch) {
					if (controlCenterArtworkBackgroundTransitionSwitch) {
						[UIView transitionWithView:controlCenterArtworkBackgroundImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
							[controlCenterArtworkBackgroundImageView setImage:currentArtwork];
						} completion:nil];
					} else {
						[controlCenterArtworkBackgroundImageView setImage:currentArtwork];
					}
				}

				if (controlCenterModuleArtworkBackgroundSwitch) {
					if (controlCenterModuleArtworkBackgroundTransitionSwitch) {
						[UIView transitionWithView:controlCenterModuleArtworkBackgroundImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
							[controlCenterModuleArtworkBackgroundImageView setImage:currentArtwork];
						} completion:nil];
					} else {
						[controlCenterModuleArtworkBackgroundImageView setImage:currentArtwork];
					}
				}
			}
		} else {
			currentArtwork = nil;

			[lockScreenArtworkBackgroundImageView setImage:nil];
			[lockScreenArtworkBackgroundImageView setHidden:YES];
			[lockScreenPlayerArtworkBackgroundImageView setImage:nil];
			[lockScreenPlayerArtworkBackgroundImageView setHidden:YES];
			
			[homeScreenArtworkBackgroundImageView setImage:nil];
			[homeScreenArtworkBackgroundImageView setHidden:YES];

			[controlCenterArtworkBackgroundImageView setImage:nil];
			[controlCenterArtworkBackgroundImageView setHidden:YES];
			[controlCenterModuleArtworkBackgroundImageView setImage:nil];
			[controlCenterModuleArtworkBackgroundImageView setHidden:YES];
		}
  	});
    
}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 { // reload data after respring

	%orig;

	[[%c(SBMediaController) sharedInstance] setNowPlayingInfo:0];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.violetpreferences"];

    [preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

	// lock screen
	[preferences registerBool:&lockscreenArtworkBackgroundSwitch default:NO forKey:@"lockscreenArtworkBackground"];
	[preferences registerBool:&lockscreenPlayerArtworkBackgroundSwitch default:NO forKey:@"lockscreenPlayerArtworkBackground"];
	if (lockscreenArtworkBackgroundSwitch || lockscreenPlayerArtworkBackgroundSwitch) {
		if (lockscreenArtworkBackgroundSwitch) {
			[preferences registerObject:&lockscreenArtworkBlurMode default:@"0" forKey:@"lockscreenArtworkBlur"];
			[preferences registerObject:&lockscreenArtworkBlurAmountValue default:@"1.0" forKey:@"lockscreenArtworkBlurAmount"];
			[preferences registerObject:&lockscreenArtworkOpacityValue default:@"1.0" forKey:@"lockscreenArtworkOpacity"];
			[preferences registerObject:&lockscreenArtworkDimValue default:@"0.0" forKey:@"lockscreenArtworkDim"];
			[preferences registerBool:&lockscreenArtworkBackgroundTransitionSwitch default:NO forKey:@"lockscreenArtworkBackgroundTransition"];
			%init(VioletLockScreenBackground);
		}
		if (lockscreenPlayerArtworkBackgroundSwitch) {
			[preferences registerObject:&lockscreenPlayerArtworkBlurMode default:@"0" forKey:@"lockscreenPlayerArtworkBlur"];
			[preferences registerObject:&lockscreenPlayerArtworkBlurAmountValue default:@"1.0" forKey:@"lockscreenPlayerArtworkBlurAmount"];
			[preferences registerObject:&lockscreenPlayerArtworkOpacityValue default:@"1.0" forKey:@"lockscreenPlayerArtworkOpacity"];
			[preferences registerObject:&lockscreenPlayerArtworkDimValue default:@"0.0" forKey:@"lockscreenPlayerArtworkDim"];
			[preferences registerBool:&lockscreenPlayerArtworkBackgroundTransitionSwitch default:NO forKey:@"lockscreenPlayerArtworkBackgroundTransition"];
			[preferences registerObject:&lockscreenPlayerStyleOverrideValue default:@"0" forKey:@"lockscreenPlayerStyleOverride"];
			%init(VioletLockScreenPlayer);
		}
	}

	// home screen
	[preferences registerBool:&homescreenArtworkBackgroundSwitch default:NO forKey:@"homescreenArtworkBackground"];
	if (homescreenArtworkBackgroundSwitch) {
		[preferences registerObject:&homescreenArtworkBlurMode default:@"0" forKey:@"homescreenArtworkBlur"];
		[preferences registerObject:&homescreenArtworkBlurAmountValue default:@"1.0" forKey:@"homescreenArtworkBlurAmount"];
		[preferences registerObject:&homescreenArtworkOpacityValue default:@"1.0" forKey:@"homescreenArtworkOpacity"];
		[preferences registerObject:&homescreenArtworkDimValue default:@"0.0" forKey:@"homescreenArtworkDim"];
		[preferences registerBool:&homescreenArtworkBackgroundTransitionSwitch default:NO forKey:@"homescreenArtworkBackgroundTransition"];
		[preferences registerBool:&zoomedViewSwitch default:YES forKey:@"zoomedView"];
		%init(VioletHomeScreen);
	}

	// control center
	[preferences registerBool:&controlCenterArtworkBackgroundSwitch default:NO forKey:@"controlCenterArtworkBackground"];
	[preferences registerBool:&controlCenterModuleArtworkBackgroundSwitch default:NO forKey:@"controlCenterModuleArtworkBackground"];
	if (controlCenterArtworkBackgroundSwitch || controlCenterModuleArtworkBackgroundSwitch) {
		if (controlCenterArtworkBackgroundSwitch) {
			[preferences registerObject:&controlCenterArtworkBlurMode default:@"0" forKey:@"controlCenterArtworkBlur"];
			[preferences registerObject:&controlCenterArtworkBlurAmountValue default:@"1.0" forKey:@"controlCenterArtworkBlurAmount"];
			[preferences registerObject:&controlCenterArtworkOpacityValue default:@"1.0" forKey:@"controlCenterArtworkOpacity"];
			[preferences registerObject:&controlCenterArtworkDimValue default:@"0.0" forKey:@"controlCenterArtworkDim"];
			[preferences registerBool:&controlCenterArtworkBackgroundTransitionSwitch default:NO forKey:@"controlCenterArtworkBackgroundTransition"];
			%init(VioletControlCenterBackground);
		}
		if (controlCenterModuleArtworkBackgroundSwitch) {
			[preferences registerObject:&controlCenterModuleArtworkBlurMode default:@"0" forKey:@"controlCenterModuleArtworkBlur"];
			[preferences registerObject:&controlCenterModuleArtworkBlurAmountValue default:@"1.0" forKey:@"controlCenterModuleArtworkBlurAmount"];
			[preferences registerObject:&controlCenterModuleArtworkOpacityValue default:@"1.0" forKey:@"controlCenterModuleArtworkOpacity"];
			[preferences registerObject:&controlCenterModuleArtworkDimValue default:@"0.0" forKey:@"controlCenterModuleArtworkDim"];
			[preferences registerBool:&controlCenterModuleArtworkBackgroundTransitionSwitch default:NO forKey:@"controlCenterModuleArtworkBackgroundTransition"];
			%init(VioletControlCenterNowPlayingModule);
		}
	}

	if (lockscreenArtworkBackgroundSwitch ||
		lockscreenPlayerArtworkBackgroundSwitch ||
		homescreenArtworkBackgroundSwitch ||
		controlCenterArtworkBackgroundSwitch ||
		controlCenterModuleArtworkBackgroundSwitch
		) 
		%init(VioletCompletion);

}
