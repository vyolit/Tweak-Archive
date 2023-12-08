#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

// volume control mode
BOOL volumeModeControlSwitch = YES;
NSString* volumeThresholdValue = @"0.3";
NSString* volumeDecreaseModeValue = @"0";
NSString* volumeIncreaseModeValue = @"2";

// call mode
BOOL callControlSwitch = YES;
NSString* inCallModeValue = @"0";
NSString* outOfCallModeValue = @"2";

// music mode
BOOL musicControlSwitch = YES;
NSString* playingModeValue = @"2";
NSString* pausedModeValue = @"0";

// miscellaneous
BOOL pauseAtZeroVolumeSwitch = YES;

@interface SBVolumeControl : NSObject
- (float)_effectiveVolume;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
- (BOOL)isPaused;
- (id)_nowPlayingInfo;
- (BOOL)playForEventSource:(long long)arg1;
- (BOOL)pauseForEventSource:(long long)arg1;
@end

@interface AVOutputDevice : NSObject
- (void)setCurrentBluetoothListeningMode:(NSString *)arg1;
@end

@interface MPAVRoute : NSObject
- (id)logicalLeaderOutputDevice;
@end

@interface MPAVRoutingController : NSObject
@property(readonly, nonatomic)MPAVRoute* pickedRoute;
@end