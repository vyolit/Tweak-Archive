//
//  PomPom.x
//  PomPom
//
//  Created by Alexandra (@Traurige)
//

#import "PomPom.h"

SBUIProudLockIconView* lockIconView;
SBFLockScreenDateView* timeDateView;
MRUNowPlayingTimeControlsView* timeSlider;

%group PomPomOriginalUserInterfaceAppearance

%hook SBUIProudLockIconView

- (id)initWithFrame:(CGRect)frame {
    id orig = %orig;
    if (!hideFaceIDLock) lockIconView = self;

    return orig;
}

- (void)didMoveToWindow {
    %orig;

    if (!hideFaceIDLock) return;
    [[self superview] removeFromSuperview]; // remove the faceid lock and label
}

- (void)setFrame:(CGRect)frame {
    %orig;

    if (hideFaceIDLock) return;
    [self alignLeft];
    [self setCenter:CGPointMake(self.center.x, self.center.y + 20)];
    [self setTransform:CGAffineTransformMakeScale(0.75, 0.75)];
}

%new
- (void)alignLeft { // align the faceid lock to the left
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1000 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setCenter:CGPointMake(self.center.x / 3.75, self.center.y)];
    } completion:nil];
}

%new
- (void)alignCenter { // center the faceid lock
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1000 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setCenter:CGPointMake(self.center.x * 3.75, self.center.y)];
    } completion:nil];
}

%end

%hook CSPasscodeViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    [lockIconView alignCenter];
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig;
    [lockIconView alignLeft];
}

%end

%hook SBFLockScreenDateSubtitleView

- (void)didMoveToWindow { // remove the original date label
    %orig;

    SBUILegibilityLabel* originalDateLabel = [self valueForKey:@"_label"];
    [originalDateLabel removeFromSuperview];
}

- (void)setString:(NSString *)arg1 { // apply running timers to the pompom date label
    %orig;

    if ([arg1 containsString:@":"]) {
        timerRunning = YES;
        [[timeDateView pompomDateLabel] setText:arg1];
    } else {
        timerRunning = NO;
    }
}

%end

%hook SBLockScreenTimerDialView

- (void)didMoveToWindow { // remove the timer icon
    %orig;
    [self removeFromSuperview];
}

%end

%hook SBFLockScreenDateSubtitleDateView

- (void)didMoveToWindow { // remove the lunar label
    %orig;

    SBFLockScreenAlternateDateLabel* lunarLabel = [self valueForKey:@"_alternateDateLabel"];
    [lunarLabel removeFromSuperview];
}

%end

%hook SBFLockScreenDateView

- (void)didMoveToWindow { // remove the original time label
    %orig;

    SBUILegibilityLabel* originalTimeLabel = [self valueForKey:@"_timeLabel"];
    [originalTimeLabel removeFromSuperview];
}

%end

%hook CSCoverSheetViewController

- (void)_transitionChargingViewToVisible:(BOOL)arg1 showBattery:(BOOL)arg2 animated:(BOOL)arg3 { // hide the charging view
    %orig(NO, NO, NO);
}

%end

%hook CSAdjunctItemView

- (void)_updateSizeToMimic { // hide the original media player
	%orig;

    if (!replaceMediaPlayer) return;
	[self.heightAnchor constraintEqualToConstant:0].active = true;
	[self setHidden:YES];
}

%end

%hook CSNotificationAdjunctListViewController

- (void)viewDidLoad { // override the time slider style
	%orig;

    if (!replaceMediaPlayer || !displayTimeSlider) return;
    [self setOverrideUserInterfaceStyle:timeSliderOverrideStyle];
}

%end

%hook NCNotificationListSectionRevealHintView

- (id)initWithFrame:(CGRect)frame { // hide the no older notifications text
    if (hideNoOlderNotifications)
        return nil;
    else
        return %orig;
}

%end

%hook NCNotificationListSectionHeaderView

- (id)initWithFrame:(CGRect)frame { // hide notifications header
    if (hideNotificationsHeader)
        return nil;
    else
        return %orig;
}

%end

%hook CSQuickActionsView

- (void)didMoveToWindow { // hide the flashlight and camera button
	%orig;

    if (hideFlashlight) {
        CSQuickActionsButton* flashlightButton = [self valueForKey:@"_flashlightButton"];
	    [flashlightButton setHidden:YES];
    }

	if (hideCamera) {
        CSQuickActionsButton* cameraButton = [self valueForKey:@"_cameraButton"];
        [cameraButton setHidden:YES];
    }
}

%end

%hook CSQuickActionsButton

- (void)didMoveToWindow { // hide the quick actions background
	%orig;

	if (hideQuickActionsBackground) {
		UIVisualEffectView* background = [self valueForKey:@"_backgroundEffectView"];
		[background setHidden:YES];
	}
}

%end

%hook SBUICallToActionLabel

- (void)didMoveToWindow { // hide and set unlock text when locked (home button devices)
	%orig;
	if (hideUnlockText) [self setHidden:YES];
}

- (void)_updateLabelTextWithLanguage:(id)arg1 { // hide and set unlock text when unlocked (home button devices)
    %orig;
	if (hideUnlockText) [self setHidden:YES];
}

%end

%hook CSTeachableMomentsContainerView

- (void)_layoutCallToActionLabel { // hide the unlock text (homebar devices)
	%orig;

	if (hideUnlockText) {
		SBUILegibilityLabel* label = [self valueForKey:@"_callToActionLabel"];
		[label setHidden:YES];
	}
}

%end

%hook CSPageControl

- (void)didMoveToWindow { // hide the page dots
	%orig;
	if (hidePageDots) [self setHidden:YES];
}

