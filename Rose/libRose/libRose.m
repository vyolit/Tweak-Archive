#import "public/libRose.h"

@implementation libRose

+ (void)prepareForHaptic:(BOOL)tapticEngine :(BOOL)hapticEngine :(BOOL)legacyEngine :(int)tapticStrength :(int)hapticStrength  {

	if (hapticEngine && !tapticEngine && !legacyEngine) {
		if (hapticStrength == 0)
			AudioServicesPlaySystemSound(1519);
		else if (hapticStrength == 1)
			AudioServicesPlaySystemSound(1520);
		else if (hapticStrength == 2)
			AudioServicesPlaySystemSound(1521);
	}

	if (tapticEngine && !hapticEngine && !legacyEngine) {
		UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] init];
		[gen prepare];

		if (tapticStrength == 0)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
		else if (tapticStrength == 1)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
		else if (tapticStrength == 2)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
		else if (tapticStrength == 3)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleSoft];
		else if (tapticStrength == 4)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleRigid];

		[gen impactOccurred];
	}

}

+ (void)triggerFeedback:(BOOL)LowPowerModeSwitch :(BOOL)LowPowerMode :(BOOL)isDNDActiveSwitch :(BOOL)isDNDActive :(BOOL)isRingerSilentSwitch :(BOOL)isRingerSilent :(BOOL)delaySwitch :(double)delay :(BOOL)enabled :(BOOL)tapticEngine :(BOOL)hapticEngine :(BOOL)legacyEngine :(int)tapticStrength :(int)hapticStrength {

if ((LowPowerModeSwitch && LowPowerMode) || (isDNDActiveSwitch && isDNDActive) || (isRingerSilentSwitch && !isRingerSilent) || !enabled) return;
	if (!delaySwitch) {
		[self prepareForHaptic:tapticEngine :hapticEngine :legacyEngine :tapticStrength :hapticStrength];
	} else if (delaySwitch) {
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[self prepareForHaptic:tapticEngine :hapticEngine :legacyEngine :tapticStrength :hapticStrength];
		});
	}

}

+ (void)prepareCustomFeedback:(int)strength {

	if (strength > 0 && strength < 4) {
		if (strength == 1)
			AudioServicesPlaySystemSound(1519);
		else if (strength == 2)
			AudioServicesPlaySystemSound(1520);
		else if (strength == 3)
			AudioServicesPlaySystemSound(1521);
	}

	if (strength > 3 && strength < 9) {
		UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] init];
		[gen prepare];

		if (strength == 4)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
		else if (strength == 5)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
		else if (strength == 6)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
		else if (strength == 7)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleSoft];
		else if (strength == 8)
			gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleRigid];

		[gen impactOccurred];
	}

}

+ (void)triggerCustomFeedback:(BOOL)LowPowerModeSwitch :(BOOL)LowPowerMode :(BOOL)isDNDActiveSwitch :(BOOL)isDNDActive :(BOOL)isRingerSilentSwitch :(BOOL)isRingerSilent :(BOOL)delaySwitch :(double)delay :(BOOL)enabled :(BOOL)tapticEngine :(BOOL)hapticEngine :(BOOL)legacyEngine :(int)strength {

	if ((LowPowerModeSwitch && LowPowerMode) || (isDNDActiveSwitch && isDNDActive) || (isRingerSilentSwitch && !isRingerSilent) || !enabled) return;
	if (!delaySwitch) {
		[self prepareCustomFeedback:strength];
	} else if (delaySwitch) {
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[self prepareCustomFeedback:strength];
		});
	}

}

// https://stackoverflow.com/a/43816242
void AudioServicesPlaySystemSoundWithVibration(UInt32 inSystemSoundID, id arg, NSDictionary* vibratePattern);

+ (void)prepareLegacyFeedback:(float)durationInSeconds intensivity:(float)intensivity count:(long)count {

    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* arr = [NSMutableArray array];

    for (long i = count; i--;) {
		[arr addObject:[NSNumber numberWithBool:YES]];
        [arr addObject:[NSNumber numberWithInt:durationInSeconds * 1000]];

        [arr addObject:[NSNumber numberWithBool:NO]];
        [arr addObject:[NSNumber numberWithInt:durationInSeconds * 1000]];
    }

    [dict setObject:arr forKey:@"VibePattern"];
    [dict setObject:[NSNumber numberWithFloat:intensivity] forKey:@"Intensity"];

    AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);

}

+ (void)triggerLegacyFeedback:(BOOL)LowPowerModeSwitch :(BOOL)LowPowerMode :(BOOL)isDNDActiveSwitch :(BOOL)isDNDActive :(BOOL)isRingerSilentSwitch :(BOOL)isRingerSilent :(BOOL)delaySwitch :(double)delay :(BOOL)enabled :(BOOL)tapticEngine :(BOOL)hapticEngine :(BOOL)legacyEngine :(double)customLegacyDuration :(double)customLegacyStrength :(int)selectedLegacyMode {

	if ((LowPowerModeSwitch && LowPowerMode) || (isDNDActiveSwitch && isDNDActive) || (isRingerSilentSwitch && !isRingerSilent) || !enabled) return;
	if (!delaySwitch && !tapticEngine && !hapticEngine) {
		if (selectedLegacyMode == 0)
				[self prepareLegacyFeedback:0.025 intensivity:0.05 count:1];
		else if (selectedLegacyMode == 1)
				[self prepareLegacyFeedback:customLegacyDuration intensivity:customLegacyStrength count:1];
	} else if (delaySwitch && !tapticEngine && !hapticEngine) {
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			if (selectedLegacyMode == 0)
				[self prepareLegacyFeedback:0.025 intensivity:0.05 count:1];
			else if (selectedLegacyMode == 1)
				[self prepareLegacyFeedback:customLegacyDuration intensivity:customLegacyStrength count:1];
		});
		
	}

}

@end