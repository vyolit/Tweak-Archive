#import "DejaVu.h"

SpringBoard* springboard = nil;

%group DejaVu

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add deja vu

	%orig;

	isDejaVuActive = NO;

	dejaVuView = [[UIView alloc] initWithFrame:[[self view] bounds]];
	[dejaVuView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[dejaVuView setBackgroundColor:[UIColor blackColor]];
	[dejaVuView setAlpha:1];
	[dejaVuView setHidden:YES];
	[[self view] insertSubview:dejaVuView atIndex:0];

	springboard = (SpringBoard *)[objc_getClass("SpringBoard") sharedApplication];

}

- (void)viewWillDisappear:(BOOL)animated { // deactivate deja vu view when swiping up

	%orig;

	if ([dejaVuView isHidden]) return;

	[[%c(SBLockScreenManager) sharedInstance] deactivateDejaVu];

}

%end

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 { // set deja vu active when screen turned off

	%orig;

	if (!disableWhileChargingSwitch || (disableWhileChargingSwitch && ![[%c(SBUIController) sharedInstance] isOnAC])) {
		isDejaVuActive = YES;

		if ([dejaVuView isHidden] && !onlyWhenChargingSwitch)
			[self activateDejaVu];
		else if ([dejaVuView isHidden] && onlyWhenChargingSwitch && [[%c(SBUIController) sharedInstance] isOnAC])
			[self activateDejaVu];
		else
			[self deactivateDejaVu];
	}

}

%new
- (void)activateDejaVu { // enable deja vu

	[dejaVuView setAlpha:1];
	[dejaVuView setHidden:NO];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[springboard _simulateHomeButtonPress];
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];

		if (disableBiometricsSwitch) {
			[[%c(SBLockScreenManager) sharedInstance] setBiometricAutoUnlockingDisabled:YES forReason:@"love.litten.dejavu"];
			[[%c(SBUIBiometricResource) sharedInstance] noteScreenDidTurnOff];
		}

		if (enableLowPowerModeSwitch) {
			previousLowPowerModeState = [[%c(_CDBatterySaver) sharedInstance] getPowerMode];
			[[%c(_CDBatterySaver) sharedInstance] setPowerMode:1 error:nil];
		}

		if (enableDoNotDisturbSwitch) {
			DNDModeAssertionService* assertionService = (DNDModeAssertionService *)[objc_getClass("DNDModeAssertionService") serviceForClientIdentifier:@"com.apple.donotdisturb.control-center.module"];
			DNDModeAssertionDetails* newAssertion = [objc_getClass("DNDModeAssertionDetails") userRequestedAssertionDetailsWithIdentifier:@"com.apple.control-center.manual-toggle" modeIdentifier:@"com.apple.donotdisturb.mode.default" lifetime:nil];
			[assertionService takeModeAssertionWithDetails:newAssertion error:NULL];
			[notificationCenter postNotificationName:@"SBQuietModeStatusChangedNotification" object:nil];
		}

		if (pocketDetectionSwitch) [[springboard proximitySensorManager] _enableProx];

		[notificationCenter postNotificationName:@"dejavuUpdateIdleTimer" object:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[notificationCenter postNotificationName:@"dejavuHideElements" object:nil];
		});
	});

	if (deactivateAfterInactivitySwitch && !inactivityTimer) inactivityTimer = [NSTimer scheduledTimerWithTimeInterval:(inactivityAmountValue * 60) target:self selector:@selector(deactivateDueToInactivity) userInfo:nil repeats:NO];
	if (pixelShiftSwitch && !pixelShiftTimer) pixelShiftTimer = [NSTimer scheduledTimerWithTimeInterval:180.0 target:self selector:@selector(initiatePixelShift) userInfo:nil repeats:YES];
	if (dimDisplaySwitch && !dimTimer) dimTimer = [NSTimer scheduledTimerWithTimeInterval:40.0 target:self selector:@selector(dimDisplay) userInfo:nil repeats:NO];

}