%end

%hook CSHomeAffordanceView

- (void)didMoveToWindow { // hide the homebar
	%orig;
    if (hideHomebar) [self setHidden:YES];
}

%end

%end

%group PomPomCore

%hook SBFLockScreenDateView

%property(nonatomic, retain)UILabel* pompomTimeLabel;
%property(nonatomic, retain)UIImageView* pompomWeatherIconView;
%property(nonatomic, retain)UILabel* pompomDateLabel;
%property(nonatomic, retain)UIView* pompomPlayerView;
%property(nonatomic, retain)UIView* pompomArtworkContainerView;
%property(nonatomic, retain)UIButton* pompomArtworkButton;
%property(nonatomic, retain)UILabel* pompomSongTitleLabel;
%property(nonatomic, retain)UILabel* pompomArtistLabel;
%property(nonatomic, retain)UIButton* pompomRewindButton;
%property(nonatomic, retain)UIButton* pompomPlayButton;
%property(nonatomic, retain)UIButton* pompomSkipButton;
%property(nonatomic, retain)UIView* pompomTimeSliderView;
%property(nonatomic, retain)UIView* pompomUpNextView;
%property(nonatomic, retain)UILabel* pompomUpNextLabel;
%property(nonatomic, retain)UIButton* pompomUpNextIconButton;
%property(nonatomic, retain)UILabel* pompomUpNextEventLabel;
%property(nonatomic, retain)UILabel* pompomUpNextDateLabel;

- (id)initWithFrame:(CGRect)frame {
    id orig = %orig;
    timeDateView = self;

    return orig;
}

