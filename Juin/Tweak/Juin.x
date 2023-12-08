#import "Juin.h"

MediaControlsTimeControl* timeSlider = nil;
MRUNowPlayingTimeControlsView* newTimeSlider = nil;
CSCoverSheetView* coversheetView = nil;

%group Juin

%hook CSCoverSheetView

%property(nonatomic, retain)UIView* juinView;
%property(nonatomic, retain)UIImageView* juinBackgroundArtwork;
%property(nonatomic, retain)UIVisualEffectView* blurView;
%property(nonatomic, retain)UIBlurEffect* blur;
%property(nonatomic, retain)CAGradientLayer* gradient;
%property(nonatomic, retain)UILabel* sourceLabel;
%property(nonatomic, retain)UIButton* playPauseButton;
%property(nonatomic, retain)UIButton* rewindButton;
%property(nonatomic, retain)UIButton* skipButton;
%property(nonatomic, retain)UILabel* artistLabel;
%property(nonatomic, retain)UILabel* songLabel;
%property(nonatomic, retain)UIView* gestureView;
%property(nonatomic, retain)UITapGestureRecognizer* tap;
%property(nonatomic, retain)UISwipeGestureRecognizer* leftSwipe;
%property(nonatomic, retain)UISwipeGestureRecognizer* rightSwipe;

- (id)initWithFrame:(CGRect)frame { // get a coversheetview instance

	id orig = %orig;
	coversheetView = self;

	return orig;

}

