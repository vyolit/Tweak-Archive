#import "Nita.h"

%group Nita

%hook _UIStatusBarStringView

- (void)setText:(id)arg1 { // set emoji

	if (replaceCarrierSwitch && ![arg1 containsString:@":"] && ![arg1 containsString:@"%"] && ![arg1 containsString:@"2G"] && ![arg1 containsString:@"3G"] && ![arg1 containsString:@"4G"] && ![arg1 containsString:@"5G"] && ![arg1 containsString:@"LTE"] && ![arg1 isEqualToString:@"E"]) {
		[self getEmojis];

		if (showEmojiSwitch && !showTemperatureSwitch)
			arg1 = weatherString;
		else if (showEmojiSwitch && showTemperatureSwitch)
			arg1 = [NSString stringWithFormat:@"%@ %@", weatherString, [[PDDokdo sharedInstance] currentTemperature]];
		else if (!showEmojiSwitch && showTemperatureSwitch)
			arg1 = [NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentTemperature]];
		else
			arg1 = condition;

		return %orig(arg1);
	} else if (replaceTimeSwitch && [arg1 containsString:@":"]) {
		[self getEmojis];

		if (showEmojiSwitch && !showTemperatureSwitch)
			arg1 = weatherString;
		else if (showEmojiSwitch && showTemperatureSwitch)
			arg1 = [NSString stringWithFormat:@"%@ %@", weatherString, [[PDDokdo sharedInstance] currentTemperature]];
		else if (!showEmojiSwitch && showTemperatureSwitch)
			arg1 = [NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentTemperature]];
		else
			arg1 = condition;

		return %orig(arg1);
	} else if (alongsideTimeSwitch && [arg1 containsString:@":"]) {
		[self getEmojis];

		if (showEmojiSwitch && !showTemperatureSwitch)
			arg1 = [NSString stringWithFormat:@"%@ %@", arg1, weatherString];
		else if (showEmojiSwitch && showTemperatureSwitch)
			arg1 = [NSString stringWithFormat:@"%@ %@ %@", arg1, weatherString, [[PDDokdo sharedInstance] currentTemperature]];
		else if (!showEmojiSwitch && showTemperatureSwitch)
			arg1 = [NSString stringWithFormat:@"%@ %@", arg1, [[PDDokdo sharedInstance] currentTemperature]];
		else
			arg1 = condition;

		return %orig(arg1);
	} else {
		return %orig;
	}

}

%new
- (void)getEmojis { // get emoji based on condition

	WALockscreenWidgetViewController* weatherWidget = [[PDDokdo sharedInstance] weatherWidget];
	WAForecastModel* currentModel = [weatherWidget currentForecastModel];
	WACurrentForecast* currentCond = [currentModel currentConditions];
	NSInteger currentCode = [currentCond conditionCode];
	int hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:[NSDate date]];

	if (currentCode <= 2)
		weatherString = @"🌪";
	else if (currentCode <= 4)
		weatherString = @"⛈";
	else if (currentCode <= 8)
		weatherString = @"🌨";
	else if (currentCode == 9)
		weatherString = @"🌧";
	else if (currentCode == 10)
		weatherString = @"🌨";
	else if (currentCode <= 12)
		weatherString = @"🌧";
	else if (currentCode <= 18)
		weatherString = @"🌨";
	else if (currentCode <= 22)
		weatherString = @"🌫";
	else if (currentCode <= 24)
		weatherString = @"💨";
	else if (currentCode == 25)
		weatherString = @"❄️";
	else if (currentCode == 26)
		weatherString = @"☁️";
	else if (currentCode <= 28)
		weatherString = @"🌥";
	else if (currentCode <= 30)
		weatherString = @"⛅️";
	else if (currentCode <= 32 && (hour >= 18 || hour <= 6))
		weatherString = @"🌙";
	else if (currentCode <= 32)
		weatherString = @"☀️";
	else if (currentCode <= 34)
		weatherString = @"🌤";
	else if (currentCode == 35)
		weatherString = @"🌧";
	else if (currentCode == 36)
		weatherString = @"🔥";
	else if (currentCode <= 38)
		weatherString = @"🌩";
	else if (currentCode == 39)
		weatherString = @"🌦";
	else if (currentCode == 40)
		weatherString = @"🌧";
	else if (currentCode <= 43)
		weatherString = @"🌨";
	else
		weatherString = @"N/A";

}

%end

%hook _UIStatusBarDisplayItem

- (void)setEnabled:(BOOL)arg1 { // hide the location icon in the status bar when nita is used alongside the time

	if (!alongsideTimeSwitch) return %orig;

	if ([[self item] isKindOfClass:%c(_UIStatusBarIndicatorLocationItem)])
		return %orig(NO);
	else
		return %orig;

}

%end

%hook SBDeviceApplicationSceneStatusBarBreadcrumbProvider

+ (BOOL)_shouldAddBreadcrumbToActivatingSceneEntity:(id)arg1 sceneHandle:(id)arg2 withTransitionContext:(id)arg3 { // hide breadcrumbs

	if (hideBreadcrumbsSwitch)
		return NO;
	else
		return %orig;

}

%end

%hook SBControlCenterController

- (void)_willPresent { // update data when control center was opened

	%orig;

	[[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated { // update data when lockscreen appears

	%orig;

	[[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%hook SBBacklightController

- (void)turnOnScreenFullyWithBacklightSource:(long long)source { // update data when screen was turned on

	%orig;

	if (![[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible]) return;
	[[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.nitapreferences"];

  	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	if (!enabled) return;

	// position
	[preferences registerBool:&replaceCarrierSwitch default:YES forKey:@"replaceCarrier"];
	[preferences registerBool:&replaceTimeSwitch default:NO forKey:@"replaceTime"];
	[preferences registerBool:&alongsideTimeSwitch default:NO forKey:@"alongsideTime"];

	// visibility
	[preferences registerBool:&showEmojiSwitch default:YES forKey:@"showEmoji"];
	[preferences registerBool:&showTemperatureSwitch default:NO forKey:@"showTemperature"];

	// miscellaneous
	[preferences registerBool:&hideBreadcrumbsSwitch default:YES forKey:@"hideBreadcrumbs"];

	%init(Nita);

}