%new
- (void)deactivateDejaVu { // disable deja vu

	isDejaVuActive = NO;

	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[dejaVuView setAlpha:0];
	} completion:^(BOOL finished) {
		[dejaVuView setHidden:YES];
	}];

	NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];

	if (disableBiometricsSwitch) {
		[[%c(SBLockScreenManager) sharedInstance] setBiometricAutoUnlockingDisabled:NO forReason:@"love.litten.dejavu"];
		[[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
	}

	if (enableLowPowerModeSwitch && previousLowPowerModeState == 0) [[%c(_CDBatterySaver) sharedInstance] setPowerMode:0 error:nil];

	if (enableDoNotDisturbSwitch) {
		DNDModeAssertionService* assertionService = (DNDModeAssertionService *)[objc_getClass("DNDModeAssertionService") serviceForClientIdentifier:@"com.apple.donotdisturb.control-center.module"];
		[assertionService invalidateAllActiveModeAssertionsWithError:NULL];
		[notificationCenter postNotificationName:@"SBQuietModeStatusChangedNotification" object:nil];
	}

	[[springboard proximitySensorManager] _disableProx];

	[notificationCenter postNotificationName:@"dejavuUpdateIdleTimer" object:nil];
	[notificationCenter postNotificationName:@"dejavuUnhideElements" object:nil];

	if (enableHapticFeedbackSwitch) {
		if (!generator) {
			if (hapticFeedbackStrengthValue == 0)
				generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
			else if (hapticFeedbackStrengthValue == 1)
				generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
			else if (hapticFeedbackStrengthValue == 2)
				generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
		}

		[generator prepare];
		[generator impactOccurred];
	}

	if (deactivateAfterInactivitySwitch) {
		[inactivityTimer invalidate];
		inactivityTimer = nil;
	}

	if (pixelShiftSwitch) {
		[pixelShiftTimer invalidate];
		pixelShiftTimer = nil;
		[notificationCenter postNotificationName:@"dejavuResetShift" object:nil];
	}

	if (dimDisplaySwitch) {
		[dimTimer invalidate];
		dimTimer = nil;
		[self undimDisplay];
	}

}

%new
- (void)deactivateDueToInactivity { // deactivate when inactivity timer is up

	[springboard _simulateLockButtonPress];

	[inactivityTimer invalidate];
	inactivityTimer = nil;

}

%new
- (void)initiatePixelShift { // send pixel shift notification

	[[NSNotificationCenter defaultCenter] postNotificationName:@"dejavuPixelShift" object:nil];

}

%new
- (void)dimDisplay { // dim the display

	Boolean valid = NO;
	wasAutoBrightnessEnabled = CFPreferencesGetAppBooleanValue(CFSTR("BKEnableALS"), CFSTR("com.apple.backboardd"), &valid);

	// disable auto brightness if enabled
	if (wasAutoBrightnessEnabled) {
		CFPreferencesSetAppValue(CFSTR("BKEnableALS"), kCFBooleanFalse, CFSTR("com.apple.backboardd"));
		CFPreferencesAppSynchronize(CFSTR("com.apple.backboardd"));
		GSSendAppPreferencesChanged(CFSTR("com.apple.backboardd"), CFSTR("BKEnableALS"));
	}

	lastBrightness = BKSDisplayBrightnessGetCurrent();
	BKSDisplayBrightnessSet(0.2, 0);

}

%new
- (void)undimDisplay { // undim the display

	if (wasAutoBrightnessEnabled) {
		CFPreferencesSetAppValue(CFSTR("BKEnableALS"), kCFBooleanTrue, CFSTR("com.apple.backboardd"));
		CFPreferencesAppSynchronize(CFSTR("com.apple.backboardd"));
		GSSendAppPreferencesChanged(CFSTR("com.apple.backboardd"), CFSTR("BKEnableALS"));
	}

	BKSDisplayBrightnessSet(lastBrightness, 0);

}

%end

%hook SBProximitySensorManager

- (void)_disableProx { // prevent proximity sensor from disabling itself

	if (!isDejaVuActive || !pocketDetectionSwitch)
		%orig;
	else
		return;

}

%end

%hook NCNotificationListView

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 { // hide deja vu on tap

	%orig;

	if (!deactivateWithTapSwitch) return;
	if ([dejaVuView isHidden]) return;

	[[%c(SBLockScreenManager) sharedInstance] deactivateDejaVu];

}

%end

%hook SBLiftToWakeController

- (void)wakeGestureManager:(id)arg1 didUpdateWakeGesture:(long long)arg2 orientation:(int)arg3 { // disable deja vu with raise to wake

	%orig;

	if (deactivateWithRaiseToWakeSwitch && isDejaVuActive) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[[%c(SBLockScreenManager) sharedInstance] deactivateDejaVu];
		});
	}

}

%end

%hook SBUIController