- (void)didMoveToWindow {
    %orig;

    if ([self pompomTimeLabel]) return;

    // time label
    self.pompomTimeLabel = [UILabel new];
    [[self pompomTimeLabel] setTextColor:[UIColor whiteColor]];
    [[self pompomTimeLabel] setTextAlignment:NSTextAlignmentLeft];
    [[self pompomTimeLabel] setFont:[UIFont systemFontOfSize:60]];
    [self addSubview:[self pompomTimeLabel]];

    [[self pompomTimeLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.pompomTimeLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
		[self.pompomTimeLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [self.pompomTimeLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
	]];

    // date label
    self.pompomDateLabel = [UILabel new];
    [[self pompomDateLabel] setTextColor:[UIColor whiteColor]];
    [[self pompomDateLabel] setTextAlignment:NSTextAlignmentLeft];
    [[self pompomDateLabel] setFont:[UIFont systemFontOfSize:21 weight:UIFontWeightMedium]];
    [self addSubview:[self pompomDateLabel]];

    if (displayWeather) {
        // weather icon view
        self.pompomWeatherIconView = [UIImageView new];
        [self updatePomPomWeather];
        [[self pompomWeatherIconView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self pompomWeatherIconView] setTintColor:[UIColor whiteColor]];
        [self addSubview:[self pompomWeatherIconView]];

        [[self pompomWeatherIconView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomWeatherIconView.topAnchor constraintEqualToAnchor:self.pompomTimeLabel.bottomAnchor],
            [self.pompomWeatherIconView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
            [self.pompomWeatherIconView.widthAnchor constraintEqualToConstant:25],
            [self.pompomWeatherIconView.heightAnchor constraintEqualToConstant:25]
        ]];

        // date label
        [[self pompomDateLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomDateLabel.centerYAnchor constraintEqualToAnchor:self.pompomWeatherIconView.centerYAnchor],
            [self.pompomDateLabel.leadingAnchor constraintEqualToAnchor:self.pompomWeatherIconView.trailingAnchor constant:8],
            [self.pompomDateLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
        ]];
    } else {
        [[self pompomDateLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomDateLabel.topAnchor constraintEqualToAnchor:self.pompomTimeLabel.bottomAnchor],
            [self.pompomDateLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
            [self.pompomDateLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
        ]];
    }

    [self updatePomPomTimeAndDate];

    // player view
    if (replaceMediaPlayer) {
        self.pompomPlayerView = [UIView new];
        [self addSubview:[self pompomPlayerView]];

        [[self pompomPlayerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomPlayerView.topAnchor constraintEqualToAnchor:self.pompomDateLabel.bottomAnchor constant:24],
            [self.pompomPlayerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
            [self.pompomPlayerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
            [self.pompomPlayerView.heightAnchor constraintEqualToConstant:60]
        ]];

        // artwork container view
        self.pompomArtworkContainerView = [UIView new];
        [[[self pompomArtworkContainerView] layer] setShadowColor:[[UIColor blackColor] CGColor]];
        [[[self pompomArtworkContainerView] layer] setShadowOffset:CGSizeZero];
        [[[self pompomArtworkContainerView] layer] setShadowOpacity:0.2];
        [[[self pompomArtworkContainerView] layer] setShadowRadius:5];
        [[self pompomPlayerView] addSubview:[self pompomArtworkContainerView]];

        [[self pompomArtworkContainerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomArtworkContainerView.topAnchor constraintEqualToAnchor:self.pompomPlayerView.topAnchor],
            [self.pompomArtworkContainerView.leadingAnchor constraintEqualToAnchor:self.pompomPlayerView.leadingAnchor],
            [self.pompomArtworkContainerView.widthAnchor constraintEqualToConstant:60],
            [self.pompomArtworkContainerView.heightAnchor constraintEqualToConstant:60]
        ]];

        // artwork button
        self.pompomArtworkButton = [UIButton new];
        [[self pompomArtworkButton] addTarget:self action:@selector(openNowPlayingApplication) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage* artworkPlaceholder = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PomPomPreferences.bundle/images/artwork-placeholder.png"];
        [[self pompomArtworkButton] setImage:artworkPlaceholder forState:UIControlStateNormal];
        
        [[self pompomArtworkButton] setContentMode:UIViewContentModeScaleAspectFill];
        [[self pompomArtworkButton] setClipsToBounds:YES];
        [[[self pompomArtworkButton] layer] setCornerRadius:5];
        [[self pompomArtworkButton] setAdjustsImageWhenHighlighted:NO];
        
        if ([[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible]) // if it's not added on the lock screen the springboard would crash
            [[[[self superview] superview] superview] addSubview:[self pompomArtworkButton]];
        else
            [[self pompomPlayerView] addSubview:[self pompomArtworkButton]];

        [[self pompomArtworkButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomArtworkButton.topAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.topAnchor],
            [self.pompomArtworkButton.leadingAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.leadingAnchor],
            [self.pompomArtworkButton.trailingAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.trailingAnchor],
            [self.pompomArtworkButton.bottomAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.bottomAnchor]
        ]];

        // skip button
        if (displaySkipButton) {
            self.pompomSkipButton = [UIButton new];
            [[self pompomSkipButton] addTarget:self action:@selector(skipSong) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage* skipImage = [[UIImage systemImageNamed:@"forward.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:22.5]];
            [[self pompomSkipButton] setImage:skipImage forState:UIControlStateNormal];
            
            [[self pompomSkipButton] setTintColor:[UIColor whiteColor]];
            [[self pompomSkipButton] setAdjustsImageWhenHighlighted:NO];
            
            if ([[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible])
                [[[[self superview] superview] superview] addSubview:[self pompomSkipButton]];
            else
                [[self pompomPlayerView] addSubview:[self pompomSkipButton]];

            [[self pompomSkipButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [NSLayoutConstraint activateConstraints:@[
                [self.pompomSkipButton.centerYAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.centerYAnchor],
                [self.pompomSkipButton.trailingAnchor constraintEqualToAnchor:self.pompomPlayerView.trailingAnchor],
                [self.pompomSkipButton.widthAnchor constraintEqualToConstant:40],
                [self.pompomSkipButton.heightAnchor constraintEqualToConstant:22.5]
            ]];
        }

        // play button
        if (displayPlayButton) {
            self.pompomPlayButton = [UIButton new];
            [[self pompomPlayButton] addTarget:self action:@selector(togglePlayback) forControlEvents:UIControlEventTouchUpInside];
            [self updatePomPomPlayButton:[[%c(SBMediaController) sharedInstance] isPlaying]];
            [[self pompomPlayButton] setTintColor:[UIColor whiteColor]];
            [[self pompomPlayButton] setAdjustsImageWhenHighlighted:NO];
            
            if ([[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible])
                [[[[self superview] superview] superview] addSubview:[self pompomPlayButton]];
            else
                [[self pompomPlayerView] addSubview:[self pompomPlayButton]];

            [[self pompomPlayButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [NSLayoutConstraint activateConstraints:@[
                [self.pompomPlayButton.centerYAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.centerYAnchor],
                [self.pompomPlayButton.widthAnchor constraintEqualToConstant:27.5],
                [self.pompomPlayButton.heightAnchor constraintEqualToConstant:27.5]
            ]];

            if (displaySkipButton)
                [self.pompomPlayButton.trailingAnchor constraintEqualToAnchor:self.pompomSkipButton.leadingAnchor constant:-4].active = YES;
            else if (!displaySkipButton)
                [self.pompomPlayButton.trailingAnchor constraintEqualToAnchor:self.pompomPlayerView.trailingAnchor].active = YES;
        }

        // rewind button
        if (displayRewindButton) {
            self.pompomRewindButton = [UIButton new];
            [[self pompomRewindButton] addTarget:self action:@selector(rewindSong) forControlEvents:UIControlEventTouchUpInside];

            UIImage* rewindImage = [[UIImage systemImageNamed:@"backward.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:22.5]];
            [[self pompomRewindButton] setImage:rewindImage forState:UIControlStateNormal];
            
            [[self pompomRewindButton] setTintColor:[UIColor whiteColor]];
            [[self pompomRewindButton] setAdjustsImageWhenHighlighted:NO];

            if ([[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible])
                [[[[self superview] superview] superview] addSubview:[self pompomRewindButton]];
            else
                [[self pompomPlayerView] addSubview:[self pompomRewindButton]];

            [[self pompomRewindButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [NSLayoutConstraint activateConstraints:@[
                [self.pompomRewindButton.centerYAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.centerYAnchor],
                [self.pompomRewindButton.widthAnchor constraintEqualToConstant:40],
                [self.pompomRewindButton.heightAnchor constraintEqualToConstant:22.5]
            ]];

            if (displayPlayButton)
                [self.pompomRewindButton.trailingAnchor constraintEqualToAnchor:self.pompomPlayButton.leadingAnchor constant:-4].active = YES;
            else if (!displayPlayButton && displaySkipButton)
                [self.pompomRewindButton.trailingAnchor constraintEqualToAnchor:self.pompomSkipButton.leadingAnchor constant:-4].active = YES;
            else
                [self.pompomRewindButton.trailingAnchor constraintEqualToAnchor:self.pompomPlayerView.trailingAnchor].active = YES;
        }

        // song title label
        self.pompomSongTitleLabel = [UILabel new];
        [[self pompomSongTitleLabel] setTextColor:[UIColor whiteColor]];
        [[self pompomSongTitleLabel] setFont:[UIFont systemFontOfSize:21 weight:UIFontWeightMedium]];
        [[self pompomSongTitleLabel] setText:@"Not playing"];
        [[self pompomSongTitleLabel] setMarqueeEnabled:YES];
        [[self pompomSongTitleLabel] setMarqueeRunning:YES];
        [[self pompomPlayerView] addSubview:[self pompomSongTitleLabel]];

        [[self pompomSongTitleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomSongTitleLabel.topAnchor constraintEqualToAnchor:self.pompomPlayerView.topAnchor constant:6],
            [self.pompomSongTitleLabel.leadingAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.trailingAnchor constant:16]
        ]];

        if (displayRewindButton)
            [self.pompomSongTitleLabel.trailingAnchor constraintEqualToAnchor:self.pompomRewindButton.leadingAnchor constant:-16].active = YES;
        else if (!displayRewindButton && displayPlayButton) {
            [self.pompomSongTitleLabel.trailingAnchor constraintEqualToAnchor:self.pompomPlayButton.leadingAnchor constant:-16].active = YES;
        } else if (!displayRewindButton && !displayPlayButton && displaySkipButton) {
            [self.pompomSongTitleLabel.trailingAnchor constraintEqualToAnchor:self.pompomSkipButton.leadingAnchor constant:-16].active = YES;
        } else {
            [self.pompomSongTitleLabel.trailingAnchor constraintEqualToAnchor:self.pompomPlayerView.trailingAnchor].active = YES;
        }

        // artist label
        self.pompomArtistLabel = [UILabel new];
        [[self pompomArtistLabel] setTextColor:[UIColor whiteColor]];
        [[self pompomArtistLabel] setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        [[self pompomArtistLabel] setText:@"Tap play to start playback"];
        [[self pompomArtistLabel] setMarqueeEnabled:YES];
        [[self pompomArtistLabel] setMarqueeRunning:YES];
        [[self pompomPlayerView] addSubview:[self pompomArtistLabel]];

        [[self pompomArtistLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomArtistLabel.leadingAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.trailingAnchor constant:16],
            [self.pompomArtistLabel.bottomAnchor constraintEqualToAnchor:self.pompomArtworkContainerView.bottomAnchor constant:-6]
        ]];

        if (displayRewindButton)
            [self.pompomArtistLabel.trailingAnchor constraintEqualToAnchor:self.pompomRewindButton.leadingAnchor constant:-16].active = YES;
        else if (!displayRewindButton && displayPlayButton) {
            [self.pompomArtistLabel.trailingAnchor constraintEqualToAnchor:self.pompomPlayButton.leadingAnchor constant:-16].active = YES;
        } else if (!displayRewindButton && !displayPlayButton && displaySkipButton) {
            [self.pompomArtistLabel.trailingAnchor constraintEqualToAnchor:self.pompomSkipButton.leadingAnchor constant:-16].active = YES;
        } else {
            [self.pompomArtistLabel.trailingAnchor constraintEqualToAnchor:self.pompomPlayerView.trailingAnchor].active = YES;
        }

        // time slider view
        if (displayTimeSlider) {
            self.pompomTimeSliderView = [UIView new];

            if ([[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible])
                [[[[self superview] superview] superview] addSubview:[self pompomTimeSliderView]];
            else
                [[self pompomPlayerView] addSubview:[self pompomTimeSliderView]];

            [[self pompomTimeSliderView] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [NSLayoutConstraint activateConstraints:@[
                [self.pompomTimeSliderView.topAnchor constraintEqualToAnchor:self.pompomPlayerView.bottomAnchor constant:4],
                [self.pompomTimeSliderView.leadingAnchor constraintEqualToAnchor:self.pompomPlayerView.leadingAnchor],
                [self.pompomTimeSliderView.trailingAnchor constraintEqualToAnchor:self.pompomPlayerView.trailingAnchor],
                [self.pompomTimeSliderView.heightAnchor constraintEqualToConstant:10]
            ]];
        }
    }

    // up next view
    if (displayUpNext) {
        self.pompomUpNextView = [UIView new];
        [self addSubview:[self pompomUpNextView]];

        [[self pompomUpNextView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomUpNextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
            [self.pompomUpNextView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
            [self.pompomUpNextView.heightAnchor constraintEqualToConstant:115]
        ]];

        if (replaceMediaPlayer && displayTimeSlider) {
            [self.pompomUpNextView.topAnchor constraintEqualToAnchor:self.pompomTimeSliderView.bottomAnchor constant:16].active = YES;
        } else if (replaceMediaPlayer && !displayTimeSlider) {
            [self.pompomUpNextView.topAnchor constraintEqualToAnchor:self.pompomPlayerView.bottomAnchor constant:24].active = YES;
        } else {
            [self.pompomUpNextView.topAnchor constraintEqualToAnchor:self.pompomDateLabel.bottomAnchor constant:24].active = YES;
        }

        // up next label
        self.pompomUpNextLabel = [UILabel new];
        [[self pompomUpNextLabel] setTextColor:[UIColor whiteColor]];
        [[self pompomUpNextLabel] setTextAlignment:NSTextAlignmentLeft];
        [[self pompomUpNextLabel] setFont:[UIFont systemFontOfSize:26 weight:UIFontWeightMedium]];
        [[self pompomUpNextLabel] setText:@"Up Next"];
        [[self pompomUpNextView] addSubview:[self pompomUpNextLabel]];

        [[self pompomUpNextLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomUpNextLabel.topAnchor constraintEqualToAnchor:self.pompomUpNextView.topAnchor],
            [self.pompomUpNextLabel.leadingAnchor constraintEqualToAnchor:self.pompomUpNextView.leadingAnchor],
            [self.pompomUpNextLabel.trailingAnchor constraintEqualToAnchor:self.pompomUpNextView.trailingAnchor],
        ]];

        // up next icon button
        self.pompomUpNextIconButton = [UIButton new];
        [[self pompomUpNextIconButton] addTarget:self action:@selector(openUpNextApplication) forControlEvents:UIControlEventTouchUpInside];

        UIImage* upNextIcon = [[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:@"com.apple.mobilecal"] scaleImageToSize:CGSizeMake(60, 60)];
        [[self pompomUpNextIconButton] setImage:upNextIcon forState:UIControlStateNormal];

        [[[self pompomUpNextIconButton] layer] setShadowColor:[[UIColor blackColor] CGColor]];
        [[[self pompomUpNextIconButton] layer] setShadowOffset:CGSizeZero];
        [[[self pompomUpNextIconButton] layer] setShadowOpacity:0.2];
        [[[self pompomUpNextIconButton] layer] setShadowRadius:5];
        [[self pompomUpNextIconButton] setAdjustsImageWhenHighlighted:NO];

        if ([[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible])
            [[[[self superview] superview] superview] addSubview:[self pompomUpNextIconButton]];
        else
            [[self pompomUpNextView] addSubview:[self pompomUpNextIconButton]];

        [[self pompomUpNextIconButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomUpNextIconButton.topAnchor constraintEqualToAnchor:self.pompomUpNextLabel.bottomAnchor constant:16],
            [self.pompomUpNextIconButton.leadingAnchor constraintEqualToAnchor:self.pompomUpNextView.leadingAnchor],
            [self.pompomUpNextIconButton.widthAnchor constraintEqualToConstant:60],
            [self.pompomUpNextIconButton.heightAnchor constraintEqualToConstant:60],
        ]];

        // up next event label
        self.pompomUpNextEventLabel = [UILabel new];
        [[self pompomUpNextEventLabel] setTextColor:[UIColor whiteColor]];
        [[self pompomUpNextEventLabel] setFont:[UIFont systemFontOfSize:21 weight:UIFontWeightMedium]];
        [[self pompomUpNextEventLabel] setMarqueeEnabled:YES];
        [[self pompomUpNextEventLabel] setMarqueeRunning:YES];
        [[self pompomUpNextView] addSubview:[self pompomUpNextEventLabel]];

        [[self pompomUpNextEventLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomUpNextEventLabel.topAnchor constraintEqualToAnchor:self.pompomUpNextIconButton.topAnchor constant:6],
            [self.pompomUpNextEventLabel.leadingAnchor constraintEqualToAnchor:self.pompomUpNextIconButton.trailingAnchor constant:16],
            [self.pompomUpNextEventLabel.trailingAnchor constraintEqualToAnchor:self.pompomUpNextView.trailingAnchor],
        ]];

        // up next date label
        self.pompomUpNextDateLabel = [UILabel new];
        [[self pompomUpNextDateLabel] setTextColor:[UIColor whiteColor]];
        [[self pompomUpNextDateLabel] setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        [[self pompomUpNextDateLabel] setMarqueeEnabled:YES];
        [[self pompomUpNextDateLabel] setMarqueeRunning:YES];
        [[self pompomUpNextView] addSubview:[self pompomUpNextDateLabel]];

        [[self pompomUpNextDateLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.pompomUpNextDateLabel.leadingAnchor constraintEqualToAnchor:self.pompomUpNextIconButton.trailingAnchor constant:16],
            [self.pompomUpNextDateLabel.trailingAnchor constraintEqualToAnchor:self.pompomUpNextView.trailingAnchor],
            [self.pompomUpNextDateLabel.bottomAnchor constraintEqualToAnchor:self.pompomUpNextIconButton.bottomAnchor constant:-6],
        ]];

        [self updatePomPomUpNext];
    }
}

- (void)layoutSubviews { // add the time slider
	%orig;

    if (!replaceMediaPlayer || !displayTimeSlider) return;
    [timeSlider removeFromSuperview];
    [[self pompomTimeSliderView] addSubview:timeSlider];
}

%new
- (void)updatePomPomTimeAndDate {
    NSDateFormatter* dateFormatter = [NSDateFormatter new];

    if (!isDisplayingBatteryLevel) {
        [dateFormatter setDateFormat:timeFormat];
        [[self pompomTimeLabel] setText:[dateFormatter stringFromDate:[NSDate date]]];
    }

    if (!timerRunning) {
        [dateFormatter setDateFormat:dateFormat];

        if (dateLocale && ![dateLocale isEqualToString:@""]) {
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:dateLocale]];
        }

        [[self pompomDateLabel] setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
}

%new
- (void)updatePomPomWeather {
    [[PDDokdo sharedInstance] refreshWeatherData];

    WALockscreenWidgetViewController* weatherWidget = [[PDDokdo sharedInstance] weatherWidget];
	WAForecastModel* currentModel = [weatherWidget currentForecastModel];
	WACurrentForecast* currentCondition = [currentModel currentConditions];
	NSUInteger currentCode = [currentCondition conditionCode]; // each condition has it's own code

	if (currentCode <= 2)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"tornado"]];
	else if (currentCode <= 4)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.bolt.rain.fill"]];
	else if (currentCode <= 8)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
	else if (currentCode == 9)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.drizzle.fill"]];
	else if (currentCode == 10)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
	else if (currentCode <= 12)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.rain.fill"]];
    else if (currentCode == 13)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
    else if (currentCode == 14)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
	else if (currentCode <= 16)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.snow.fill"]];
    else if (currentCode == 17)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.hail.fill"]];
	else if (currentCode <= 22)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.fog.fill"]];
	else if (currentCode <= 24)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"wind"]];
	else if (currentCode == 25)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"snow"]];
	else if (currentCode == 26)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.fill"]];
	else if (currentCode <= 28)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.sun.fill"]];
	else if (currentCode <= 30)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.sun.fill"]];
	else if (currentCode <= 32)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"sun.max.fill"]];
	else if (currentCode <= 34)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.sun.fill"]];
	else if (currentCode == 35)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
	else if (currentCode == 36)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"thermometer.sun.fill"]];
	else if (currentCode <= 38)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.bolt.fill"]];
	else if (currentCode == 39)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.sun.rain.fill"]];
	else if (currentCode == 40)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.heavyrain.fill"]];
	else if (currentCode <= 43)
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"cloud.snow.fill"]];
	else
		[[self pompomWeatherIconView] setImage:[UIImage systemImageNamed:@"exclamationmark.triangle.fill"]];
}

%new
- (void)updatePomPomMediaPlayer:(UIImage *)artwork :(NSString *)title :(NSString *)artist :(NSString *)album {
    if (artwork || title || artist || album) {
        if (!artwork) artwork = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PomPomPreferences.bundle/images/artwork-placeholder.png"];
        [[timeDateView pompomArtworkButton] setImage:artwork forState:UIControlStateNormal];
        
        UIImage* playImage = [[UIImage systemImageNamed:@"play.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:27.5]];
        [[timeDateView pompomPlayButton] setImage:playImage forState:UIControlStateNormal];
        
        if (!title) title = @"N/A";
        [[timeDateView pompomSongTitleLabel] setText:title];
        
        if (artist && album) {
            [[timeDateView pompomArtistLabel] setText:[NSString stringWithFormat:@"%@ — %@", artist, album]];
        } else if (artist && !album) {
            [[timeDateView pompomArtistLabel] setText:[NSString stringWithFormat:@"%@", artist]];
        } else if (!artist && album) {
            [[timeDateView pompomArtistLabel] setText:[NSString stringWithFormat:@"%@", album]];
        } else {
            [[timeDateView pompomArtistLabel] setText:@"N/A"];
        }

        if (timeSlider)
            [self layoutSubviews];
    } else {
        UIImage* artworkPlaceholder = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PomPomPreferences.bundle/images/artwork-placeholder.png"];
        [[timeDateView pompomArtworkButton] setImage:artworkPlaceholder forState:UIControlStateNormal];
        
        UIImage* playImage = [[UIImage systemImageNamed:@"play.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:27.5]];
        [[timeDateView pompomPlayButton] setImage:playImage forState:UIControlStateNormal];
        
        [[timeDateView pompomSongTitleLabel] setText:@"Not playing"];
        [[timeDateView pompomArtistLabel] setText:@"Tap play to start playback"];

        if (timeSlider)
            [timeSlider removeFromSuperview];
    }
}

%new
- (void)updatePomPomPlayButton:(BOOL)isPlaying {
    if (isPlaying) {
        UIImage* pauseImage = [[UIImage systemImageNamed:@"pause.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:27.5]];
        [[self pompomPlayButton] setImage:pauseImage forState:UIControlStateNormal];
    } else {
        UIImage* playImage = [[UIImage systemImageNamed:@"play.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:27.5]];
        [[self pompomPlayButton] setImage:playImage forState:UIControlStateNormal];
    }
}

%new
- (void)openNowPlayingApplication {
    if (![[%c(SBMediaController) sharedInstance] _nowPlayingInfo]) return;
    [[%c(SBLockScreenManager) sharedInstance] setPomPomQueueApplication:[[[%c(SBMediaController) sharedInstance] nowPlayingApplication] bundleIdentifier]];
}

%new
- (void)rewindSong {
    [[%c(SBMediaController) sharedInstance] changeTrack:-1 eventSource:0];
}

%new
- (void)togglePlayback {
    if (![[%c(SBMediaController) sharedInstance] _nowPlayingInfo]) { // check if music is already playing
        [[%c(SBMediaController) sharedInstance] playForEventSource:0];
    } else {
        [[%c(SBMediaController) sharedInstance] togglePlayPauseForEventSource:0];
    }
}

%new
- (void)skipSong {
    [[%c(SBMediaController) sharedInstance] changeTrack:1 eventSource:0];
}

%new
- (void)openUpNextApplication {
    [[%c(SBLockScreenManager) sharedInstance] setPomPomQueueApplication:@"com.apple.mobilecal"];
}

%new
- (void)updatePomPomUpNext {
    EKEvent* event = [self fetchEvent];

    if (event) {
        [[self pompomUpNextEventLabel] setText:[event title]];

        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[event startDate]];
        if ([[NSCalendar currentCalendar] isDateInToday:[event startDate]]) {
            if (![event isAllDay]) {
                [[self pompomUpNextDateLabel] setText:[NSString stringWithFormat:@"Today %02ld:%02ld", [components hour], [components minute]]];
            } else {
                [[self pompomUpNextDateLabel] setText:@"Today"];
            }
        } else if ([[NSCalendar currentCalendar] isDateInTomorrow:[event startDate]]) {
            if (![event isAllDay]) {
                [[self pompomUpNextDateLabel] setText:[NSString stringWithFormat:@"Tomorrow %02ld:%02ld", [components hour], [components minute]]];
            } else {
                [[self pompomUpNextDateLabel] setText:@"Tomorrow"];
            }
        } else {
            if (![event isAllDay]) {
                if (!useAmericanDateFormat)
                    [[self pompomUpNextDateLabel] setText:[NSString stringWithFormat:@"%02ld.%02ld.%02ld %02ld:%02ld", [components day], [components month], [components year], [components hour], [components minute]]];
                else
                    [[self pompomUpNextDateLabel] setText:[NSString stringWithFormat:@"%02ld.%02ld.%02ld %02ld:%02ld", [components month], [components day], [components year], [components hour], [components minute]]];
            } else {
                if (!useAmericanDateFormat)
                    [[self pompomUpNextDateLabel] setText:[NSString stringWithFormat:@"%02ld.%02ld.%02ld", [components day], [components month], [components year]]];
                else
                    [[self pompomUpNextDateLabel] setText:[NSString stringWithFormat:@"%02ld.%02ld.%02ld", [components month], [components day], [components year]]];
            }
        }
    } else {
        [[self pompomUpNextEventLabel] setText:@"No events"];
        [[self pompomUpNextDateLabel] setText:@"Events will appear here"];
    }
}

%new
- (EKEvent *)fetchEvent {
    EKEventStore* store = [EKEventStore new];
    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* todayComponents = [NSDateComponents new];
    [todayComponents setDay:0];
    NSDate* today = [calendar dateByAddingComponents:todayComponents toDate:[NSDate date] options:0];

    NSDateComponents* daysFromNowComponents = [NSDateComponents new];
    [daysFromNowComponents setDay:eventsRange];
    NSDate* daysFromNow = [calendar dateByAddingComponents:daysFromNowComponents toDate:[NSDate date] options:0];

    NSPredicate* predicate = [store predicateForEventsWithStartDate:today endDate:daysFromNow calendars:nil];

    NSArray* events = [store eventsMatchingPredicate:predicate];
    return [events count] == 0 ? nil : events[0];
}

%end

%hook SBFLockScreenDateSubtitleView

- (void)setString:(NSString *)arg1 { // apply running timers to the pompom date label
    %orig;

    if ([arg1 containsString:@":"]) {
        timerRunning = YES;
        [[timeDateView pompomDateLabel] setText:arg1];
    } else {
        timerRunning = NO;
    }
}

%end

%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated { // update pompom when the lock screen appears and start the update timer
	%orig;
    
	[self updatePomPomTimeAndDate];
    if (displayWeather) [timeDateView updatePomPomWeather];
    if (displayUpNext) [timeDateView updatePomPomUpNext];
	if (!updateTimer) updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePomPomTimeAndDate) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated { // stop the update timer when the lock screen disappears
	%orig;

	[updateTimer invalidate];
	updateTimer = nil;
}

%new
- (void)updatePomPomTimeAndDate {
    [timeDateView updatePomPomTimeAndDate];
}

%end

%hook SBBacklightController

- (void)turnOnScreenFullyWithBacklightSource:(long long)arg1 {
	%orig;

    if (![[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible]) return; // this method doesn't only get called when the screen turns on
	[self updatePomPomTimeAndDate];
    if (displayWeather) [timeDateView updatePomPomWeather];
    if (displayUpNext) [timeDateView updatePomPomUpNext];
	if (!updateTimer) updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePomPomTimeAndDate) userInfo:nil repeats:YES];
}

%new
- (void)updatePomPomTimeAndDate {
    [timeDateView updatePomPomTimeAndDate];
}

%end

%hook SBLockScreenManager

%property(nonatomic, assign)NSString* queuedPomPomBundleIdentifier;

- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 { // stop the update timer when the device was locked
	%orig;

	[updateTimer invalidate];
	updateTimer = nil;
}

- (void)lockScreenViewControllerWillDismiss {
    %orig;

    if (![self isUILocked] && [self queuedPomPomBundleIdentifier]) {
        [[UIApplication sharedApplication] launchApplicationWithIdentifier:[self queuedPomPomBundleIdentifier] suspended:NO];
        [self setQueuedPomPomBundleIdentifier:nil];
    }
}

%new
- (void)setPomPomQueueApplication:(NSString *)bundleIdentifier {
    [self setQueuedPomPomBundleIdentifier:bundleIdentifier];
    if ([self queuedPomPomBundleIdentifier]) [self unlockUIFromSource:17 withOptions:nil];
}

%end

%hook CSPasscodeViewController

- (void)viewDidDisappear:(BOOL)animated {
    %orig;
    [[%c(SBLockScreenManager) sharedInstance] setPomPomQueueApplication:nil];
}

%end

%hook MRUNowPlayingTimeControlsView

- (void)layoutSubviews { // get a time slider instance
	%orig;

    if (!replaceMediaPlayer || !displayTimeSlider) return;
	MRUNowPlayingViewController* controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if ([controller respondsToSelector:@selector(delegate)] && ![controller.delegate isKindOfClass:%c(MRUControlCenterViewController)]) {
        timeSlider = self;
        UILabel* elapsedTimeLabel = [timeSlider valueForKey:@"_elapsedTimeLabel"];
        UILabel* remainingTimeLabel = [timeSlider valueForKey:@"_remainingTimeLabel"];
        [elapsedTimeLabel removeFromSuperview];
        [remainingTimeLabel removeFromSuperview];
    }
}

- (void)setFrame:(CGRect)frame { // set the frame of the time slider instance
    if (!replaceMediaPlayer || !displayTimeSlider) {
        %orig;
        return;
    }

    MRUNowPlayingViewController* controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
    if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(MRUControlCenterViewController)]) {
        %orig;
    } else {
        %orig(CGRectMake(timeDateView.pompomTimeSliderView.frame.size.width / 2 - frame.size.width / 2, CGRectGetMidY(timeDateView.pompomTimeSliderView.bounds) - 22.5, frame.size.width, frame.size.height));
    }
}

%end

%hook SBUIController

- (void)ACPowerChanged { // display the battery percentage on the time label when plugged in
	%orig;

	if ([self isOnAC]) {
        isDisplayingBatteryLevel = YES;
        [UIView transitionWithView:[timeDateView pompomTimeLabel] duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[[timeDateView pompomTimeLabel] setText:[NSString stringWithFormat:@"%d%%", [self batteryCapacityAsPercentage]]];
		} completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [UIView transitionWithView:[timeDateView pompomTimeLabel] duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    NSDateFormatter* dateFormatter = [NSDateFormatter new];
                    [dateFormatter setDateFormat:timeFormat];
                    [[timeDateView pompomTimeLabel] setText:[dateFormatter stringFromDate:[NSDate date]]];
                } completion:nil];
                isDisplayingBatteryLevel = NO;
            });
        }];
    }
}

%end

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // update the pompom player data
    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;
            if (dict) {
                UIImage* artwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
                NSString* title = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle];
                NSString* artist = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist];
                NSString* album = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum];

                [timeDateView updatePomPomMediaPlayer:artwork :title :artist :album];
                [timeDateView updatePomPomPlayButton:[self isPlaying]];
            }
        } else {
            if ([self _nowPlayingInfo]) return;
            [timeDateView updatePomPomMediaPlayer:nil :nil :nil :nil];
        }
  	});
}

