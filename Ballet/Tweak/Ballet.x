#import "Ballet.h"

%group BalletImage

%hook HBAppGridViewController

%property(nonatomic, retain)UIImageView* wallpaperView;

- (void)viewDidLoad { // add image wallpaper

	%orig;

	if ([self wallpaperView]) return;

	self.wallpaperView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	[[self wallpaperView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self wallpaperView] setContentMode:UIViewContentModeScaleAspectFill];
	[[self wallpaperView] setImage:[UIImage imageWithContentsOfFile:@"/Library/Ballet/wallpaper.png"]];
	[[self view] insertSubview:[self wallpaperView] atIndex:0];

}

%end

%end

%group BalletVideo

%hook HBAppGridViewController

%property(nonatomic, retain)AVQueuePlayer* player;
%property(nonatomic, retain)AVPlayerItem* playerItem;
%property(nonatomic, retain)AVPlayerLooper* playerLooper;
%property(nonatomic, retain)AVPlayerLayer* playerLayer;

- (void)viewDidLoad { // add video wallpaper

	%orig;

	if ([self playerLayer]) return;

    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"/Library/Ballet/wallpaper.mp4"]]];

    self.player = [AVQueuePlayer playerWithPlayerItem:[self playerItem]];
    [[self player] setMuted:YES];
	[[self player] setPreventsDisplaySleepDuringVideoPlayback:NO];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

	self.playerLooper = [AVPlayerLooper playerLooperWithPlayer:[self player] templateItem:[self playerItem]];

    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:[self player]];
    [[self playerLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [[self playerLayer] setFrame:[[[self view] layer] bounds]];
    [[[self view] layer] insertSublayer:[self playerLayer] atIndex:0];

	[[self player] play];

}

- (void)didFinishLaunchAnimationWithContext:(id)arg1 { // play when homescreen appeared

	%orig;

	[[self player] play];

}

%end

%end

%group BalletCompletion

%hook HBUIMainAppGridTopShelfContainerView

- (void)didMoveToWindow { // hide top shelf view

	%orig;

	[self removeFromSuperview];

}

%end

%end

static void loadPrefs() {

	NSMutableDictionary* preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/love.litten.balletpreferences.plist"];
  
	enabled = [([preferences objectForKey:@"Enabled"] ?: @(NO)) boolValue];

	useImageWallpaperSwitch = [([preferences objectForKey:@"useImageWallpaper"] ?: @(NO)) boolValue];
	useVideoWallpaperSwitch = [([preferences objectForKey:@"useVideoWallpaper"] ?: @(NO)) boolValue];

}

%ctor {

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) loadPrefs, CFSTR("love.litten.balletpreferences.update"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	loadPrefs();
	
	if (enabled) {
		if (useImageWallpaperSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/Ballet/wallpaper.png"]) {
			%init(BalletImage);
			return;
		} else if (useVideoWallpaperSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/Ballet/wallpaper.mp4"]) {
			%init(BalletVideo);
			return;
		}
		%init(BalletCompletion);
	}

}