- (BOOL)isOnAC { // deactivate when charging

	BOOL isCharging = %orig;

	if (isCharging && disableWhileChargingSwitch) [[%c(SBLockScreenManager) sharedInstance] deactivateDejaVu];

	return isCharging;

}

%end

%hook SBDashBoardIdleTimerProvider

- (id)initWithDelegate:(id)arg1 { // add a notification observer

	NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self];
	[notificationCenter addObserver:self selector:@selector(updateIdleTimer) name:@"dejavuUpdateIdleTimer" object:nil];

	return %orig;

}

%new
- (void)updateIdleTimer { // toggle idle timer

	if (isDejaVuActive)
		[self addDisabledIdleTimerAssertionReason:@"love.litten.dejavu"];
	else
		[self removeDisabledIdleTimerAssertionReason:@"love.litten.dejavu"];

}

%end

%hook SBReachabilityManager

- (BOOL)reachabilityEnabled { // disable reachability

	if (isDejaVuActive)
		return NO;
	else
		return %orig;

}

%end

%hook SBControlCenterController

- (BOOL)_shouldAllowControlCenterGesture { // disable control center

	if (isDejaVuActive && disableControlCenterSwitch)
		return NO;
	else
		return %orig;

}

%end

%hook SBMainDisplayPolicyAggregator

- (BOOL)_allowsCapabilityLockScreenCameraWithExplanation:(id *)arg1 { // disable camera swipe

    if (isDejaVuActive)
		return NO;
	else
		return %orig;

}

- (BOOL)_allowsCapabilityTodayViewWithExplanation:(id *)arg1 { // disable widgets swipe

	if (isDejaVuActive)
		return NO;
	else
		return %orig;

}

%end

%hook UIStatusBar_Modern

- (void)setFrame:(CGRect)arg1 { // add a notification observer

	if (hideStatusBarSwitch && !hasAddedStatusBarObserver) {
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuHideElements" object:nil];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuUnhideElements" object:nil];
		hasAddedStatusBarObserver = YES;
	}

	return %orig;

}

%new
- (void)setVisibility:(NSNotification *)notification { // hide or unhide the status bar

	if ([notification.name isEqual:@"dejavuHideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[[self statusBar] setAlpha:0];
		} completion:nil];
	} else if ([notification.name isEqual:@"dejavuUnhideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[[self statusBar] setAlpha:1];
		} completion:nil];
	}

}

%end

%hook SBUIProudLockIconView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

	if (hideFaceIDLockSwitch) {
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuHideElements" object:nil];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuUnhideElements" object:nil];
	}

	return %orig;

}

%new
- (void)setVisibility:(NSNotification *)notification { // hide or unhide the faceid lock

	if ([notification.name isEqual:@"dejavuHideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[[self superview] setAlpha:0];
		} completion:nil];
	} else if ([notification.name isEqual:@"dejavuUnhideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[[self superview] setAlpha:1];
		} completion:nil];
	}

}

%end

%hook SBFLockScreenDateView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

	if (hideTimeAndDateSwitch) {
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuHideElements" object:nil];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuUnhideElements" object:nil];
	}

	if (pixelShiftSwitch && !hideTimeAndDateSwitch) {
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self selector:@selector(shift) name:@"dejavuPixelShift" object:nil];
		[notificationCenter addObserver:self selector:@selector(resetShift) name:@"dejavuResetPixelShift" object:nil];
	}

	return %orig;

}

%new
- (void)setVisibility:(NSNotification *)notification { // hide or unhide the time and date

	if ([notification.name isEqual:@"dejavuHideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:0];
		} completion:nil];
	} else if ([notification.name isEqual:@"dejavuUnhideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:1];
		} completion:nil];
	}

}

%new
- (void)shift { // pixel shift

	if (!loadedTimeAndDateFrame) originalTimeAndDateFrame = [self frame];
	loadedTimeAndDateFrame = YES;

	int direction = arc4random_uniform(2);
	CGRect newFrame = originalTimeAndDateFrame;

	if (direction == 0)
		newFrame.origin.x += arc4random_uniform(15);
	else if (direction == 1)
		newFrame.origin.y += arc4random_uniform(15);

	[self setFrame:newFrame];

}

%new
- (void)resetShift { // reset frame

	[self setFrame:originalTimeAndDateFrame];

}

%end

%hook CSAdjunctItemView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

	if (hideMediaPlayerSwitch) {
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuHideElements" object:nil];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuUnhideElements" object:nil];
	}

	return %orig;

}