- (void)_mediaRemoteNowPlayingApplicationIsPlayingDidChange:(id)arg1 {
    %orig;
    [timeDateView updatePomPomPlayButton:[self isPlaying]];
}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 { // reload the now playing data after a respring
    %orig;
    [[%c(SBMediaController) sharedInstance] setNowPlayingInfo:0];
}

%end

%hook NCNotificationListView

- (void)setRevealed:(BOOL)arg1 { // always reveal notifications
    if (alwaysRevealNotifications)
        %orig(YES);
    else
        %orig;
}

%end

%hook CSCombinedListViewController

- (UIEdgeInsets)_listViewDefaultContentInsets {
    UIEdgeInsets originalInsets = %orig;

    if (replaceMediaPlayer && displayUpNext)
        originalInsets.top += 200;
    else if (!replaceMediaPlayer && displayUpNext)
        originalInsets.top += 110;
    else if (replaceMediaPlayer && !displayUpNext)
        originalInsets.top += 60;
    else
        originalInsets.top += -20;

    if (replaceMediaPlayer && timeSlider && !displayUpNext)
        originalInsets.top += 10;

    originalInsets.top += additionalNotificationsOffset;

    return originalInsets;
}

%end

%end

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"auraoflove.pompompreferences"];

    [preferences registerBool:&enabled default:YES forKey:@"enabled"];
    if (!enabled) return;

    // appearance
    [preferences registerBool:&hideFaceIDLock default:NO forKey:@"hideFaceIDLock"];
    [preferences registerBool:&hideFlashlight default:NO forKey:@"hideFlashlight"];
    [preferences registerBool:&hideCamera default:NO forKey:@"hideCamera"];
    [preferences registerBool:&hideQuickActionsBackground default:NO forKey:@"hideQuickActionsBackground"];
    [preferences registerBool:&hideUnlockText default:NO forKey:@"hideUnlockText"];
    [preferences registerBool:&hidePageDots default:NO forKey:@"hidePageDots"];
    [preferences registerBool:&hideHomebar default:NO forKey:@"hideHomebar"];

    // media player
    [preferences registerBool:&replaceMediaPlayer default:YES forKey:@"replaceMediaPlayer"];
    if (replaceMediaPlayer) {
        [preferences registerBool:&displayRewindButton default:YES forKey:@"displayRewindButton"];
        [preferences registerBool:&displayPlayButton default:YES forKey:@"displayPlayButton"];
        [preferences registerBool:&displaySkipButton default:YES forKey:@"displaySkipButton"];
        [preferences registerBool:&displayTimeSlider default:YES forKey:@"displayTimeSlider"];
        [preferences registerUnsignedInteger:&timeSliderOverrideStyle default:2 forKey:@"timeSliderOverrideStyle"];
    }

    // notifications
    [preferences registerBool:&hideNotificationsHeader default:YES forKey:@"hideNotificationsHeader"];
    [preferences registerBool:&hideNoOlderNotifications default:YES forKey:@"hideNoOlderNotifications"];
    [preferences registerInteger:&additionalNotificationsOffset default:0 forKey:@"additionalNotificationsOffset"];
    [preferences registerBool:&alwaysRevealNotifications default:YES forKey:@"alwaysRevealNotifications"];

    // time and date
    [preferences registerObject:&timeFormat default:@"HH:mm" forKey:@"timeFormat"];
    [preferences registerObject:&dateFormat default:@"EEEE d. MMMM" forKey:@"dateFormat"];
    [preferences registerObject:&dateLocale default:nil forKey:@"dateLocale"];
    [preferences registerBool:&displayWeather default:NO forKey:@"displayWeather"];

    // up next
    [preferences registerBool:&displayUpNext default:YES forKey:@"displayUpNext"];
    if (displayUpNext) {
        [preferences registerUnsignedInteger:&eventsRange default:7 forKey:@"eventsRange"];
        [preferences registerBool:&useAmericanDateFormat default:NO forKey:@"useAmericanDateFormat"];
    }

    %init(PomPomOriginalUserInterfaceAppearance);
    %init(PomPomCore);
}
