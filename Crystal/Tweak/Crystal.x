#import "Crystal.h"

%group CrystalVolume

%hook SBVolumeControl

- (void)increaseVolume { // change mode or play when increasing volume

	%orig;

	if ([self _effectiveVolume] >= [volumeThresholdValue doubleValue]) {
		if ([volumeIncreaseModeValue intValue] == 0) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeAudioTransparency"];
		else if ([volumeIncreaseModeValue intValue] == 1) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeNormal"];
		else if ([volumeIncreaseModeValue intValue] == 2) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation"];
	}

}

- (void)decreaseVolume { // change mode or pause when decreasing volume

	%orig;

	if ([self _effectiveVolume] <= [volumeThresholdValue doubleValue]) {
		if ([volumeDecreaseModeValue intValue] == 0) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeAudioTransparency"];
		else if ([volumeDecreaseModeValue intValue] == 1) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeNormal"];
		else if ([volumeDecreaseModeValue intValue] == 2) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation"];
	}

}

%end

%end

%group CrystalCall

%hook TUCall

- (int)status { // change listening mode when a call connected or a call ended

	if (!callControlSwitch) return %orig;

	int orig = %orig;

	if (orig != 6) {
		if ([inCallModeValue intValue] == 0) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeAudioTransparency"];
		else if ([inCallModeValue intValue] == 1) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeNormal"];
		else if ([inCallModeValue intValue] == 2) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation"];
	} else if (orig == 6) {
		if ([outOfCallModeValue intValue] == 0) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeAudioTransparency"];
		else if ([outOfCallModeValue intValue] == 1) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeNormal"];
		else if ([outOfCallModeValue intValue] == 2) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation"];
	}

	return orig;

}

%end

%end

%group CrystalMusic

%hook SBMediaController

- (void)_mediaRemoteNowPlayingApplicationIsPlayingDidChange:(id)arg1 { // change listening mode when is playing changed

	%orig;

	if (!musicControlSwitch) return;
	if ([self _nowPlayingInfo] == nil) return;

	if ([self isPlaying]) {
		if ([playingModeValue intValue] == 0) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeAudioTransparency"];
		else if ([playingModeValue intValue] == 1) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeNormal"];
		else if ([playingModeValue intValue] == 2) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation"];
	} else if ([self isPaused]) {
		if ([pausedModeValue intValue] == 0) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeAudioTransparency"];
		else if ([pausedModeValue intValue] == 1) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeNormal"];
		else if ([pausedModeValue intValue] == 2) [[[[[[%c(SBMediaController) sharedInstance] valueForKey:@"_routingController"] pickedRoute] logicalLeaderOutputDevice] valueForKey:@"_avOutputDevice"] setCurrentBluetoothListeningMode:@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation"];
	}

}

%end

%end

%group CrystalMiscellaneous

%hook SBVolumeControl

- (void)increaseVolume { // resume music when volume is above 0

	%orig;

	if ([self _effectiveVolume] < 0.1 && [[%c(SBMediaController) sharedInstance] isPaused]) [[%c(SBMediaController) sharedInstance] playForEventSource:0];

}

- (void)decreaseVolume { // pause music when volume is 0

	%orig;

	if ([self _effectiveVolume] < 0.1 && ![[%c(SBMediaController) sharedInstance] isPaused]) [[%c(SBMediaController) sharedInstance] pauseForEventSource:0];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.crystalpreferences"];
	
	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	if (!enabled) return;
	
	// volume control mode
	[preferences registerBool:&volumeModeControlSwitch default:YES forKey:@"volumeModeControl"];
	if (volumeModeControlSwitch) {
		[preferences registerObject:&volumeThresholdValue default:@"0.3" forKey:@"volumeThreshold"];
		[preferences registerObject:&volumeDecreaseModeValue default:@"0" forKey:@"volumeDecreaseMode"];
		[preferences registerObject:&volumeIncreaseModeValue default:@"2" forKey:@"volumeIncreaseMode"];
		%init(CrystalVolume);
	}
	
	// call mode
	[preferences registerBool:&callControlSwitch default:YES forKey:@"callControl"];
	if (callControlSwitch) {
		[preferences registerObject:&inCallModeValue default:@"0" forKey:@"inCallMode"];
		[preferences registerObject:&outOfCallModeValue default:@"2" forKey:@"outOfCallMode"];
		%init(CrystalCall);
	}

	// music mode
	[preferences registerBool:&musicControlSwitch default:YES forKey:@"musicControl"];
	if (musicControlSwitch) {
		[preferences registerObject:&playingModeValue default:@"2" forKey:@"playingMode"];
		[preferences registerObject:&pausedModeValue default:@"0" forKey:@"pausedMode"];
		%init(CrystalMusic);
	}

	[preferences registerBool:&pauseAtZeroVolumeSwitch default:YES forKey:@"pauseAtZeroVolume"];
	if (pauseAtZeroVolumeSwitch) %init(CrystalMiscellaneous);

}