%new
- (void)setVisibility:(NSNotification *)notification { // hide or unhide the media player

	if ([notification.name isEqual:@"dejavuHideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:0];
		} completion:nil];
	} else if ([notification.name isEqual:@"dejavuUnhideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:1];
		} completion:nil];
	}

}

%end

%hook CSQuickActionsButton

- (id)initWithFrame:(CGRect)frame { // add a notification observer

	if (hideQuickActionsSwitch) {
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuHideElements" object:nil];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuUnhideElements" object:nil];
	}

	return %orig;

}

%new
- (void)setVisibility:(NSNotification *)notification { // hide or unhide the quick actions

	if ([notification.name isEqual:@"dejavuHideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:0];
		} completion:nil];
	} else if ([notification.name isEqual:@"dejavuUnhideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:1];
		} completion:nil];
	}

}

%end

%hook CSTeachableMomentsContainerView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

	if (hideUnlockTextAndHomebarSwitch) {
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuHideElements" object:nil];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuUnhideElements" object:nil];
	}

	return %orig;

}

%new
- (void)setVisibility:(NSNotification *)notification { // hide or unhide the unlock label and control center indicator

	if ([notification.name isEqual:@"dejavuHideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:0];
		} completion:nil];
	} else if ([notification.name isEqual:@"dejavuUnhideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:1];
		} completion:nil];
	}

}

%end

%hook CSHomeAffordanceView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

	if (hideUnlockTextAndHomebarSwitch) {
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuHideElements" object:nil];
		[notificationCenter addObserver:self selector:@selector(setVisibility:) name:@"dejavuUnhideElements" object:nil];
	}

	return %orig;

}

%new
- (void)setVisibility:(NSNotification *)notification { // hide or unhide the homebar

	if ([notification.name isEqual:@"dejavuHideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:0];
		} completion:nil];
	} else if ([notification.name isEqual:@"dejavuUnhideElements"]) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:1];
		} completion:nil];
	}

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.dejavupreferences"];

	[preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

	// behavior
	[preferences registerBool:&onlyWhenChargingSwitch default:NO forKey:@"onlyWhenCharging"];
	[preferences registerBool:&disableWhileChargingSwitch default:YES forKey:@"disableWhileCharging"];
	[preferences registerBool:&deactivateWithTapSwitch default:YES forKey:@"deactivateWithTap"];
	[preferences registerBool:&deactivateWithRaiseToWakeSwitch default:YES forKey:@"deactivateWithRaiseToWake"];
	[preferences registerBool:&deactivateAfterInactivitySwitch default:YES forKey:@"deactivateAfterInactivity"];
	[preferences registerUnsignedInteger:&inactivityAmountValue default:15 forKey:@"inactivityAmount"];
	[preferences registerBool:&enableHapticFeedbackSwitch default:NO forKey:@"enableHapticFeedback"];
	[preferences registerUnsignedInteger:&hapticFeedbackStrengthValue default:0 forKey:@"hapticFeedbackStrength"];
	[preferences registerBool:&disableBiometricsSwitch default:YES forKey:@"disableBiometrics"];
	[preferences registerBool:&pocketDetectionSwitch default:YES forKey:@"pocketDetection"];
	[preferences registerBool:&dimDisplaySwitch default:NO forKey:@"dimDisplay"];
	[preferences registerBool:&pixelShiftSwitch default:YES forKey:@"pixelShift"];
	[preferences registerBool:&enableLowPowerModeSwitch default:YES forKey:@"enableLowPowerMode"];
	[preferences registerBool:&enableDoNotDisturbSwitch default:NO forKey:@"enableDoNotDisturb"];
	[preferences registerBool:&disableControlCenterSwitch default:YES forKey:@"disableControlCenter"];

	// customization
	[preferences registerBool:&hideStatusBarSwitch default:YES forKey:@"hideStatusBar"];
	[preferences registerBool:&hideFaceIDLockSwitch default:YES forKey:@"hideFaceIDLock"];
	[preferences registerBool:&hideTimeAndDateSwitch default:NO forKey:@"hideTimeAndDate"];
	[preferences registerBool:&hideMediaPlayerSwitch default:NO forKey:@"hideMediaPlayer"];
	[preferences registerBool:&hideQuickActionsSwitch default:YES forKey:@"hideQuickActions"];
	[preferences registerBool:&hideUnlockTextAndHomebarSwitch default:YES forKey:@"hideUnlockTextAndHomebar"];

	%init(DejaVu);

}