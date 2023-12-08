#import "VioletSpotify.h"

%group VioletSpotify

%hook MPNowPlayingInfoCenter

- (void)setNowPlayingInfo:(id)arg1 { // post notification for artwork changes
	
	%orig;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Violet-setSpotifyArtwork" object:nil];
    });

}

%end

%hook SPTNowPlayingViewController

%new
- (void)setArtwork { // get and set the artwork

	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		NSDictionary* dictionary = (__bridge NSDictionary *)information;
		if (dictionary) {
			currentArtwork = [UIImage imageWithData:[dictionary objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
			if (currentArtwork) {
				[spotifyArtworkBackgroundImageView setImage:currentArtwork];
				[spotifyArtworkBackgroundImageView setHidden:NO];
			}
      	}
  	});

}

- (void)viewDidLoad { // add artwork background

	%orig;

	if (!spotifyArtworkBackgroundSwitch) return;
	if (!spotifyArtworkBackgroundImageView) spotifyArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	[spotifyArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[spotifyArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[spotifyArtworkBackgroundImageView setHidden:currentArtwork ? NO : YES];
	[spotifyArtworkBackgroundImageView setAlpha:[spotifyArtworkOpacityValue doubleValue]];
	if (![spotifyArtworkBackgroundImageView isDescendantOfView:[self view]]) [[self view] insertSubview:spotifyArtworkBackgroundImageView atIndex:0];

	if ([spotifyArtworkBlurMode intValue] != 0) {
		if (!spotifyBlur) {
			if ([spotifyArtworkBlurMode intValue] == 1)
				spotifyBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([spotifyArtworkBlurMode intValue] == 2)
				spotifyBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			else if ([spotifyArtworkBlurMode intValue] == 3)
				spotifyBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		}
		if (!spotifyBlurView) spotifyBlurView = [[UIVisualEffectView alloc] initWithEffect:spotifyBlur];
		[spotifyBlurView setFrame:[spotifyArtworkBackgroundImageView bounds]];
		[spotifyBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[spotifyBlurView setAlpha:[spotifyArtworkBlurAmountValue doubleValue]];
		if (![spotifyBlurView isDescendantOfView:spotifyArtworkBackgroundImageView]) [spotifyArtworkBackgroundImageView addSubview:spotifyBlurView];
	}

	if ([spotifyArtworkDimValue doubleValue] != 0.0) {
		if (!spotifyDimView) spotifyDimView = [[UIView alloc] initWithFrame:[spotifyArtworkBackgroundImageView bounds]];
		[spotifyDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[spotifyDimView setBackgroundColor:[UIColor blackColor]];
		[spotifyDimView setAlpha:[spotifyArtworkDimValue doubleValue]];
		if (![spotifyDimView isDescendantOfView:spotifyArtworkBackgroundImageView]) [spotifyArtworkBackgroundImageView addSubview:spotifyDimView];
	}

	NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self];
	[notificationCenter addObserver:self selector:@selector(setArtwork) name:@"Violet-setSpotifyArtwork" object:nil];

}

- (void)viewWillAppear:(BOOL)animated { // set the artwork when the now playing view appears

	%orig;

	[self setArtwork];

}

%end

%hook SPTNowPlayingCoverArtCell

- (void)didMoveToWindow { // hide the original artwork

	%orig;

	if (hideArtworkSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingNextTrackButton

- (void)didMoveToWindow { // hide the next track button

	%orig;

	if (hideNextTrackButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingPreviousTrackButton

- (void)didMoveToWindow { // hide the previous track button

	%orig;

	if (hidePreviousTrackButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingPlayButtonV2

- (void)didMoveToWindow { // hide the play/pause button

	%orig;

	if (hidePlayButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingShuffleButton

- (void)didMoveToWindow { // hide the shuffle button

	%orig;

	if (hideShuffleButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingRepeatButton

- (void)didMoveToWindow { // hide the repeat button

	%orig;

	if (hideRepeatButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTGaiaDevicesAvailableViewImplementation

- (void)didMoveToWindow { // hide the devices button

	%orig;

	if (hideDevicesButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingQueueButton

- (void)didMoveToWindow { // hide the queue button

	%orig;

	if (hideDevicesButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingSliderV2

- (void)didMoveToWindow { // hide the time slider

	%orig;

	if (hideTimeSliderSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingDurationViewV2

- (void)didMoveToWindow { // hide the remaining and or elapsed time label

	%orig;

	if (hideRemainingTimeLabelSwitch) {
		UILabel* remainingTimeLabel = [self valueForKey:@"_timeRemainingLabel"];
		[remainingTimeLabel setHidden:YES];
	}

	if (hideElapsedTimeLabelSwitch) {
		UILabel* elapsedTimeLabel = [self valueForKey:@"_timeTakenLabel"];
		[elapsedTimeLabel setHidden:YES];
	}

}

%end

%hook SPTNowPlayingAnimatedLikeButton

- (void)didMoveToWindow { // hide the like button

	%orig;

	if (hideLikeButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingTitleButton

- (void)didMoveToWindow { // hide the back button

	%orig;

	if (hideBackButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTContextMenuAccessoryButton

- (void)didMoveToWindow { // hide the context button

	%orig;

	if (hideContextButtonSwitch) [self setHidden:YES];

}

%end

%hook SPTNowPlayingNavigationBarViewV2

- (void)didMoveToWindow { // hide the playlist title

	%orig;

	if (hidePlaylistTitleSwitch) {
		SPTNowPlayingMarqueeLabel* title = [self valueForKey:@"_titleLabel"];
		[title setHidden:YES];
	}

}

%end

%hook SPTNowPlayingMarqueeLabel

- (void)didMoveToWindow { // hide the song title, artist name and or playlist title

	%orig;

	if (hideSongTitleSwitch) {
		UILabel* songTitle = [self valueForKey:@"_label"];
		[songTitle setHidden:YES];
	}

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.violetpreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	if (!enabled) return;

	// spotify
	[preferences registerBool:&spotifyArtworkBackgroundSwitch default:NO forKey:@"spotifyArtworkBackground"];
	[preferences registerObject:&spotifyArtworkBlurMode default:@"0" forKey:@"spotifyArtworkBlur"];
	[preferences registerObject:&spotifyArtworkBlurAmountValue default:@"1.0" forKey:@"spotifyArtworkBlurAmount"];
	[preferences registerObject:&spotifyArtworkOpacityValue default:@"1.0" forKey:@"spotifyArtworkOpacity"];
	[preferences registerObject:&spotifyArtworkDimValue default:@"0.0" forKey:@"spotifyArtworkDim"];
	[preferences registerBool:&hideArtworkSwitch default:NO forKey:@"spotifyHideArtwork"];
	[preferences registerBool:&hideNextTrackButtonSwitch default:NO forKey:@"spotifyHideNextTrackButton"];
	[preferences registerBool:&hidePreviousTrackButtonSwitch default:NO forKey:@"spotifyHidePreviousTrackButton"];
	[preferences registerBool:&hidePlayButtonSwitch default:NO forKey:@"spotifyHidePlayButton"];
	[preferences registerBool:&hideShuffleButtonSwitch default:NO forKey:@"spotifyHideShuffleButton"];
	[preferences registerBool:&hideRepeatButtonSwitch default:NO forKey:@"spotifyHideRepeatButton"];
	[preferences registerBool:&hideDevicesButtonSwitch default:NO forKey:@"spotifyHideDevicesButton"];
	[preferences registerBool:&hideQueueButtonSwitch default:NO forKey:@"spotifyHideQueueButton"];
	[preferences registerBool:&hideSongTitleSwitch default:NO forKey:@"spotifyHideSongTitle"];
	[preferences registerBool:&hideTimeSliderSwitch default:NO forKey:@"spotifyHideTimeSlider"];
	[preferences registerBool:&hideRemainingTimeLabelSwitch default:NO forKey:@"spotifyHideRemainingTimeLabel"];
	[preferences registerBool:&hideElapsedTimeLabelSwitch default:NO forKey:@"spotifyHideElapsedTimeLabel"];
	[preferences registerBool:&hideLikeButtonSwitch default:NO forKey:@"spotifyHideLikeButton"];
	[preferences registerBool:&hideBackButtonSwitch default:NO forKey:@"spotifyHideBackButton"];
	[preferences registerBool:&hideContextButtonSwitch default:NO forKey:@"spotifyHideContextButton"];
	[preferences registerBool:&hidePlaylistTitleSwitch default:NO forKey:@"spotifyHidePlaylistTitle"];

	%init(VioletSpotify);

}