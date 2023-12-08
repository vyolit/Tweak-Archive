#import "VioletMusic.h"

%group VioletMusic13

%hook MusicNowPlayingControlsViewController

%new
- (void)setArtwork { // get and set the artwork

	if (queueIsVisible) return;
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		NSDictionary* dictionary = (__bridge NSDictionary *)information;
		if (dictionary) {
			currentArtwork = [UIImage imageWithData:[dictionary objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
			if (currentArtwork) {
				if (musicArtworkBackgroundSwitch) {
					[musicArtworkBackgroundImageView setImage:currentArtwork];
					[musicArtworkBackgroundImageView setHidden:NO];
				} else {
					[musicArtworkBackgroundImageView setImage:nil];
					[musicArtworkBackgroundImageView setHidden:YES];
				}
			}
      	}
  	});

}

- (void)viewDidLoad { // add violet to the now playing view controller

	%orig;

	if (musicArtworkBackgroundSwitch) {
		for (UIView* subview in [[self view] subviews]) { // remove the background color of the controls view
			[subview setBackgroundColor:[UIColor clearColor]];
		}

		[self setArtwork];

		if (!musicArtworkBackgroundImageView) musicArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
		[musicArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[musicArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
		[musicArtworkBackgroundImageView setHidden:currentArtwork ? NO : YES];
		[musicArtworkBackgroundImageView setAlpha:[musicArtworkOpacityValue doubleValue]];
		if (![musicArtworkBackgroundImageView isDescendantOfView:[self view]]) [[self view] insertSubview:musicArtworkBackgroundImageView atIndex:0];

		if ([musicArtworkBlurMode intValue] != 0) {
			if (!musicBlur) {
				if ([musicArtworkBlurMode intValue] == 1)
					musicBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				else if ([musicArtworkBlurMode intValue] == 2)
					musicBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				else if ([musicArtworkBlurMode intValue] == 3)
					musicBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			}
			if (!musicBlurView) musicBlurView = [[UIVisualEffectView alloc] initWithEffect:musicBlur];
			[musicBlurView setFrame:[musicArtworkBackgroundImageView bounds]];
			[musicBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[musicBlurView setClipsToBounds:YES];
			[musicBlurView setAlpha:[musicArtworkBlurAmountValue doubleValue]];
			if (![musicBlurView isDescendantOfView:musicArtworkBackgroundImageView]) [musicArtworkBackgroundImageView addSubview:musicBlurView];
		}

		if ([musicArtworkDimValue doubleValue] != 0.0) {
			if (!musicDimView) musicDimView = [[UIView alloc] initWithFrame:[musicArtworkBackgroundImageView bounds]];
			[musicDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[musicDimView setBackgroundColor:[UIColor blackColor]];
			[musicDimView setAlpha:[musicArtworkDimValue doubleValue]];
			[musicDimView setHidden:NO];
			if (![musicDimView isDescendantOfView:musicArtworkBackgroundImageView]) [musicArtworkBackgroundImageView addSubview:musicDimView];
		}

		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter removeObserver:self];
		[notificationCenter addObserver:self selector:@selector(setArtwork) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
	}

	if (hideLyricsButtonSwitch) {
		MPRouteButton* lyricsButton = [self valueForKey:@"lyricsButton"];
		[lyricsButton setHidden:YES];
	}
		
	if (hideRouteButtonSwitch) {
		MPRouteButton* routeButton = [self valueForKey:@"routeButton"];
		[routeButton setHidden:YES];
	}

	if (hideRouteLabelSwitch) {
		UILabel* routeLabel = [self valueForKey:@"routeLabel"];
		[routeLabel setHidden:YES];
	}

	if (hideQueueButtonSwitch) {
		MPRouteButton* queueButton = [self valueForKey:@"queueButton"];
		[queueButton setHidden:YES];
	}

	if (hideTitleLabelSwitch) {
		UILabel* titleLabel = [self valueForKey:@"titleLabel"];
		[titleLabel setHidden:YES];
	}
	
	if (hideSubtitleButtonSwitch) {
		UIButton* subtitleButton = [self valueForKey:@"subtitleButton"];
		[subtitleButton setHidden:YES];
	}

	if (hideGrabberViewSwitch) {
		UIView* grabber = [self valueForKey:@"grabberView"];
		[grabber setHidden:YES];
	}

	if (hideQueueModeBadgeSwitch) {
		UIView* queueModeBadgeView = [self valueForKey:@"queueModeBadgeView"];
		[queueModeBadgeView removeFromSuperview];
	}

}

- (void)viewWillAppear:(BOOL)animated { // hide the queue badge

	%orig;

	if (hideQueueModeBadgeSwitch) {
		UIView* queueModeBadgeView = [self valueForKey:@"queueModeBadgeView"];
		[queueModeBadgeView removeFromSuperview];
	}

}

- (void)viewDidLayoutSubviews { // hide controls view background color

	%orig;

	UIView* bottomContainerView = [self valueForKey:@"bottomContainerView"];
	[bottomContainerView setBackgroundColor:[UIColor clearColor]];

}

%end

%hook MusicLyricsBackgroundView

- (void)setAlpha:(CGFloat)alpha { // hide violet when lyrics view is enabled - iOS >= 13.4

	%orig;

	if (alpha > 0) {
		[UIView animateWithDuration:0.2 animations:^{
    		[musicArtworkBackgroundImageView setAlpha:0.0];
    	}];
		[musicArtworkBackgroundImageView setHidden:YES];
	} else {
		[[theTransportView superview] setHidden:YES];
		[UIView animateWithDuration:0.2 animations:^{
			[musicArtworkBackgroundImageView setAlpha:1.0];
    	}];
		[musicArtworkBackgroundImageView setHidden:NO];
	}

}

%end

%hook MusicLyricsBackgroundViewX

- (void)setAlpha:(CGFloat)alpha { // hide violet when lyrics view is enabled - iOS < 13.4

	%orig;

	if (alpha > 0) {
		[UIView animateWithDuration:0.2 animations:^{
      		[musicArtworkBackgroundImageView setAlpha:0.0];
    	}];
		[musicArtworkBackgroundImageView setHidden:YES];
	} else {
		[[theTransportView superview] setHidden:YES];
		[UIView animateWithDuration:0.2 animations:^{
      		[musicArtworkBackgroundImageView setAlpha:1.0];
    	}];
		[musicArtworkBackgroundImageView setHidden:NO];
	}

}

%end

%hook QueueViewController

- (void)viewWillAppear:(BOOL)animated { // hide the artwork background when the queue appeared

	%orig;

	queueIsVisible = YES;
	if (musicArtworkBackgroundSwitch) [musicArtworkBackgroundImageView setHidden:YES];

}

- (void)viewWillDisappear:(BOOL)animated { // unhide the artwork background when the queue disappeared

	%orig;

	queueIsVisible = NO;
	if (musicArtworkBackgroundSwitch) [musicArtworkBackgroundImageView setHidden:NO];

}

%end

%hook ArtworkView

- (void)didMoveToWindow { // hide the original artwork

	%orig;

	if (hideArtworkViewSwitch) [self setHidden:YES];

}

%end

%hook TimeControl

- (void)didMoveToWindow { // hide time slider elements

	%orig;

	if (hideTimeControlSwitch) {
		[self setAlpha:0];
		return;
	}

	if (hideKnobViewSwitch) {
		UIView* knob = [self valueForKey:@"knobView"];
		[knob setHidden:YES];
	}
	if (hideElapsedTimeLabelSwitch) {
		UILabel* elapsedLabel = [self valueForKey:@"elapsedTimeLabel"];
		[elapsedLabel removeFromSuperview];
	}
	if (hideRemainingTimeLabelSwitch) {
		UILabel* remainingLabel = [self valueForKey:@"remainingTimeLabel"];
		[remainingLabel removeFromSuperview];
	}

}

%end

%hook ContextualActionsButton

- (void)setHidden:(BOOL)hidden { // hide the context button

	%orig;

	if (hideContextualActionsButtonSwitch) %orig(YES);

}

%end

%hook _TtCC16MusicApplication32NowPlayingControlsViewController12VolumeSlider

- (void)didMoveToWindow { // hide volume (slider) elements

	%orig;

	if (hideVolumeSliderSwitch) {
		[self setHidden:YES];
		return;
	}
	
	if (hideMinImageSwitch) {
		UIImageView* minImage = [self valueForKey:@"_minValueImageView"];
		[minImage setHidden:YES];
	}
		
	if (hideMaxImageSwitch) {
		UIImageView* maxImage = [self valueForKey:@"_maxValueImageView"];
		[maxImage setHidden:YES];
	}

}

%end

%end

%group VioletMusic14

%hook MusicNowPlayingControlsViewController

%new
- (void)setArtwork { // get and set the artwork

	if (queueIsVisible) return;
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		NSDictionary* dict = (__bridge NSDictionary *)information;
		if (dict) {
			if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
				currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
				if (currentArtwork) {
					if (musicArtworkBackgroundSwitch) {
						[musicArtworkBackgroundImageView setImage:currentArtwork];
						[musicArtworkBackgroundImageView setHidden:NO];
						if ([musicArtworkBlurMode intValue] != 0) [musicBlurView setHidden:NO];
					}
				}
			} else { // no artwork
				[musicArtworkBackgroundImageView setImage:nil];
				[musicArtworkBackgroundImageView setHidden:YES];
			}
      	}
  	});

}

- (void)viewDidLoad { // add artwork background and hide other elements

	%orig;

	if (musicArtworkBackgroundSwitch) {
		[self setArtwork];

		if (!musicArtworkBackgroundImageView) musicArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
		[musicArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[musicArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
		[musicArtworkBackgroundImageView setHidden:NO];
		[musicArtworkBackgroundImageView setAlpha:[musicArtworkOpacityValue doubleValue]];
		if (![musicArtworkBackgroundImageView isDescendantOfView:[self view]]) [[self view] insertSubview:musicArtworkBackgroundImageView atIndex:0];

		if ([musicArtworkBlurMode intValue] != 0) {
			if (!musicBlur) {
				if ([musicArtworkBlurMode intValue] == 1)
					musicBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				else if ([musicArtworkBlurMode intValue] == 2)
					musicBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				else if ([musicArtworkBlurMode intValue] == 3)
					musicBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			}
			if (!musicBlurView) musicBlurView = [[UIVisualEffectView alloc] initWithEffect:musicBlur];
			[musicBlurView setFrame:[musicArtworkBackgroundImageView bounds]];
			[musicBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[musicBlurView setAlpha:[musicArtworkBlurAmountValue doubleValue]];
			if (![musicBlurView isDescendantOfView:musicArtworkBackgroundImageView]) [musicArtworkBackgroundImageView addSubview:musicBlurView];
		}

		if ([musicArtworkDimValue doubleValue] != 0.0) {
			if (!musicDimView) musicDimView = [[UIView alloc] initWithFrame:[musicArtworkBackgroundImageView bounds]];
			[musicDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[musicDimView setBackgroundColor:[UIColor blackColor]];
			[musicDimView setAlpha:[musicArtworkDimValue doubleValue]];
			[musicDimView setHidden:NO];
			if (![musicDimView isDescendantOfView:musicArtworkBackgroundImageView]) [musicArtworkBackgroundImageView addSubview:musicDimView];
		}

		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter removeObserver:self];
		[notificationCenter addObserver:self selector:@selector(setArtwork) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
	}
	
	if (hideLyricsButtonSwitch) {
		MPRouteButton* lyricsButton = [self valueForKey:@"lyricsButton"];
		[lyricsButton setHidden:YES];
	}
		
	if (hideRouteButtonSwitch) {
		MPRouteButton* routeButton = [self valueForKey:@"routeButton"];
		[routeButton removeFromSuperview];
	}

	if (hideRouteLabelSwitch) {
		UILabel* routeLabel = [self valueForKey:@"routeLabel"];
		[routeLabel removeFromSuperview];
	}

	if (hideQueueButtonSwitch) {
		MPRouteButton* queueButton = [self valueForKey:@"queueButton"];
		[queueButton setHidden:YES];
	}

	if (hideTitleLabelSwitch) {
		UILabel* titleLabel = [self valueForKey:@"titleLabel"];
		[titleLabel setHidden:YES];
	}
	
	if (hideSubtitleButtonSwitch) {
		UIButton* subtitleButton = [self valueForKey:@"subtitleButton"];
		[subtitleButton setHidden:YES];
	}

	if (hideGrabberViewSwitch) {
		UIView* grabber = [self valueForKey:@"grabberView"];
		[grabber removeFromSuperview];
	}

	if (hideQueueModeBadgeSwitch) {
		UIView* queueModeBadgeView = [self valueForKey:@"queueModeBadgeView"];
		[queueModeBadgeView removeFromSuperview];
	}

}

%end

%hook QueueViewController

- (void)viewWillAppear:(BOOL)animated { // hide the artwork background when the queue appeared

	%orig;

	queueIsVisible = YES;
	if (musicArtworkBackgroundSwitch) [musicArtworkBackgroundImageView setHidden:YES];

}

- (void)viewWillDisappear:(BOOL)animated { // unhide the artwork background when the queue disappeared

	%orig;

	queueIsVisible = NO;
	if (musicArtworkBackgroundSwitch) [musicArtworkBackgroundImageView setHidden:NO];

}

%end

%hook ArtworkView

- (void)didMoveToWindow { // hide the original artwork

	%orig;

	if (hideArtworkViewSwitch) [self setHidden:YES];

}

%end

%hook TimeControl

- (void)didMoveToWindow { // hide time slider elements

	%orig;

	if (hideTimeControlSwitch) {
		[self setAlpha:0.0];
		return;
	}

	if (hideKnobViewSwitch) {
		UIView* knob = [self valueForKey:@"knobView"];
		[knob setHidden:YES];
	}

	if (hideElapsedTimeLabelSwitch) {
		UILabel* elapsedLabel = [self valueForKey:@"elapsedTimeLabel"];
		[elapsedLabel removeFromSuperview];
	}

	if (hideRemainingTimeLabelSwitch) {
		UILabel* remainingLabel = [self valueForKey:@"remainingTimeLabel"];
		[remainingLabel removeFromSuperview];
	}

}

%end

%hook ContextualActionsButton

- (void)setHidden:(BOOL)hidden { // hide the context button

	%orig;

	if (hideContextualActionsButtonSwitch) %orig(YES);

}

%end

%hook _TtCC16MusicApplication32NowPlayingControlsViewController12VolumeSlider

- (void)didMoveToWindow { // hide the volume slider

	%orig;

	if (hideVolumeSliderSwitch) [self setHidden:YES];	

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.violetpreferences"];

    [preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

	// music
	[preferences registerBool:&musicArtworkBackgroundSwitch default:NO forKey:@"musicArtworkBackground"];
	[preferences registerObject:&musicArtworkBlurMode default:@"0" forKey:@"musicArtworkBlur"];
	[preferences registerObject:&musicArtworkBlurAmountValue default:@"1.0" forKey:@"musicArtworkBlurAmount"];
	[preferences registerObject:&musicArtworkOpacityValue default:@"1.0" forKey:@"musicArtworkOpacity"];
	[preferences registerObject:&musicArtworkDimValue default:@"0.0" forKey:@"musicArtworkDim"];
	[preferences registerBool:&hideGrabberViewSwitch default:NO forKey:@"musicHideGrabberView"];
	[preferences registerBool:&hideArtworkViewSwitch default:NO forKey:@"musicHideArtworkView"];
	[preferences registerBool:&hideTimeControlSwitch default:NO forKey:@"musicHideTimeControl"];
	[preferences registerBool:&hideKnobViewSwitch default:NO forKey:@"musicHideKnobView"];
	[preferences registerBool:&hideElapsedTimeLabelSwitch default:NO forKey:@"musicHideElapsedTimeLabel"];
	[preferences registerBool:&hideRemainingTimeLabelSwitch default:NO forKey:@"musicHideRemainingTimeLabel"];
	[preferences registerBool:&hideContextualActionsButtonSwitch default:NO forKey:@"musicHideContextualActionsButton"];
	[preferences registerBool:&hideVolumeSliderSwitch default:NO forKey:@"musicHideVolumeSlider"];
	[preferences registerBool:&hideMinImageSwitch default:NO forKey:@"musicHideMinImage"];
	[preferences registerBool:&hideMaxImageSwitch default:NO forKey:@"musicHideMaxImage"];
	[preferences registerBool:&hideTitleLabelSwitch default:NO forKey:@"musicHideTitleLabel"];
	[preferences registerBool:&hideSubtitleButtonSwitch default:NO forKey:@"musicHideSubtitleButton"];
	[preferences registerBool:&hideLyricsButtonSwitch default:NO forKey:@"musicHideLyricsButton"];
	[preferences registerBool:&hideRouteButtonSwitch default:NO forKey:@"musicHideRouteButton"];
	[preferences registerBool:&hideRouteLabelSwitch default:NO forKey:@"musicHideRouteLabel"];
	[preferences registerBool:&hideQueueButtonSwitch default:NO forKey:@"musicHideQueueButton"];
	[preferences registerBool:&hideQueueButtonSwitch default:NO forKey:@"musicHideQueueButton"];
	[preferences registerBool:&hideQueueModeBadgeSwitch default:NO forKey:@"musicHideQueueModeBadge"];

	if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 14) %init(VioletMusic13, QueueViewController=objc_getClass("MusicApplication.NowPlayingQueueViewController"), ArtworkView=objc_getClass("MusicApplication.NowPlayingContentView"), TimeControl=objc_getClass("MusicApplication.PlayerTimeControl"), ContextualActionsButton=objc_getClass("MusicApplication.ContextualActionsButton"), MusicLyricsBackgroundViewX=objc_getClass("MusicApplication.LyricsBackgroundView"));
	else %init(VioletMusic14, QueueViewController=objc_getClass("MusicApplication.new_NowPlayingQueueViewController"), ArtworkView=objc_getClass("MusicApplication.NowPlayingContentView"), TimeControl=objc_getClass("MusicApplication.PlayerTimeControl"), ContextualActionsButton=objc_getClass("MusicApplication.SymbolButton"));

}