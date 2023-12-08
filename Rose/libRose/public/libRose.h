#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface libRose : NSObject
+ (void)prepareForHaptic:(BOOL)tapticEngine :(BOOL)hapticEngine :(BOOL)legacyEngine :(int)tapticStrength :(int)hapticStrength;
+ (void)triggerFeedback:(BOOL)LowPowerModeSwitch :(BOOL)LowPowerMode :(BOOL)isDNDActiveSwitch :(BOOL)isDNDActive :(BOOL)isRingerSilentSwitch :(BOOL)isRingerSilent :(BOOL)delaySwitch :(double)delay :(BOOL)enabled :(BOOL)tapticEngine :(BOOL)hapticEngine :(BOOL)legacyEngine :(int)tapticStrength :(int)hapticStrength;
+ (void)prepareCustomFeedback:(int)strength;
+ (void)triggerCustomFeedback:(BOOL)LowPowerModeSwitch :(BOOL)LowPowerMode :(BOOL)isDNDActiveSwitch :(BOOL)isDNDActive :(BOOL)isRingerSilentSwitch :(BOOL)isRingerSilent :(BOOL)delaySwitch :(double)delay :(BOOL)enabled :(BOOL)tapticEngine :(BOOL)hapticEngine :(BOOL)legacyEngine :(int)strength;
+ (void)prepareLegacyFeedback:(float)durationInSeconds intensivity:(float)intensivity count:(long)count;
+ (void)triggerLegacyFeedback:(BOOL)LowPowerModeSwitch :(BOOL)LowPowerMode :(BOOL)isDNDActiveSwitch :(BOOL)isDNDActive :(BOOL)isRingerSilentSwitch :(BOOL)isRingerSilent :(BOOL)delaySwitch :(double)delay :(BOOL)enabled :(BOOL)tapticEngine :(BOOL)hapticEngine :(BOOL)legacyEngine :(double)customLegacyDuration :(double)customLegacyStrength :(int)selectedLegacyMode;
@end