- (void)didMoveToWindow { // add juin

	%orig;

	if ([self juinView]) return;


	// juin view
	self.juinView = [[UIView alloc] initWithFrame:[self bounds]];
	[[self juinView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self juinView] setHidden:YES];
	[self addSubview:[self juinView]];


	// background artwork
	if (backgroundArtworkSwitch) {
		self.juinBackgroundArtwork = [[UIImageView alloc] initWithFrame:[[self juinView] bounds]];
		[[self juinBackgroundArtwork] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[[self juinBackgroundArtwork] setContentMode:UIViewContentModeScaleAspectFill];
		[[self juinBackgroundArtwork] setHidden:YES];
		[self insertSubview:[self juinBackgroundArtwork] atIndex:0];

		if (addBlurSwitch) {
			if ([blurModeValue intValue] == 0)
				self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([blurModeValue intValue] == 1)
				self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			else if ([blurModeValue intValue] == 2)
				self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			self.blurView = [[UIVisualEffectView alloc] initWithEffect:[self blur]];
			[[self blurView] setFrame:[[self juinBackgroundArtwork] bounds]];
			[[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[[self blurView] setAlpha:[blurAmountValue doubleValue]];
			[[self juinBackgroundArtwork] addSubview:[self blurView]];
		}
	}


	// gradient
	self.gradient = [CAGradientLayer layer];
	[[self gradient] setFrame:[[self juinView] bounds]];
	[[self gradient] setColors:@[(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor]]];
	[[[self juinView] layer] addSublayer:[self gradient]];


	if ([styleValue intValue] == 0) {
		// source button
		self.sourceLabel = [UILabel new];
		if (showDeviceNameSwitch) [[self sourceLabel] setText:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] name]]];
		else [[self sourceLabel] setText:@""];
		[[self sourceLabel] setTextColor:[UIColor whiteColor]];
		[[self sourceLabel] setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular]];
		[[self sourceLabel] setTextAlignment:NSTextAlignmentCenter];
		[[self juinView] addSubview:[self sourceLabel]];

		[[self sourceLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.sourceLabel.widthAnchor constraintEqualToConstant:self.juinView.bounds.size.width].active = YES;
		[self.sourceLabel.heightAnchor constraintEqualToConstant:24].active = YES;
		[self.sourceLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
		[self.sourceLabel.centerYAnchor constraintEqualToAnchor:self.bottomAnchor constant:-24 - [newOffsetValue intValue]].active = YES;


		// play/pause button
		self.playPauseButton = [UIButton new];
		[[self playPauseButton] addTarget:self action:@selector(pausePlaySong) forControlEvents:UIControlEventTouchUpInside];
		[[self playPauseButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/paused-old.png"] forState:UIControlStateNormal];
		[[self juinView] addSubview:[self playPauseButton]];

		[[self playPauseButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.playPauseButton.widthAnchor constraintEqualToConstant:72].active = YES;
		[self.playPauseButton.heightAnchor constraintEqualToConstant:72].active = YES;
		[self.playPauseButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
		[self.playPauseButton.centerYAnchor constraintEqualToAnchor:self.sourceLabel.topAnchor constant:-50].active = YES;


		// rewind button
		self.rewindButton = [UIButton new];
		[[self rewindButton] addTarget:self action:@selector(rewindSong) forControlEvents:UIControlEventTouchUpInside];
		[[self rewindButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/rewind-old.png"] forState:UIControlStateNormal];
		[[self rewindButton] setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
		[[self juinView] addSubview:[self rewindButton]];

		[[self rewindButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.rewindButton.widthAnchor constraintEqualToConstant:34].active = YES;
		[self.rewindButton.heightAnchor constraintEqualToConstant:34].active = YES;
		[self.rewindButton.centerXAnchor constraintEqualToAnchor:self.playPauseButton.leftAnchor constant:-60].active = YES;
		[self.rewindButton.centerYAnchor constraintEqualToAnchor:self.sourceLabel.topAnchor constant:-50].active = YES;


		// skip button
		self.skipButton = [UIButton new];
		[[self skipButton] addTarget:self action:@selector(skipSong) forControlEvents:UIControlEventTouchUpInside];
		[[self skipButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/skip-old.png"] forState:UIControlStateNormal];
		[[self skipButton] setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
		[[self juinView] addSubview:[self skipButton]];

		[[self skipButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.skipButton.widthAnchor constraintEqualToConstant:34].active = YES;
		[self.skipButton.heightAnchor constraintEqualToConstant:34].active = YES;
		[self.skipButton.centerXAnchor constraintEqualToAnchor:self.playPauseButton.rightAnchor constant:60].active = YES;
		[self.skipButton.centerYAnchor constraintEqualToAnchor:self.sourceLabel.topAnchor constant:-50].active = YES;


		// artist label
		self.artistLabel = [UILabel new];
		[[self artistLabel] setTextColor:[UIColor colorWithRed: 0.60 green: 0.60 blue: 0.60 alpha: 1.00]];
		[[self artistLabel] setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightSemibold]];
		[[self artistLabel] setTextAlignment:NSTextAlignmentCenter];
		[[self artistLabel] setMarqueeEnabled:YES];
		[[self artistLabel] setMarqueeRunning:YES];
		[[self juinView] addSubview:[self artistLabel]];

		[[self artistLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.artistLabel.leadingAnchor constraintEqualToAnchor:self.juinView.leadingAnchor constant:24].active = YES;
		[self.artistLabel.trailingAnchor constraintEqualToAnchor:self.juinView.trailingAnchor constant:-24].active = YES;
		[self.artistLabel.centerYAnchor constraintEqualToAnchor:self.playPauseButton.topAnchor constant:-60].active = YES;
		[self.artistLabel.heightAnchor constraintEqualToConstant:31].active = YES;


		// song label
		self.songLabel = [UILabel new];
		[[self songLabel] setTextColor:[UIColor whiteColor]];
		[[self songLabel] setFont:[UIFont systemFontOfSize:36 weight:UIFontWeightSemibold]];
		[[self songLabel] setTextAlignment:NSTextAlignmentCenter];
		[[self songLabel] setMarqueeEnabled:YES];
		[[self songLabel] setMarqueeRunning:YES];
		[[self juinView] addSubview:[self songLabel]];

		[[self songLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.songLabel.leadingAnchor constraintEqualToAnchor:self.juinView.leadingAnchor constant:24].active = YES;
		[self.songLabel.trailingAnchor constraintEqualToAnchor:self.juinView.trailingAnchor constant:-24].active = YES;
		[self.songLabel.centerYAnchor constraintEqualToAnchor:self.artistLabel.topAnchor constant:-24].active = YES;
		[self.songLabel.heightAnchor constraintEqualToConstant:51].active = YES;
	} else if ([styleValue intValue] == 1) {
		// source button
		self.sourceLabel = [UILabel new];
		if (showDeviceNameSwitch) [[self sourceLabel] setText:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] name]]];
		else [[self sourceLabel] setText:@""];
		[[self sourceLabel] setTextColor:[UIColor whiteColor]];
		[[self sourceLabel] setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular]];
		[[self sourceLabel] setTextAlignment:NSTextAlignmentLeft];
		[[self juinView] addSubview:[self sourceLabel]];

		[[self sourceLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.sourceLabel.widthAnchor constraintEqualToConstant:self.juinView.bounds.size.width].active = YES;
		[self.sourceLabel.heightAnchor constraintEqualToConstant:24].active = YES;
		[self.sourceLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:26].active = YES;
		[self.sourceLabel.centerYAnchor constraintEqualToAnchor:self.bottomAnchor constant:-80 - [newOffsetValue intValue]].active = YES;


		// play/pause button
		self.playPauseButton = [UIButton new];
		[[self playPauseButton] addTarget:self action:@selector(pausePlaySong) forControlEvents:UIControlEventTouchUpInside];
		[[self playPauseButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/paused-new.png"] forState:UIControlStateNormal];
		[[self juinView] addSubview:[self playPauseButton]];

		[[self playPauseButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.playPauseButton.widthAnchor constraintEqualToConstant:64].active = YES;
		[self.playPauseButton.heightAnchor constraintEqualToConstant:64].active = YES;
		[self.playPauseButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
		[self.playPauseButton.centerYAnchor constraintEqualToAnchor:self.sourceLabel.topAnchor constant:-60].active = YES;


		// rewind button
		self.rewindButton = [UIButton new];
		[[self rewindButton] addTarget:self action:@selector(rewindSong) forControlEvents:UIControlEventTouchUpInside];
		[[self rewindButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/rewind-new.png"] forState:UIControlStateNormal];
		[[self juinView] addSubview:[self rewindButton]];

		[[self rewindButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.rewindButton.widthAnchor constraintEqualToConstant:36].active = YES;
		[self.rewindButton.heightAnchor constraintEqualToConstant:36].active = YES;
		[self.rewindButton.centerXAnchor constraintEqualToAnchor:self.playPauseButton.leftAnchor constant:-55].active = YES;
		[self.rewindButton.centerYAnchor constraintEqualToAnchor:self.sourceLabel.topAnchor constant:-60].active = YES;


		// skip button
		self.skipButton = [UIButton new];
		[[self skipButton] addTarget:self action:@selector(skipSong) forControlEvents:UIControlEventTouchUpInside];
		[[self skipButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/skip-new.png"] forState:UIControlStateNormal];
		[[self juinView] addSubview:[self skipButton]];

		[[self skipButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.skipButton.widthAnchor constraintEqualToConstant:36].active = YES;
		[self.skipButton.heightAnchor constraintEqualToConstant:36].active = YES;
		[self.skipButton.centerXAnchor constraintEqualToAnchor:self.playPauseButton.rightAnchor constant:55].active = YES;
		[self.skipButton.centerYAnchor constraintEqualToAnchor:self.sourceLabel.topAnchor constant:-60].active = YES;


		// artist label
		self.artistLabel = [UILabel new];
		[[self artistLabel] setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
		[[self artistLabel] setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
		[[self artistLabel] setTextAlignment:NSTextAlignmentLeft];
		[[self artistLabel] setMarqueeEnabled:YES];
		[[self artistLabel] setMarqueeRunning:YES];
		[[self juinView] addSubview:[self artistLabel]];

		[[self artistLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.artistLabel.leadingAnchor constraintEqualToAnchor:self.juinView.leadingAnchor constant:24].active = YES;
		[self.artistLabel.trailingAnchor constraintEqualToAnchor:self.juinView.trailingAnchor constant:-24].active = YES;
		[self.artistLabel.centerYAnchor constraintEqualToAnchor:self.playPauseButton.topAnchor constant:-65].active = YES;
		[self.artistLabel.heightAnchor constraintEqualToConstant:31].active = YES;


		// song label
		self.songLabel = [UILabel new];
		[[self songLabel] setTextColor:[UIColor whiteColor]];
		[[self songLabel] setFont:[UIFont systemFontOfSize:24 weight:UIFontWeightSemibold]];
		[[self songLabel] setTextAlignment:NSTextAlignmentLeft];
		[[self songLabel] setMarqueeEnabled:YES];
		[[self songLabel] setMarqueeRunning:YES];
		[[self juinView] addSubview:[self songLabel]];

		[[self songLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.songLabel.leadingAnchor constraintEqualToAnchor:self.juinView.leadingAnchor constant:24].active = YES;
		[self.songLabel.trailingAnchor constraintEqualToAnchor:self.juinView.trailingAnchor constant:-24].active = YES;
		[self.songLabel.centerYAnchor constraintEqualToAnchor:self.artistLabel.topAnchor constant:-12].active = YES;
		[self.songLabel.heightAnchor constraintEqualToConstant:51].active = YES;
	}


	// gesture view
	if ([styleValue intValue] == 0)
		self.gestureView = [[UIView alloc] initWithFrame:CGRectMake(self.juinView.bounds.origin.x, self.juinView.bounds.origin.y, self.juinView.bounds.size.width, self.juinView.bounds.size.height / 1.3 - [newOffsetValue intValue])];
	else if ([styleValue intValue] == 1)
		self.gestureView = [[UIView alloc] initWithFrame:CGRectMake(self.juinView.bounds.origin.x, self.juinView.bounds.origin.y, self.juinView.bounds.size.width, self.juinView.bounds.size.height / 1.5 - [newOffsetValue intValue])];
	[[self gestureView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self gestureView] setBackgroundColor:[UIColor clearColor]];
	[[self juinView] addSubview:[self gestureView]];

	
	// tap gesture
	self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideJuinView)];
	[[self tap] setNumberOfTapsRequired:1];
	[[self tap] setNumberOfTouchesRequired:1];
	[[self gestureView] addGestureRecognizer:[self tap]];


	// swipe gestures
	if (leftSwipeSwitch) {
		self.leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[[self leftSwipe] setDirection:UISwipeGestureRecognizerDirectionLeft];
		[[self gestureView] addGestureRecognizer:[self leftSwipe]];
	}

	if (rightSwipeSwitch) {
		self.rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[[self rightSwipe] setDirection:UISwipeGestureRecognizerDirectionRight];
		[[self gestureView] addGestureRecognizer:[self rightSwipe]];
	}

}

- (void)layoutSubviews { // add time slider

	%orig;

	if ([styleValue intValue] == 0) {
		// ios < 14.2
		[timeSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
		[timeSlider.widthAnchor constraintEqualToConstant:self.juinView.bounds.size.width -32].active = YES;
		[timeSlider.heightAnchor constraintEqualToConstant:49].active = YES;
		[[self juinView] addSubview:timeSlider];
		[timeSlider.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
		[timeSlider.centerYAnchor constraintEqualToAnchor:self.playPauseButton.topAnchor constant:-24].active = YES;

		// ios >= 14.2 (position managed in the MRUNowPlayingTimeControlsView hook)
		[[self juinView] addSubview:newTimeSlider];
	}
	else if ([styleValue intValue] == 1) {
		// ios < 14.2
		[timeSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
		[timeSlider.widthAnchor constraintEqualToConstant:self.juinView.bounds.size.width -50].active = YES;
		[timeSlider.heightAnchor constraintEqualToConstant:49].active = YES;
		[[self juinView] addSubview:timeSlider];
		[timeSlider.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
		[timeSlider.centerYAnchor constraintEqualToAnchor:self.playPauseButton.topAnchor constant:-35].active = YES;

		// ios >= 14.2 (position managed in the MRUNowPlayingTimeControlsView hook)
		[[self juinView] addSubview:newTimeSlider];
	}

}

%new
- (void)rewindSong { // rewind song

	[[%c(SBMediaController) sharedInstance] changeTrack:-1 eventSource:0];

}

%new
- (void)skipSong { // skip song

	[[%c(SBMediaController) sharedInstance] changeTrack:1 eventSource:0];

}

%new
- (void)pausePlaySong { // pause/play song

	[[%c(SBMediaController) sharedInstance] togglePlayPauseForEventSource:0];

}

%new
- (void)hideJuinView { // hide juin

	if ([[self juinView] isHidden]) return;
	if (![[%c(SBMediaController) sharedInstance] isPlaying] && ![[%c(SBMediaController) sharedInstance] isPaused]) return;

	[UIView transitionWithView:[self juinView] duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[[self juinView] setHidden:YES];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"juinUnhideElements" object:nil];
	} completion:nil];

}

%new
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender { // rewind/skip song based on swipe direction

	if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
		[self skipSong];
	else if (sender.direction == UISwipeGestureRecognizerDirectionRight)
		[self rewindSong];

}

%end

%hook NCNotificationListView

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 { // unhide juin on tap

	%orig;

	if (![[coversheetView juinView] isHidden]) return;
	if (![[%c(SBMediaController) sharedInstance] isPlaying] && ![[%c(SBMediaController) sharedInstance] isPaused]) return;

	[UIView transitionWithView:[coversheetView juinView] duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[[coversheetView juinView] setHidden:NO];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"juinHideElements" object:nil];
	} completion:nil];

}

%end

%hook MediaControlsTimeControl

- (void)layoutSubviews { // get a time slider instance

	%orig;

	MRPlatterViewController* controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
  	if ([controller respondsToSelector:@selector(delegate)] && [[controller delegate] isKindOfClass:%c(CSMediaControlsViewController)]) timeSlider = self;

}

%end

%hook MRUNowPlayingTimeControlsView

- (void)layoutSubviews { // get a time slider instance

	%orig;

	MRUNowPlayingViewController* controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if ([controller respondsToSelector:@selector(delegate)] && ![controller.delegate isKindOfClass:%c(MRUControlCenterViewController)]) newTimeSlider = self;

}

- (void)setFrame:(CGRect)frame { // set position of the new time slider

	if ([styleValue intValue] == 0) {
		MRUNowPlayingViewController* controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
		if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(MRUControlCenterViewController)])
			%orig;
		else
			%orig(CGRectMake(coversheetView.frame.size.width / 2 - frame.size.width / 2, coversheetView.artistLabel.frame.origin.y + 28, frame.size.width, frame.size.height));
	} else if ([styleValue intValue ] == 1) {
		MRUNowPlayingViewController* controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
		if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(MRUControlCenterViewController)])
			%orig;
		else
			%orig(CGRectMake(coversheetView.frame.size.width / 2 - frame.size.width / 2, coversheetView.artistLabel.frame.origin.y + 21, frame.size.width, frame.size.height));
	}

}

%end

%hook CSAdjunctItemView

- (void)_updateSizeToMimic { // hide original player

	%orig;

	[self.heightAnchor constraintEqualToConstant:0].active = true;
	[self setHidden:YES];

}

%end

%hook CSNotificationAdjunctListViewController

- (void)viewDidLoad { // make the time slider bright by forcing dark mode on the original player

	%orig;

    [self setOverrideUserInterfaceStyle:2];

}

%end

%end

%group JuinData

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // set now playing info

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;

            if (dict) {
				// set artwork
                if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
					[UIView transitionWithView:[coversheetView juinBackgroundArtwork] duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
						[[coversheetView juinBackgroundArtwork] setImage:[UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]];
					} completion:nil];
				}

				// set song title
				if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]) [[coversheetView songLabel] setText:[NSString stringWithFormat:@"%@ ", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle]]];
				else [[coversheetView songLabel] setText:@"N/A"];
				
				// set artist
				if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]) [[coversheetView artistLabel] setText:[NSString stringWithFormat:@"%@ ", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist]]];
				else [[coversheetView artistLabel] setText:@"N/A"];
				
				// unhide juin
				if (backgroundArtworkSwitch) [[coversheetView juinBackgroundArtwork] setHidden:NO];
                [[coversheetView juinView] setHidden:NO];

				[[NSNotificationCenter defaultCenter] postNotificationName:@"juinHideElements" object:nil];
            }
        } else { // hide juin if not playing
			if (backgroundArtworkSwitch) [[coversheetView juinBackgroundArtwork] setHidden:YES];
            [[coversheetView juinView] setHidden:YES];

			[[NSNotificationCenter defaultCenter] postNotificationName:@"juinUnhideElements" object:nil];
        }
  	});
    
}

- (void)_mediaRemoteNowPlayingApplicationIsPlayingDidChange:(id)arg1 { // get play/pause state change

    %orig;

	if ([styleValue intValue] == 0) {
		if ([self isPlaying])
			[[coversheetView playPauseButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/playing-old.png"] forState:UIControlStateNormal];
		else
			[[coversheetView playPauseButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/paused-old.png"] forState:UIControlStateNormal];
	} else if ([styleValue intValue] == 1) {
		if ([self isPlaying])
			[[coversheetView playPauseButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/playing-new.png"] forState:UIControlStateNormal];
		else
			[[coversheetView playPauseButton] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/JuinPreferences.bundle/icons/paused-new.png"] forState:UIControlStateNormal];
	}

}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 { // reload data after a respring

    %orig;

    [[%c(SBMediaController) sharedInstance] setNowPlayingInfo:0];
    
}

%end

%end

%group JuinCompletion

%hook CSQuickActionsButton

- (id)initWithFrame:(CGRect)frame { // add notification observer

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFadeNotification:) name:@"juinHideElements" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFadeNotification:) name:@"juinUnhideElements" object:nil];

	return %orig;

}

%new
- (void)receiveFadeNotification:(NSNotification *)notification { // hide or unhide quick action buttons

	if ([notification.name isEqual:@"juinHideElements"]) {
		[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:0.0];
		} completion:nil];
	} else if ([notification.name isEqual:@"juinUnhideElements"]) {
		[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self setAlpha:1.0];
		} completion:nil];
	}

}

%end

%hook CSTeachableMomentsContainerView

- (void)_layoutCallToActionLabel { // hide unlock text on homebar devices when playing
	
	%orig;

	SBUILegibilityLabel* label = [self valueForKey:@"_callToActionLabel"];

	if ([[coversheetView juinView] isHidden]) {
		[label setHidden:NO];
		return;
	}

	[label setHidden:YES];	

}

%end

%hook SBUICallToActionLabel

- (void)didMoveToWindow { // hide unlock text on home button devices when playing

	%orig;

	if ([[coversheetView juinView] isHidden]) {
		[self setHidden:NO];
		return;
	}

	[self setHidden:YES];

}

- (void)_updateLabelTextWithLanguage:(id)arg1 { // hide unlock text on home button devices when playing

	%orig;

	if ([[coversheetView juinView] isHidden]) {
		[self setHidden:NO];
		return;
	}

	[self setHidden:YES];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.juinpreferences"];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	if (!enabled) return;

	// style
	[preferences registerObject:&styleValue default:@"0" forKey:@"style"];

	// background artwork
	[preferences registerBool:&backgroundArtworkSwitch default:YES forKey:@"backgroundArtwork"];
	if (backgroundArtworkSwitch) {
		[preferences registerBool:&addBlurSwitch default:NO forKey:@"addBlur"];
		[preferences registerObject:&blurModeValue default:@"2" forKey:@"blurMode"];
		[preferences registerObject:&blurAmountValue default:@"1.0" forKey:@"blurAmount"];
	}

	// gestures
	[preferences registerBool:&leftSwipeSwitch default:YES forKey:@"leftSwipe"];
	[preferences registerBool:&rightSwipeSwitch default:YES forKey:@"rightSwipe"];

	// miscellaneous
	[preferences registerObject:&newOffsetValue default:@"0" forKey:@"newOffset"];
	[preferences registerBool:&showDeviceNameSwitch default:YES forKey:@"showDeviceName"];
	
	%init(Juin);
	%init(JuinData);
	%init(JuinCompletion);

}