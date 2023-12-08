#import "Heartlines.h"

SBUIProudLockIconView* faceIDLock = nil;
SBFLockScreenDateView* timeDateView = nil;

%group Heartlines

%hook SBUIProudLockIconView

- (id)initWithFrame:(CGRect)frame { // get an instance of the faceid lock

    id orig = %orig;
    faceIDLock = self;

    return orig;

}

- (void)didMoveToWindow { // hide faceid lock

    if (!hideFaceIDLockSwitch)
        %orig;
    else
        [self removeFromSuperview];
    
}

- (void)setFrame:(CGRect)frame { // align and set the size of the face id lock

    %orig;

    if (alignFaceIDLockSwitch) {
        if ([positionValue intValue] == 0) {
            if (smallerFaceIDLockSwitch) self.center = CGPointMake(self.center.x / 4, self.center.y + 10);
            else self.center = CGPointMake(self.center.x / 4, self.center.y);
        } else if ([positionValue intValue] == 1) {
            if (smallerFaceIDLockSwitch) self.center = CGPointMake(self.center.x, self.center.y + 10);
        } else if ([positionValue intValue] == 2) {
            if (smallerFaceIDLockSwitch) self.center = CGPointMake(self.center.x * 1.75, self.center.y + 10);
            else self.center = CGPointMake(self.center.x * 1.75, self.center.y);
        }
    }
    
    if (smallerFaceIDLockSwitch) self.transform = CGAffineTransformMakeScale(0.85, 0.85);
    if (!alignFaceIDLockSwitch && smallerFaceIDLockSwitch) self.center = CGPointMake(self.center.x, self.center.y + 10);

}

- (void)setContentColor:(UIColor *)arg1 { // set faceid lock color

    if (artworkBasedColorsSwitch && ([[%c(SBMediaController) sharedInstance] isPlaying] || [[%c(SBMediaController) sharedInstance] isPaused])) return %orig;
    if ([faceIDLockColorValue intValue] == 0)
        %orig(backgroundWallpaperColor);
    else if ([faceIDLockColorValue intValue] == 1)
        %orig(primaryWallpaperColor);
    else if ([faceIDLockColorValue intValue] == 2)
        %orig(secondaryWallpaperColor);
    else if ([faceIDLockColorValue intValue] == 3)
        %orig([GcColorPickerUtils colorWithHex:customFaceIDLockColorValue]);
    else
        %orig;

}

%end

%hook UIMorphingLabel

- (void)didMoveToWindow { // hide faceid lock label

    if (hideFaceIDLockSwitch) return %orig;
    UIViewController* ancestor = [self _viewControllerForAncestor];
    if ([ancestor isKindOfClass:%c(SBUIProudLockContainerViewController)])
        [self removeFromSuperview];
    else
        %orig;

}

%end

%hook SBFLockScreenDateSubtitleView

- (void)didMoveToWindow { // remove original date label

    %orig;

    SBUILegibilityLabel* originalheartlinesDateLabel = [self valueForKey:@"_label"];
    [originalheartlinesDateLabel removeFromSuperview];

}

%end

%hook SBLockScreenTimerDialView

- (void)didMoveToWindow { // remove timer icon

    %orig;

    [self removeFromSuperview];

}

%end

%hook SBFLockScreenDateSubtitleDateView

- (void)didMoveToWindow { // remove lunar label

    %orig;

    SBFLockScreenAlternateDateLabel* lunarLabel = [self valueForKey:@"_alternateDateLabel"];
    [lunarLabel removeFromSuperview];

}

%end

%hook SBFLockScreenDateView

%property(nonatomic, retain)UILabel* heartlinesWeatherReportLabel;
%property(nonatomic, retain)UILabel* heartlinesWeatherConditionLabel;
%property(nonatomic, retain)UILabel* heartlinesTimeLabel;
%property(nonatomic, retain)UILabel* heartlinesDateLabel;
%property(nonatomic, retain)UILabel* heartlinesUpNextLabel;
%property(nonatomic, retain)UILabel* heartlinesUpNextEventLabel;
%property(nonatomic, retain)UIView* heartlinesInvisibleInk;

- (id)initWithFrame:(CGRect)frame { // add notification observer

    id orig = %orig;

    timeDateView = self;

    return orig;
    
}

- (void)didMoveToWindow { // add heartlines

	%orig;

    if ([self heartlinesTimeLabel]) return;

    // remove original time label
    SBUILegibilityLabel* originalheartlinesTimeLabel = [self valueForKey:@"timeLabel"];
    [originalheartlinesTimeLabel removeFromSuperview];


    if ([styleValue intValue] == 0) {
        // up next label
        if (showUpNextSwitch) {
            self.heartlinesUpNextLabel = [UILabel new];
            
            if (!useCustomFontSwitch){
                if (!useCustomUpNextFontSizeSwitch) {
                    [[self heartlinesUpNextLabel] setFont:[UIFont systemFontOfSize:19 weight:UIFontWeightSemibold]];
                } else {
                    [[self heartlinesUpNextLabel] setFont:[UIFont systemFontOfSize:[customUpNextFontSizeValue intValue] weight:UIFontWeightSemibold]];
                }
            } else {
                if (!useCustomUpNextFontSizeSwitch) {
                    [[self heartlinesUpNextLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:19]];
                } else {
                    [[self heartlinesUpNextLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customUpNextFontSizeValue intValue]]];
                }
            }
                
            if ([[HLSLocalization stringForKey:@"UP_NEXT"] isEqual:nil]) [[self heartlinesUpNextLabel] setText:@"Up next"];
            else if (![[HLSLocalization stringForKey:@"UP_NEXT"] isEqual:nil]) [[self heartlinesUpNextLabel] setText:[NSString stringWithFormat:@"%@", [HLSLocalization stringForKey:@"UP_NEXT"]]];
                
            if ([positionValue intValue] == 0) [[self heartlinesUpNextLabel] setTextAlignment:NSTextAlignmentLeft];
            else if ([positionValue intValue] == 1) [[self heartlinesUpNextLabel] setTextAlignment:NSTextAlignmentCenter];
            else if ([positionValue intValue] == 2) [[self heartlinesUpNextLabel] setTextAlignment:NSTextAlignmentRight];


            [[self heartlinesUpNextLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesUpNextLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
            [[self heartlinesUpNextLabel].heightAnchor constraintEqualToConstant:21].active = YES;
                
            if (![[self heartlinesUpNextLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesUpNextLabel]];
                
            if ([positionValue intValue] == 0) [[self heartlinesUpNextLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
            else if ([positionValue intValue] == 1) [[self heartlinesUpNextLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            else if ([positionValue intValue] == 2) [[self heartlinesUpNextLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
                
            [[self heartlinesUpNextLabel].centerYAnchor constraintEqualToAnchor:self.topAnchor constant:16].active = YES;
        }


        // up next event label
        if (showUpNextSwitch) {
            self.heartlinesUpNextEventLabel = [UILabel new];

            if (!useCustomFontSwitch){
                if (!useCustomUpNextEventFontSizeSwitch) {
                    [[self heartlinesUpNextEventLabel] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                } else {
                    [[self heartlinesUpNextEventLabel] setFont:[UIFont systemFontOfSize:[customUpNextEventFontSizeValue intValue] weight:UIFontWeightSemibold]];
                }
            } else {
                if (!useCustomUpNextEventFontSizeSwitch) {
                    [[self heartlinesUpNextEventLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:15]];
                } else {
                    [[self heartlinesUpNextEventLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customUpNextEventFontSizeValue intValue]]];
                }
            }
                
            if ([[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:@"No upcoming events"];
            else if (![[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:[NSString stringWithFormat:@"%@", [HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"]]];
                
            if ([positionValue intValue] == 0) [[self heartlinesUpNextEventLabel] setTextAlignment:NSTextAlignmentLeft];
            else if ([positionValue intValue] == 1) [[self heartlinesUpNextEventLabel] setTextAlignment:NSTextAlignmentCenter];
            else if ([positionValue intValue] == 2) [[self heartlinesUpNextEventLabel] setTextAlignment:NSTextAlignmentRight];
                

            [[self heartlinesUpNextEventLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesUpNextEventLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
            [[self heartlinesUpNextEventLabel].heightAnchor constraintEqualToConstant:16].active = YES;
                
            if (![[self heartlinesUpNextEventLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesUpNextEventLabel]];
                
            if ([positionValue intValue] == 0) [[self heartlinesUpNextEventLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
            else if ([positionValue intValue] == 1) [[self heartlinesUpNextEventLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            else if ([positionValue intValue] == 2) [[self heartlinesUpNextEventLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
                
            [[self heartlinesUpNextEventLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesUpNextLabel].bottomAnchor constant:12].active = YES;
        }


        // invisible ink
        if (showUpNextSwitch && hideUntilAuthenticatedSwitch && invisibleInkEffectSwitch) {
            self.heartlinesInvisibleInk = [NSClassFromString(@"CKheartlinesInvisibleInkImageEffectView") new];
            [[self heartlinesInvisibleInk] setHidden:YES];


            [[self heartlinesInvisibleInk] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesInvisibleInk].widthAnchor constraintEqualToConstant:160].active = YES;
            [[self heartlinesInvisibleInk].heightAnchor constraintEqualToConstant:21].active = YES;
            
            if (![[self heartlinesInvisibleInk] isDescendantOfView:self]) [self addSubview:[self heartlinesInvisibleInk]];
            
            if ([positionValue intValue] == 0) [[self heartlinesInvisibleInk].centerXAnchor constraintEqualToAnchor:self.leftAnchor constant:87.5].active = YES;
            else if ([positionValue intValue] == 1) [[self heartlinesInvisibleInk].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            else if ([positionValue intValue] == 2) [[self heartlinesInvisibleInk].centerXAnchor constraintEqualToAnchor:self.rightAnchor constant:-75].active = YES;
            
            [[self heartlinesInvisibleInk].centerYAnchor constraintEqualToAnchor:[self heartlinesUpNextLabel].bottomAnchor constant:16].active = YES;
        }


        // time label
        self.heartlinesTimeLabel = [UILabel new];

        if (!useCustomFontSwitch){
            if (!useCustomTimeFontSizeSwitch) {
                [[self heartlinesTimeLabel] setFont:[UIFont systemFontOfSize:61 weight:UIFontWeightRegular]];
            } else {
                [[self heartlinesTimeLabel] setFont:[UIFont systemFontOfSize:[customTimeFontSizeValue intValue] weight:UIFontWeightRegular]];
            }
        } else {
            if (!useCustomTimeFontSizeSwitch) {
                [[self heartlinesTimeLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:61]];
            } else {
                [[self heartlinesTimeLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customTimeFontSizeValue intValue]]];
            }
        }
            
        NSDateFormatter* timeFormat = [NSDateFormatter new];
        [timeFormat setDateFormat:timeFormatValue];
        [[self heartlinesTimeLabel] setText:[timeFormat stringFromDate:[NSDate date]]];
            
        if ([positionValue intValue] == 0) [[self heartlinesTimeLabel] setTextAlignment:NSTextAlignmentLeft];
        else if ([positionValue intValue] == 1) [[self heartlinesTimeLabel] setTextAlignment:NSTextAlignmentCenter];
        else if ([positionValue intValue] == 2) [[self heartlinesTimeLabel] setTextAlignment:NSTextAlignmentRight];
            

        [[self heartlinesTimeLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self heartlinesTimeLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
        [[self heartlinesTimeLabel].heightAnchor constraintEqualToConstant:73].active = YES;
            
        if (![[self heartlinesTimeLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesTimeLabel]];
            
        if ([positionValue intValue] == 0) [[self heartlinesTimeLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:4].active = YES;
        else if ([positionValue intValue] == 1) [[self heartlinesTimeLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
        else if ([positionValue intValue] == 2) [[self heartlinesTimeLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-4].active = YES;
            
        if (showUpNextSwitch) [[self heartlinesTimeLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesUpNextEventLabel].bottomAnchor constant:40].active = YES;
        else if (!showUpNextSwitch) [[self heartlinesTimeLabel].centerYAnchor constraintEqualToAnchor:self.topAnchor constant:40].active = YES;


        // date label
        self.heartlinesDateLabel = [UILabel new];

        if (!useCustomFontSwitch){
            if (!useCustomDateFontSizeSwitch) {
                [[self heartlinesDateLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
            } else {
                [[self heartlinesDateLabel] setFont:[UIFont systemFontOfSize:[customDateFontSizeValue intValue] weight:UIFontWeightSemibold]];
            }
        } else {
            if (!useCustomDateFontSizeSwitch) {
                [[self heartlinesDateLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:17]];
            } else {
                [[self heartlinesDateLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customDateFontSizeValue intValue]]];
            }
        }
            
        if (!isTimerRunning) {
            NSDateFormatter* dateFormat = [NSDateFormatter new];
            [dateFormat setDateFormat:dateFormatValue];
            [[self heartlinesDateLabel] setText:[[dateFormat stringFromDate:[NSDate date]] capitalizedString]];
        }
            
        if ([positionValue intValue] == 0) [[self heartlinesDateLabel] setTextAlignment:NSTextAlignmentLeft];
        else if ([positionValue intValue] == 1) [[self heartlinesDateLabel] setTextAlignment:NSTextAlignmentCenter];
        else if ([positionValue intValue] == 2) [[self heartlinesDateLabel] setTextAlignment:NSTextAlignmentRight];
            

        [[self heartlinesDateLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self heartlinesDateLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
        [[self heartlinesDateLabel].heightAnchor constraintEqualToConstant:21].active = YES;
            
        if (![[self heartlinesDateLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesDateLabel]];
            
        if ([positionValue intValue] == 0) [[self heartlinesDateLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
        else if ([positionValue intValue] == 1) [[self heartlinesDateLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
        else if ([positionValue intValue] == 2) [[self heartlinesDateLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
            
        [[self heartlinesDateLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesTimeLabel].bottomAnchor constant:8].active = YES;


        // weather report label
        if (showWeatherSwitch) {
            self.heartlinesWeatherReportLabel = [UILabel new];

            if (!useCustomFontSwitch){
                if (!useCustomWeatherReportFontSizeSwitch) {
                    [[self heartlinesWeatherReportLabel] setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]];
                } else {
                    [[self heartlinesWeatherReportLabel] setFont:[UIFont systemFontOfSize:[customWeatherReportFontSizeValue intValue] weight:UIFontWeightSemibold]];
                }
            } else {
                if (!useCustomWeatherReportFontSizeSwitch) {
                    [[self heartlinesWeatherReportLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:14]];
                } else {
                    [[self heartlinesWeatherReportLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customWeatherReportFontSizeValue intValue]]];
                }
            }
                
            [[PDDokdo sharedInstance] refreshWeatherData];
            if ([[HLSLocalization stringForKey:@"CURRENTLY_ITS"] isEqual:nil]) [[self heartlinesWeatherReportLabel] setText:[NSString stringWithFormat:@"Currently it's %@", [[PDDokdo sharedInstance] currentTemperature]]];
            else if (![[HLSLocalization stringForKey:@"CURRENTLY_ITS"] isEqual:nil]) [[self heartlinesWeatherReportLabel] setText:[NSString stringWithFormat:@"%@ %@", [HLSLocalization stringForKey:@"CURRENTLY_ITS"], [[PDDokdo sharedInstance] currentTemperature]]];
                
            if ([positionValue intValue] == 0) [[self heartlinesWeatherReportLabel] setTextAlignment:NSTextAlignmentLeft];
            else if ([positionValue intValue] == 1) [[self heartlinesWeatherReportLabel] setTextAlignment:NSTextAlignmentCenter];
            else if ([positionValue intValue] == 2) [[self heartlinesWeatherReportLabel] setTextAlignment:NSTextAlignmentRight];


            [[self heartlinesWeatherReportLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesWeatherReportLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
            [[self heartlinesWeatherReportLabel].heightAnchor constraintEqualToConstant:21].active = YES;
                
            if (![[self heartlinesWeatherReportLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesWeatherReportLabel]];
                
            if ([positionValue intValue] == 0) [[self heartlinesWeatherReportLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
            else if ([positionValue intValue] == 1) [[self heartlinesWeatherReportLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            else if ([positionValue intValue] == 2) [[self heartlinesWeatherReportLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
                
            [[self heartlinesWeatherReportLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesDateLabel].bottomAnchor constant:16].active = YES;
        }


        // weather condition label
        if (showWeatherSwitch) {
            self.heartlinesWeatherConditionLabel = [UILabel new];

            if (!useCustomFontSwitch){
                if (!useCustomWeatherConditionFontSizeSwitch) {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]];
                } else {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont systemFontOfSize:[customWeatherConditionFontSizeValue intValue] weight:UIFontWeightSemibold]];
                }
            } else {
                if (!useCustomWeatherConditionFontSizeSwitch) {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:14]];
                } else {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customWeatherConditionFontSizeValue intValue]]];
                }
            }
            
            [[self heartlinesWeatherConditionLabel] setText:[NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentConditions]]];
            
            if ([positionValue intValue] == 0) [[self heartlinesWeatherConditionLabel] setTextAlignment:NSTextAlignmentLeft];
            else if ([positionValue intValue] == 1) [[self heartlinesWeatherConditionLabel] setTextAlignment:NSTextAlignmentCenter];
            else if ([positionValue intValue] == 2) [[self heartlinesWeatherConditionLabel] setTextAlignment:NSTextAlignmentRight];
            

            [[self heartlinesWeatherConditionLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesWeatherConditionLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
            [[self heartlinesWeatherConditionLabel].heightAnchor constraintEqualToConstant:21].active = YES;
            
            if (![[self heartlinesWeatherConditionLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesWeatherConditionLabel]];
            
            if ([positionValue intValue] == 0) [[self heartlinesWeatherConditionLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
            else if ([positionValue intValue] == 1) [[self heartlinesWeatherConditionLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            else if ([positionValue intValue] == 2) [[self heartlinesWeatherConditionLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
            
            [[self heartlinesWeatherConditionLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesWeatherReportLabel].bottomAnchor constant:8].active = YES;
        }
    } else if ([styleValue intValue] == 1) {
        // weather condition label
        if (showWeatherSwitch) {
            self.heartlinesWeatherConditionLabel = [UILabel new];
            
            if (!useCustomFontSwitch){
                if (!useCustomWeatherConditionFontSizeSwitch) {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]];
                } else {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont systemFontOfSize:[customWeatherConditionFontSizeValue intValue] weight:UIFontWeightSemibold]];
                }
            } else {
                if (!useCustomWeatherConditionFontSizeSwitch) {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:14]];
                } else {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customWeatherConditionFontSizeValue intValue]]];
                }
            }
            
            [[PDDokdo sharedInstance] refreshWeatherData];
            [[self heartlinesWeatherConditionLabel] setText:[NSString stringWithFormat:@"%@, %@",[[PDDokdo sharedInstance] currentConditions], [[PDDokdo sharedInstance] currentTemperature]]];

            if ([positionValue intValue] == 0) [[self heartlinesWeatherConditionLabel] setTextAlignment:NSTextAlignmentLeft];
            else if ([positionValue intValue] == 1) [[self heartlinesWeatherConditionLabel] setTextAlignment:NSTextAlignmentCenter];
            else if ([positionValue intValue] == 2) [[self heartlinesWeatherConditionLabel] setTextAlignment:NSTextAlignmentRight];
            
            
            [[self heartlinesWeatherConditionLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesWeatherConditionLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
            [[self heartlinesWeatherConditionLabel].heightAnchor constraintEqualToConstant:21].active = YES;
            
            if (![[self heartlinesWeatherConditionLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesWeatherConditionLabel]];
            
            if ([positionValue intValue] == 0) [[self heartlinesWeatherConditionLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
            else if ([positionValue intValue] == 1) [[self heartlinesWeatherConditionLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            else if ([positionValue intValue] == 2) [[self heartlinesWeatherConditionLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
            
            [[self heartlinesWeatherConditionLabel].centerYAnchor constraintEqualToAnchor:self.topAnchor constant:16].active = YES;
        }


        // date label
        self.heartlinesDateLabel = [UILabel new];
            
        if (!useCustomFontSwitch){
            if (!useCustomDateFontSizeSwitch) {
                [[self heartlinesDateLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
            } else {
                [[self heartlinesDateLabel] setFont:[UIFont systemFontOfSize:[customDateFontSizeValue intValue] weight:UIFontWeightSemibold]];
            }
        } else {
            if (!useCustomDateFontSizeSwitch) {
                [[self heartlinesDateLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:17]];
            } else {
                [[self heartlinesDateLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customDateFontSizeValue intValue]]];
            }
        }
            
        if (!isTimerRunning) {
            NSDateFormatter* dateFormat = [NSDateFormatter new];
            [dateFormat setDateFormat:dateFormatValue];
            [[self heartlinesDateLabel] setText:[[dateFormat stringFromDate:[NSDate date]] capitalizedString]];
        }
            
        if ([positionValue intValue] == 0) [[self heartlinesDateLabel] setTextAlignment:NSTextAlignmentLeft];
        else if ([positionValue intValue] == 1) [[self heartlinesDateLabel] setTextAlignment:NSTextAlignmentCenter];
        else if ([positionValue intValue] == 2) [[self heartlinesDateLabel] setTextAlignment:NSTextAlignmentRight];
            

        [[self heartlinesDateLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self heartlinesDateLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
        [[self heartlinesDateLabel].heightAnchor constraintEqualToConstant:21].active = YES;
            
        if (![[self heartlinesDateLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesDateLabel]];
            
        if ([positionValue intValue] == 0) [[self heartlinesDateLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
        else if ([positionValue intValue] == 1) [[self heartlinesDateLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
        else if ([positionValue intValue] == 2) [[self heartlinesDateLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
            
        if (showWeatherSwitch) [[self heartlinesDateLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesWeatherConditionLabel].bottomAnchor constant:10].active = YES;
        else if (!showWeatherSwitch) [[self heartlinesDateLabel].centerYAnchor constraintEqualToAnchor:self.topAnchor constant:16].active = YES;


        // time label
        self.heartlinesTimeLabel = [UILabel new];
            
        if (!useCustomFontSwitch){
            if (!useCustomTimeFontSizeSwitch) {
                [[self heartlinesTimeLabel] setFont:[UIFont systemFontOfSize:61 weight:UIFontWeightRegular]];
            } else {
                [[self heartlinesTimeLabel] setFont:[UIFont systemFontOfSize:[customTimeFontSizeValue intValue] weight:UIFontWeightRegular]];
            }
        } else {
            if (!useCustomTimeFontSizeSwitch) {
                [[self heartlinesTimeLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:61]];
            } else {
                [[self heartlinesTimeLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customTimeFontSizeValue intValue]]];
            }
        }
            
        NSDateFormatter* timeFormat = [NSDateFormatter new];
        [timeFormat setDateFormat:timeFormatValue];
        [[self heartlinesTimeLabel] setText:[timeFormat stringFromDate:[NSDate date]]];
            
        if ([positionValue intValue] == 0) [[self heartlinesTimeLabel] setTextAlignment:NSTextAlignmentLeft];
        else if ([positionValue intValue] == 1) [[self heartlinesTimeLabel] setTextAlignment:NSTextAlignmentCenter];
        else if ([positionValue intValue] == 2) [[self heartlinesTimeLabel] setTextAlignment:NSTextAlignmentRight];
            

        [[self heartlinesTimeLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self heartlinesTimeLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
        [[self heartlinesTimeLabel].heightAnchor constraintEqualToConstant:73].active = YES;
            
        if (![[self heartlinesTimeLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesTimeLabel]];
            
        if ([positionValue intValue] == 0) [[self heartlinesTimeLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:4].active = YES;
        else if ([positionValue intValue] == 1) [[self heartlinesTimeLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
        else if ([positionValue intValue] == 2) [[self heartlinesTimeLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-4].active = YES;
            
        [[self heartlinesTimeLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesDateLabel].bottomAnchor constant:32].active = YES;


        // up next label
        if (showUpNextSwitch) {
            self.heartlinesUpNextLabel = [UILabel new];
            
            if (!useCustomFontSwitch){
                if (!useCustomUpNextFontSizeSwitch) {
                    [[self heartlinesUpNextLabel] setFont:[UIFont systemFontOfSize:19 weight:UIFontWeightSemibold]];
                } else {
                    [[self heartlinesUpNextLabel] setFont:[UIFont systemFontOfSize:[customUpNextFontSizeValue intValue] weight:UIFontWeightSemibold]];
                }
            } else {
                if (!useCustomUpNextFontSizeSwitch) {
                    [[self heartlinesUpNextLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:19]];
                } else {
                    [[self heartlinesUpNextLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customUpNextFontSizeValue intValue]]];
                }
            }
            
            if ([[HLSLocalization stringForKey:@"UP_NEXT"] isEqual:nil]) [[self heartlinesUpNextLabel] setText:@"Up next"];
            else if (![[HLSLocalization stringForKey:@"UP_NEXT"] isEqual:nil]) [[self heartlinesUpNextLabel] setText:[NSString stringWithFormat:@"%@", [HLSLocalization stringForKey:@"UP_NEXT"]]];
            
            if ([positionValue intValue] == 0) [[self heartlinesUpNextLabel] setTextAlignment:NSTextAlignmentLeft];
            else if ([positionValue intValue] == 1) [[self heartlinesUpNextLabel] setTextAlignment:NSTextAlignmentCenter];
            else if ([positionValue intValue] == 2) [[self heartlinesUpNextLabel] setTextAlignment:NSTextAlignmentRight];


            [[self heartlinesUpNextLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesUpNextLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
            [[self heartlinesUpNextLabel].heightAnchor constraintEqualToConstant:21].active = YES;
            
            if (![[self heartlinesUpNextLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesUpNextLabel]];
            
            if ([positionValue intValue] == 0) [[self heartlinesUpNextLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
            else if ([positionValue intValue] == 1) [[self heartlinesUpNextLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            else if ([positionValue intValue] == 2) [[self heartlinesUpNextLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
            
            [[self heartlinesUpNextLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesTimeLabel].bottomAnchor constant:8].active = YES;
        }

        // up next event label
        if (showUpNextSwitch) {
            self.heartlinesUpNextEventLabel = [UILabel new];
            
            if (!useCustomFontSwitch){
                if (!useCustomUpNextEventFontSizeSwitch) {
                    [[self heartlinesUpNextEventLabel] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
                } else {
                    [[self heartlinesUpNextEventLabel] setFont:[UIFont systemFontOfSize:[customUpNextEventFontSizeValue intValue] weight:UIFontWeightSemibold]];
                }
            } else {
                if (!useCustomUpNextEventFontSizeSwitch) {
                    [[self heartlinesUpNextEventLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:15]];
                } else {
                    [[self heartlinesUpNextEventLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customUpNextEventFontSizeValue intValue]]];
                }
            }
            
            if ([[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:@"No upcoming events"];
            else if (![[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:[NSString stringWithFormat:@"%@", [HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"]]];
            
            if ([positionValue intValue] == 0) [[self heartlinesUpNextEventLabel] setTextAlignment:NSTextAlignmentLeft];
            else if ([positionValue intValue] == 1) [[self heartlinesUpNextEventLabel] setTextAlignment:NSTextAlignmentCenter];
            else if ([positionValue intValue] == 2) [[self heartlinesUpNextEventLabel] setTextAlignment:NSTextAlignmentRight];
            

            [[self heartlinesUpNextEventLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesUpNextEventLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
            [[self heartlinesUpNextEventLabel].heightAnchor constraintEqualToConstant:16].active = YES;
            
            if (![[self heartlinesUpNextEventLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesUpNextEventLabel]];
            
            if ([positionValue intValue] == 0) [[self heartlinesUpNextEventLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
            else if ([positionValue intValue] == 1) [[self heartlinesUpNextEventLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            else if ([positionValue intValue] == 2) [[self heartlinesUpNextEventLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
            
            [[self heartlinesUpNextEventLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesUpNextLabel].bottomAnchor constant:14].active = YES;
        }

        // invisible ink
        if (showUpNextSwitch && hideUntilAuthenticatedSwitch && invisibleInkEffectSwitch) {
            self.heartlinesInvisibleInk = [NSClassFromString(@"CKheartlinesInvisibleInkImageEffectView") new];
            [[self heartlinesInvisibleInk] setHidden:YES];

            [[self heartlinesInvisibleInk] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesInvisibleInk].widthAnchor constraintEqualToConstant:160].active = YES;
            [[self heartlinesInvisibleInk].heightAnchor constraintEqualToConstant:21].active = YES;
            if (![[self heartlinesInvisibleInk] isDescendantOfView:self]) [self addSubview:[self heartlinesInvisibleInk]];
            if ([positionValue intValue] == 0) [[self heartlinesInvisibleInk].centerXAnchor constraintEqualToAnchor:self.leftAnchor constant:87.5].active = YES;
            else if ([positionValue intValue] == 1) [[self heartlinesInvisibleInk].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            else if ([positionValue intValue] == 2) [[self heartlinesInvisibleInk].centerXAnchor constraintEqualToAnchor:self.rightAnchor constant:-75].active = YES;
            [[self heartlinesInvisibleInk].centerYAnchor constraintEqualToAnchor:[self heartlinesUpNextLabel].bottomAnchor constant:16].active = YES;
        }
    } else if ([styleValue intValue] == 2) {
        // time label
        self.heartlinesTimeLabel = [UILabel new];
            
        if (!useCustomFontSwitch){
            if (!useCustomTimeFontSizeSwitch) {
                [[self heartlinesTimeLabel] setFont:[UIFont systemFontOfSize:61 weight:UIFontWeightRegular]];
            } else {
                [[self heartlinesTimeLabel] setFont:[UIFont systemFontOfSize:[customTimeFontSizeValue intValue] weight:UIFontWeightRegular]];
            }
        } else {
            if (!useCustomTimeFontSizeSwitch) {
                [[self heartlinesTimeLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:61]];
            } else {
                [[self heartlinesTimeLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customTimeFontSizeValue intValue]]];
            }
        }
            
        NSDateFormatter* timeFormat = [NSDateFormatter new];
        [timeFormat setDateFormat:timeFormatValue];
        [[self heartlinesTimeLabel] setText:[timeFormat stringFromDate:[NSDate date]]];
            
        [[self heartlinesTimeLabel] setTextAlignment:NSTextAlignmentLeft];
            

        [[self heartlinesTimeLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self heartlinesTimeLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
        [[self heartlinesTimeLabel].heightAnchor constraintEqualToConstant:73].active = YES;
            
        if (![[self heartlinesTimeLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesTimeLabel]];
            
        [[self heartlinesTimeLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:4].active = YES;
        [[self heartlinesTimeLabel].centerYAnchor constraintEqualToAnchor:self.topAnchor constant:50].active = YES;


        // date label
        self.heartlinesDateLabel = [UILabel new];
            
        if (!useCustomFontSwitch){
            if (!useCustomDateFontSizeSwitch) {
                [[self heartlinesDateLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
            } else {
                [[self heartlinesDateLabel] setFont:[UIFont systemFontOfSize:[customDateFontSizeValue intValue] weight:UIFontWeightSemibold]];
            }
        } else {
            if (!useCustomDateFontSizeSwitch) {
                [[self heartlinesDateLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:17]];
            } else {
                [[self heartlinesDateLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customDateFontSizeValue intValue]]];
            }
        }
            
        if (!isTimerRunning) {
            NSDateFormatter* dateFormat = [NSDateFormatter new];
            [dateFormat setDateFormat:dateFormatValue];
            [[self heartlinesDateLabel] setText:[[dateFormat stringFromDate:[NSDate date]] capitalizedString]];
        }
            
        [[self heartlinesDateLabel] setTextAlignment:NSTextAlignmentLeft];
            

        [[self heartlinesDateLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self heartlinesDateLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
        [[self heartlinesDateLabel].heightAnchor constraintEqualToConstant:21].active = YES;
            
        if (![[self heartlinesDateLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesDateLabel]];
            
        [[self heartlinesDateLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:8].active = YES;
        [[self heartlinesDateLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesTimeLabel].bottomAnchor constant:8].active = YES;


        // weather report label
        if (showWeatherSwitch) {
            self.heartlinesWeatherReportLabel = [UILabel new];
            
            if (!useCustomFontSwitch){
                if (!useCustomWeatherReportFontSizeSwitch) {
                    [[self heartlinesWeatherReportLabel] setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]];
                } else {
                    [[self heartlinesWeatherReportLabel] setFont:[UIFont systemFontOfSize:[customWeatherReportFontSizeValue intValue] weight:UIFontWeightSemibold]];
                }
            } else {
                if (!useCustomWeatherReportFontSizeSwitch) {
                    [[self heartlinesWeatherReportLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:14]];
                } else {
                    [[self heartlinesWeatherReportLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customWeatherReportFontSizeValue intValue]]];
                }
            }
            
            [[PDDokdo sharedInstance] refreshWeatherData];
            if ([[HLSLocalization stringForKey:@"ITS"] isEqual:nil]) [[self heartlinesWeatherReportLabel] setText:[NSString stringWithFormat:@"It's %@", [[PDDokdo sharedInstance] currentTemperature]]];
            else if (![[HLSLocalization stringForKey:@"ITS"] isEqual:nil]) [[self heartlinesWeatherReportLabel] setText:[NSString stringWithFormat:@"%@ %@", [HLSLocalization stringForKey:@"ITS"], [[PDDokdo sharedInstance] currentTemperature]]];
            
            [[self heartlinesWeatherReportLabel] setTextAlignment:NSTextAlignmentRight];


            [[self heartlinesWeatherReportLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesWeatherReportLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
            [[self heartlinesWeatherReportLabel].heightAnchor constraintEqualToConstant:21].active = YES;
            
            if (![[self heartlinesWeatherReportLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesWeatherReportLabel]];
            
            [[self heartlinesWeatherReportLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
            [[self heartlinesWeatherReportLabel].centerYAnchor constraintEqualToAnchor:self.topAnchor constant:55].active = YES;
        }

        // weather condition label
        if (showWeatherSwitch) {
            self.heartlinesWeatherConditionLabel = [UILabel new];
            
            if (!useCustomFontSwitch){
                if (!useCustomWeatherConditionFontSizeSwitch) {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]];
                } else {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont systemFontOfSize:[customWeatherConditionFontSizeValue intValue] weight:UIFontWeightSemibold]];
                }
            } else {
                if (!useCustomWeatherConditionFontSizeSwitch) {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:14]];
                } else {
                    [[self heartlinesWeatherConditionLabel] setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", [preferences objectForKey:@"customFont"]] size:[customWeatherConditionFontSizeValue intValue]]];
                }
            }
            
            [[self heartlinesWeatherConditionLabel] setText:[NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentConditions]]];
            [[self heartlinesWeatherConditionLabel] setTextAlignment:NSTextAlignmentRight];

            
            [[self heartlinesWeatherConditionLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self heartlinesWeatherConditionLabel].widthAnchor constraintEqualToConstant:self.bounds.size.width].active = YES;
            [[self heartlinesWeatherConditionLabel].heightAnchor constraintEqualToConstant:21].active = YES;
            
            if (![[self heartlinesWeatherConditionLabel] isDescendantOfView:self]) [self addSubview:[self heartlinesWeatherConditionLabel]];
            
            [[self heartlinesWeatherConditionLabel].centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
            [[self heartlinesWeatherConditionLabel].centerYAnchor constraintEqualToAnchor:[self heartlinesWeatherReportLabel].bottomAnchor constant:8].active = YES;
        }
    }

    // get lockscreen wallpaper
    NSData* lockWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"];
    CFDataRef lockWallpaperDataRef = (__bridge CFDataRef)lockWallpaperData;
    CFArrayRef imageArray = CPBitmapCreateImagesFromData(lockWallpaperDataRef, NULL, 1, NULL);
    UIImage* wallpaper = [UIImage imageWithCGImage:(CGImageRef)CFArrayGetValueAtIndex(imageArray, 0)];
    CFRelease(imageArray);

    // get lockscreen wallpaper based colors
    backgroundWallpaperColor = [libKitten backgroundColor:wallpaper];
    primaryWallpaperColor = [libKitten primaryColor:wallpaper];
    secondaryWallpaperColor = [libKitten secondaryColor:wallpaper];

    // set colors
    if ([faceIDLockColorValue intValue] == 0)
        [faceIDLock setContentColor:backgroundWallpaperColor];
    else if ([faceIDLockColorValue intValue] == 1)
        [faceIDLock setContentColor:primaryWallpaperColor];
    else if ([faceIDLockColorValue intValue] == 2)
        [faceIDLock setContentColor:secondaryWallpaperColor];
    else if ([faceIDLockColorValue intValue] == 3)
        [faceIDLock setContentColor:[GcColorPickerUtils colorWithHex:customFaceIDLockColorValue]];

    if (showUpNextSwitch) {
        if ([upNextColorValue intValue] == 0)
            [[self heartlinesUpNextLabel] setTextColor:backgroundWallpaperColor];
        else if ([upNextColorValue intValue] == 1)
            [[self heartlinesUpNextLabel] setTextColor:primaryWallpaperColor];
        else if ([upNextColorValue intValue] == 2)
            [[self heartlinesUpNextLabel] setTextColor:secondaryWallpaperColor];
        else if ([upNextColorValue intValue] == 3)
            [[self heartlinesUpNextLabel] setTextColor:[GcColorPickerUtils colorWithHex:customUpNextColorValue]];

        if ([upNextEventColorValue intValue] == 0)
            [[self heartlinesUpNextEventLabel] setTextColor:backgroundWallpaperColor];
        else if ([upNextEventColorValue intValue] == 1)
            [[self heartlinesUpNextEventLabel] setTextColor:primaryWallpaperColor];
        else if ([upNextEventColorValue intValue] == 2)
            [[self heartlinesUpNextEventLabel] setTextColor:secondaryWallpaperColor];
        else if ([upNextEventColorValue intValue] == 3)
            [[self heartlinesUpNextEventLabel] setTextColor:[GcColorPickerUtils colorWithHex:customUpNextEventColorValue]];
    }

    if ([timeColorValue intValue] == 0)
        [[self heartlinesTimeLabel] setTextColor:backgroundWallpaperColor];
    else if ([timeColorValue intValue] == 1)
        [[self heartlinesTimeLabel] setTextColor:primaryWallpaperColor];
    else if ([timeColorValue intValue] == 2)
        [[self heartlinesTimeLabel] setTextColor:secondaryWallpaperColor];
    else if ([timeColorValue intValue] == 3)
        [[self heartlinesTimeLabel] setTextColor:[GcColorPickerUtils colorWithHex:customTimeColorValue]];

    if ([dateColorValue intValue] == 0)
        [[self heartlinesDateLabel] setTextColor:backgroundWallpaperColor];
    else if ([dateColorValue intValue] == 1)
        [[self heartlinesDateLabel] setTextColor:primaryWallpaperColor];
    else if ([dateColorValue intValue] == 2)
        [[self heartlinesDateLabel] setTextColor:secondaryWallpaperColor];
    else if ([dateColorValue intValue] == 3)
        [[self heartlinesDateLabel] setTextColor:[GcColorPickerUtils colorWithHex:customDateColorValue]];

    if (showWeatherSwitch) {
        if ([weatherReportColorValue intValue] == 0)
            [[self heartlinesWeatherReportLabel] setTextColor:backgroundWallpaperColor];
        else if ([weatherReportColorValue intValue] == 1)
            [[self heartlinesWeatherReportLabel] setTextColor:primaryWallpaperColor];
        else if ([weatherReportColorValue intValue] == 2)
            [[self heartlinesWeatherReportLabel] setTextColor:secondaryWallpaperColor];
        else if ([weatherReportColorValue intValue] == 3)
            [[self heartlinesWeatherReportLabel] setTextColor:[GcColorPickerUtils colorWithHex:customWeatherReportColorValue]];

        if ([weatherConditionColorValue intValue] == 0)
            [[self heartlinesWeatherConditionLabel] setTextColor:backgroundWallpaperColor];
        else if ([weatherConditionColorValue intValue] == 1)
            [[self heartlinesWeatherConditionLabel] setTextColor:primaryWallpaperColor];
        else if ([weatherConditionColorValue intValue] == 2)
            [[self heartlinesWeatherConditionLabel] setTextColor:secondaryWallpaperColor];
        else if ([weatherConditionColorValue intValue] == 3)
            [[self heartlinesWeatherConditionLabel] setTextColor:[GcColorPickerUtils colorWithHex:customWeatherConditionColorValue]];
    }

}

%new
- (void)updateHeartlinesTimeAndDate { // update diary

    if (!justPluggedIn) {
        NSDateFormatter* timeFormat = [NSDateFormatter new];
        [timeFormat setDateFormat:timeFormatValue];
        [[self heartlinesTimeLabel] setText:[timeFormat stringFromDate:[NSDate date]]];
    }

	if (!isTimerRunning) {
        NSDateFormatter* dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:dateFormatValue];
        if (useCustomDateLocaleSwitch) [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:customDateLocaleValue]];
        [[self heartlinesDateLabel] setText:[dateFormat stringFromDate:[NSDate date]]];
    }

    if (showWeatherSwitch) {
        if ([styleValue intValue] == 0) {
            if ([[HLSLocalization stringForKey:@"CURRENTLY_ITS"] isEqual:nil]) [[self heartlinesWeatherReportLabel] setText:[NSString stringWithFormat:@"Currently it's %@", [[PDDokdo sharedInstance] currentTemperature]]];
            else if (![[HLSLocalization stringForKey:@"CURRENTLY_ITS"] isEqual:nil]) [[self heartlinesWeatherReportLabel] setText:[NSString stringWithFormat:@"%@ %@", [HLSLocalization stringForKey:@"CURRENTLY_ITS"], [[PDDokdo sharedInstance] currentTemperature]]];
            
            [[self heartlinesWeatherConditionLabel] setText:[NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentConditions]]];
        } else if ([styleValue intValue] == 1) {
            [[self heartlinesWeatherConditionLabel] setText:[NSString stringWithFormat:@"%@, %@",[[PDDokdo sharedInstance] currentConditions], [[PDDokdo sharedInstance] currentTemperature]]];
        } else if ([styleValue intValue] == 2) {
            if ([[HLSLocalization stringForKey:@"ITS"] isEqual:nil]) [[self heartlinesWeatherReportLabel] setText:[NSString stringWithFormat:@"It's %@", [[PDDokdo sharedInstance] currentTemperature]]];
            else if (![[HLSLocalization stringForKey:@"ITS"] isEqual:nil]) [[self heartlinesWeatherReportLabel] setText:[NSString stringWithFormat:@"%@ %@", [HLSLocalization stringForKey:@"ITS"], [[PDDokdo sharedInstance] currentTemperature]]];
            
            [[self heartlinesWeatherConditionLabel] setText:[NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentConditions]]];
        }
    }
    
}

%new
- (void)updateHeartlinesUpNext { // update up next

    EKEventStore* store = [EKEventStore new];
    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* todayEventsComponents = [NSDateComponents new];
    todayEventsComponents.day = 0;
    NSDate* todayEvents = [calendar dateByAddingComponents:todayEventsComponents toDate:[NSDate date] options:0];

    NSDateComponents* todayRemindersComponents = [NSDateComponents new];
    todayRemindersComponents.day = -1;
    NSDate* todayReminders = [calendar dateByAddingComponents:todayRemindersComponents toDate:[NSDate date] options:0];

    NSDateComponents* daysFromNowComponents = [NSDateComponents new];
    daysFromNowComponents.day = [dayRangeValue intValue];
    NSDate* daysFromNow = [calendar dateByAddingComponents:daysFromNowComponents toDate:[NSDate date] options:0];

    NSPredicate* calendarPredicate = [store predicateForEventsWithStartDate:todayEvents endDate:daysFromNow calendars:nil];

    NSArray* events = [store eventsMatchingPredicate:calendarPredicate];

    NSPredicate* reminderPredicate = [store predicateForIncompleteRemindersWithDueDateStarting:todayReminders ending:daysFromNow calendars:nil];
    __block NSArray* availableReminders;

    // get first event
    if (showCalendarEventsSwitch) {
        if ([events count]) {
            [[self heartlinesUpNextEventLabel] setText:[NSString stringWithFormat:@"%@", [events[0] title]]];
            if (!(hideUntilAuthenticatedSwitch && isLocked)) [[self heartlinesUpNextEventLabel] setHidden:NO];
        } else {
            if ([[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:@"No upcoming events"];
            else if (![[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:[NSString stringWithFormat:@"%@", [HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"]]];
        }
    }

    // get first reminder and manage no events status
    if (showRemindersSwitch) {
        if ((prioritizeRemindersSwitch && [events count]) || ![events count]) {
            [store fetchRemindersMatchingPredicate:reminderPredicate completion:^(NSArray* reminders) {
                availableReminders = reminders;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([reminders count]) {
                        [[self heartlinesUpNextEventLabel] setText:[NSString stringWithFormat:@"%@", [reminders[0] title]]];
                        if (!(hideUntilAuthenticatedSwitch && isLocked)) [[self heartlinesUpNextEventLabel] setHidden:NO];
                    } else if (![reminders count] && ![events count]) {
                        if ([[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:@"No upcoming events"];
                        else if (![[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:[NSString stringWithFormat:@"%@", [HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"]]];
                    }
                });
            }];
        }
    }

    // get next alarm
    if (showNextAlarmSwitch) {
        if ((prioritizeAlarmsSwitch && ([events count] || [availableReminders count])) || (![events count] && ![availableReminders count])) {
            if ([[[[%c(SBScheduledAlarmObserver) sharedInstance] valueForKey:@"_alarmManager"] cache] nextAlarm]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSDate* fireDate = [[[[[%c(SBScheduledAlarmObserver) sharedInstance] valueForKey:@"_alarmManager"] cache] nextAlarm] nextFireDate];
                    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:fireDate];
                    if ([[HLSLocalization stringForKey:@"ALARM"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:[NSString stringWithFormat:@"Alarm: %02ld:%02ld", [components hour], [components minute]]];
                    else if (![[HLSLocalization stringForKey:@"ALARM"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:[NSString stringWithFormat:@"%@: %02ld:%02ld", [HLSLocalization stringForKey:@"ALARM"], [components hour], [components minute]]];
                    if (!(hideUntilAuthenticatedSwitch && isLocked)) [[self heartlinesUpNextEventLabel] setHidden:NO];
                });
            } else {
                if ([[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:@"No upcoming events"];
                else if (![[HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"] isEqual:nil]) [[self heartlinesUpNextEventLabel] setText:[NSString stringWithFormat:@"%@", [HLSLocalization stringForKey:@"NO_UPCOMING_EVENTS"]]];
            }
            
        }
    }

}

%end

%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated { // update heartlines when lockscreen appears

	%orig;

    if (showWeatherSwitch) [[PDDokdo sharedInstance] refreshWeatherData];
    if (showUpNextSwitch && [styleValue intValue] != 2) [timeDateView updateHeartlinesUpNext];
	[self requestHeartlinesTimeAndDateUpdate];

	if (!timeAndDateTimer) timeAndDateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(requestHeartlinesTimeAndDateUpdate) userInfo:nil repeats:YES];

}

- (void)viewWillDisappear:(BOOL)animated { // stop timer when lockscreen disappears

	%orig;

	[timeAndDateTimer invalidate];
	timeAndDateTimer = nil;

}


%new
- (void)requestHeartlinesTimeAndDateUpdate { // update heartlines

    [timeDateView updateHeartlinesTimeAndDate];
    
}

%end

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 { // stop timer when device was locked

	%orig;

	[timeAndDateTimer invalidate];
	timeAndDateTimer = nil;
    isScreenOn = NO;

}

%end

%hook SBBacklightController

- (void)turnOnScreenFullyWithBacklightSource:(long long)arg1 { // update heartlines when screen turns on

	%orig;

    if (![[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible] || isScreenOn) return; // this method gets called not only when the screen gets turned on, so i verify that it was turned on by checking if the lock screen is visible
    [self requestHeartlinesTimeAndDateUpdate];
    if (showWeatherSwitch) [[PDDokdo sharedInstance] refreshWeatherData];
    if (showUpNextSwitch && [styleValue intValue] != 2) [timeDateView updateHeartlinesUpNext];
	if (!timeAndDateTimer) timeAndDateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(requestHeartlinesTimeAndDateUpdate) userInfo:nil repeats:YES];
    isScreenOn = YES;

}

%new
- (void)requestHeartlinesTimeAndDateUpdate { // update heartlines

    [timeDateView updateHeartlinesTimeAndDate];
    
}

%end

%hook SBFLockScreenDateSubtitleView

- (void)setString:(NSString *)arg1 { // apply running timer to the date label

    %orig;

    if ([arg1 containsString:@":"]) {
        isTimerRunning = YES;
        [[timeDateView heartlinesDateLabel] setText:arg1];
    } else {
        isTimerRunning = NO;
    }

}

%end

%hook CSCombinedListViewController

- (double)_minInsetsToPushDateOffScreen { // adjust notification list position depending on style

    if ([styleValue intValue] == 0) {
        if (showUpNextSwitch && showWeatherSwitch) {
            double orig = %orig;
            return orig + 65;
        } else if (!showUpNextSwitch && showWeatherSwitch) {
            double orig = %orig;
            return orig + 15;
        } else if (showUpNextSwitch && !showWeatherSwitch) {
            double orig = %orig;
            return orig + 20;
        } else if (!showUpNextSwitch && !showWeatherSwitch) {
            return %orig;
        } else {
            return %orig;
        }
    } else if ([styleValue intValue] == 1) {
        if (showUpNextSwitch && showWeatherSwitch) {
            double orig = %orig;
            return orig + 30;
        } else if (!showUpNextSwitch && showWeatherSwitch) {
            return %orig;
        } else if (showUpNextSwitch && !showWeatherSwitch) {
            double orig = %orig;
            return orig + 10;
        } else if (!showUpNextSwitch && !showWeatherSwitch) {
            return %orig;
        } else {
            return %orig;
        }
    } else if ([styleValue intValue] == 2) {
        double orig = %orig;
        return orig - 15;
    } else {
        return %orig;
    }

}

- (UIEdgeInsets)_listViewDefaultContentInsets { // adjust notification list position depending on style

    if ([styleValue intValue] == 0) {
        if (showUpNextSwitch && showWeatherSwitch) {
            UIEdgeInsets originalInsets = %orig;
            originalInsets.top += 65;
            return originalInsets;
        } else if (!showUpNextSwitch && showWeatherSwitch) {
            UIEdgeInsets originalInsets = %orig;
            originalInsets.top += 15;
            return originalInsets;
        } else if (showUpNextSwitch && !showWeatherSwitch) {
            UIEdgeInsets originalInsets = %orig;
            originalInsets.top += 20;
            return originalInsets;
        } else if (!showUpNextSwitch && !showWeatherSwitch) {
            return %orig;
        } else {
            return %orig;
        }
    } else if ([styleValue intValue] == 1) {
        if (showUpNextSwitch && showWeatherSwitch) {
            UIEdgeInsets originalInsets = %orig;
            originalInsets.top += 30;
            return originalInsets;
        } else if (!showUpNextSwitch && showWeatherSwitch) {
            return %orig;
        } else if (showUpNextSwitch && !showWeatherSwitch) {
            UIEdgeInsets originalInsets = %orig;
            originalInsets.top += 10;
            return originalInsets;
        } else if (!showUpNextSwitch && !showWeatherSwitch) {
            return %orig;
        } else {
            return %orig;
        }
    } else if ([styleValue intValue] == 2) {
        UIEdgeInsets originalInsets = %orig;
        originalInsets.top -= 15;
        return originalInsets;
    } else {
        return %orig;
    }

}

%end

%hook SBUIController

- (void)ACPowerChanged { // display battery percentage in the time label when plugged in

	%orig;

	if ([self isOnAC]) {
        justPluggedIn = YES;
        [UIView transitionWithView:[timeDateView heartlinesTimeLabel] duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[[timeDateView heartlinesTimeLabel] setText:[NSString stringWithFormat:@"%d%%", [self batteryCapacityAsPercentage]]];
		} completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [UIView transitionWithView:[timeDateView heartlinesTimeLabel] duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    NSDateFormatter* timeFormat = [NSDateFormatter new];
                    [timeFormat setDateFormat:timeFormatValue];
                    [[timeDateView heartlinesTimeLabel] setText:[timeFormat stringFromDate:[NSDate date]]];
                } completion:nil];
                justPluggedIn = NO;
            });
        }];
    }

}

%end

%hook CSCoverSheetViewController

- (void)_transitionChargingViewToVisible:(BOOL)arg1 showBattery:(BOOL)arg2 animated:(BOOL)arg3 { // hide charging view

    if (magsafeCompatibilitySwitch)
        %orig;
	else
        %orig(NO, NO, NO);

}

%end

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 completion:(id)arg3 { // unhide invisible ink and hide up next when authenticated

    %orig;

    if (!hideUntilAuthenticatedSwitch) return;
    isLocked = YES;
    [UIView transitionWithView:[timeDateView heartlinesUpNextEventLabel] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [[timeDateView heartlinesUpNextEventLabel] setHidden:YES];
    } completion:nil];
    [UIView transitionWithView:[timeDateView heartlinesInvisibleInk] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        if (invisibleInkEffectSwitch) [[timeDateView heartlinesInvisibleInk] setHidden:NO];
    } completion:nil];

}

%end

%hook SBDashBoardLockScreenEnvironment

- (void)setAuthenticated:(BOOL)arg1 { // hide invisible ink and unhide up next when authenticated

	%orig;

    if (!hideUntilAuthenticatedSwitch) return;
	if (arg1) {
        isLocked = NO;
        [UIView transitionWithView:[timeDateView heartlinesUpNextEventLabel] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [[timeDateView heartlinesUpNextEventLabel] setHidden:NO];
        } completion:nil];
        [UIView transitionWithView:[timeDateView heartlinesInvisibleInk] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            if (invisibleInkEffectSwitch) [[timeDateView heartlinesInvisibleInk] setHidden:YES];
        } completion:nil];
    }

}

%end

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // get artwork colors

    %orig;
    if (!artworkBasedColorsSwitch) return;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;

            currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];

            if (dict) {
                if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
                    if (![lastArtworkData isEqual:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]) {
                        // get artwork colors
                        backgroundArtworkColor = [libKitten backgroundColor:currentArtwork];
                        primaryArtworkColor = [libKitten primaryColor:currentArtwork];
                        secondaryArtworkColor = [libKitten secondaryColor:currentArtwork];

                        // set artwork colors
                        if ([faceIDLockArtworkColorValue intValue] == 0)
                            [faceIDLock setContentColor:backgroundArtworkColor];
                        else if ([faceIDLockArtworkColorValue intValue] == 1)
                            [faceIDLock setContentColor:primaryArtworkColor];
                        else if ([faceIDLockArtworkColorValue intValue] == 2)
                            [faceIDLock setContentColor:secondaryArtworkColor];

                        if (showUpNextSwitch) {
                            if ([upNextArtworkColorValue intValue] == 0)
                                [[timeDateView heartlinesUpNextLabel] setTextColor:backgroundArtworkColor];
                            else if ([upNextArtworkColorValue intValue] == 1)
                                [[timeDateView heartlinesUpNextLabel] setTextColor:primaryArtworkColor];
                            else if ([upNextArtworkColorValue intValue] == 2)
                                [[timeDateView heartlinesUpNextLabel] setTextColor:secondaryArtworkColor];

                            if ([upNextEventArtworkColorValue intValue] == 0)
                                [[timeDateView heartlinesUpNextEventLabel] setTextColor:backgroundArtworkColor];
                            else if ([upNextEventArtworkColorValue intValue] == 1)
                                [[timeDateView heartlinesUpNextEventLabel] setTextColor:primaryArtworkColor];
                            else if ([upNextEventArtworkColorValue intValue] == 2)
                                [[timeDateView heartlinesUpNextEventLabel] setTextColor:secondaryArtworkColor];
                        }

                        if ([timeArtworkColorValue intValue] == 0)
                            [[timeDateView heartlinesTimeLabel] setTextColor:backgroundArtworkColor];
                        else if ([timeArtworkColorValue intValue] == 1)
                            [[timeDateView heartlinesTimeLabel] setTextColor:primaryArtworkColor];
                        else if ([timeArtworkColorValue intValue] == 2)
                            [[timeDateView heartlinesTimeLabel] setTextColor:secondaryArtworkColor];

                        if ([dateArtworkColorValue intValue] == 0)
                            [[timeDateView heartlinesDateLabel] setTextColor:backgroundArtworkColor];
                        else if ([dateArtworkColorValue intValue] == 1)
                            [[timeDateView heartlinesDateLabel] setTextColor:primaryArtworkColor];
                        else if ([dateArtworkColorValue intValue] == 2)
                            [[timeDateView heartlinesDateLabel] setTextColor:secondaryArtworkColor];

                        if (showWeatherSwitch) {
                            if ([weatherReportArtworkColorValue intValue] == 0)
                                [[timeDateView heartlinesWeatherReportLabel] setTextColor:backgroundArtworkColor];
                            else if ([weatherReportArtworkColorValue intValue] == 1)
                                [[timeDateView heartlinesWeatherReportLabel] setTextColor:primaryArtworkColor];
                            else if ([weatherReportArtworkColorValue intValue] == 2)
                                [[timeDateView heartlinesWeatherReportLabel] setTextColor:secondaryArtworkColor];

                            if ([weatherConditionArtworkColorValue intValue] == 0)
                                [[timeDateView heartlinesWeatherConditionLabel] setTextColor:backgroundArtworkColor];
                            else if ([weatherConditionArtworkColorValue intValue] == 1)
                                [[timeDateView heartlinesWeatherConditionLabel] setTextColor:primaryArtworkColor];
                            else if ([weatherConditionArtworkColorValue intValue] == 2)
                                [[timeDateView heartlinesWeatherConditionLabel] setTextColor:secondaryArtworkColor];
                        }

                    }

                    lastArtworkData = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData];
                }
            }
        } else { // reset colors when nothing is playing
            if ([faceIDLockColorValue intValue] == 0)
                [faceIDLock setContentColor:backgroundWallpaperColor];
            else if ([faceIDLockColorValue intValue] == 1)
                [faceIDLock setContentColor:primaryWallpaperColor];
            else if ([faceIDLockColorValue intValue] == 2)
                [faceIDLock setContentColor:secondaryWallpaperColor];
            else if ([faceIDLockColorValue intValue] == 3)
                [faceIDLock setContentColor:[GcColorPickerUtils colorWithHex:customFaceIDLockColorValue]];

            if (showUpNextSwitch) {
                if ([upNextColorValue intValue] == 0)
                    [[timeDateView heartlinesUpNextLabel] setTextColor:backgroundWallpaperColor];
                else if ([upNextColorValue intValue] == 1)
                    [[timeDateView heartlinesUpNextLabel] setTextColor:primaryWallpaperColor];
                else if ([upNextColorValue intValue] == 2)
                    [[timeDateView heartlinesUpNextLabel] setTextColor:secondaryWallpaperColor];
                else if ([upNextColorValue intValue] == 3)
                    [[timeDateView heartlinesUpNextLabel] setTextColor:[GcColorPickerUtils colorWithHex:customUpNextColorValue]];

                if ([upNextEventColorValue intValue] == 0)
                    [[timeDateView heartlinesUpNextEventLabel] setTextColor:backgroundWallpaperColor];
                else if ([upNextEventColorValue intValue] == 1)
                    [[timeDateView heartlinesUpNextEventLabel] setTextColor:primaryWallpaperColor];
                else if ([upNextEventColorValue intValue] == 2)
                    [[timeDateView heartlinesUpNextEventLabel] setTextColor:secondaryWallpaperColor];
                else if ([upNextEventColorValue intValue] == 3)
                    [[timeDateView heartlinesUpNextEventLabel] setTextColor:[GcColorPickerUtils colorWithHex:customUpNextEventColorValue]];
            }

            if ([timeColorValue intValue] == 0)
                [[timeDateView heartlinesTimeLabel] setTextColor:backgroundWallpaperColor];
            else if ([timeColorValue intValue] == 1)
                [[timeDateView heartlinesTimeLabel] setTextColor:primaryWallpaperColor];
            else if ([timeColorValue intValue] == 2)
                [[timeDateView heartlinesTimeLabel] setTextColor:secondaryWallpaperColor];
            else if ([timeColorValue intValue] == 3)
                [[timeDateView heartlinesTimeLabel] setTextColor:[GcColorPickerUtils colorWithHex:customTimeColorValue]];

            if ([dateColorValue intValue] == 0)
                [[timeDateView heartlinesDateLabel] setTextColor:backgroundWallpaperColor];
            else if ([dateColorValue intValue] == 1)
                [[timeDateView heartlinesDateLabel] setTextColor:primaryWallpaperColor];
            else if ([dateColorValue intValue] == 2)
                [[timeDateView heartlinesDateLabel] setTextColor:secondaryWallpaperColor];
            else if ([dateColorValue intValue] == 3)
                [[timeDateView heartlinesDateLabel] setTextColor:[GcColorPickerUtils colorWithHex:customDateColorValue]];

            if (showWeatherSwitch) {
                if ([weatherReportColorValue intValue] == 0)
                    [[timeDateView heartlinesWeatherReportLabel] setTextColor:backgroundWallpaperColor];
                else if ([weatherReportColorValue intValue] == 1)
                    [[timeDateView heartlinesWeatherReportLabel] setTextColor:primaryWallpaperColor];
                else if ([weatherReportColorValue intValue] == 2)
                    [[timeDateView heartlinesWeatherReportLabel] setTextColor:secondaryWallpaperColor];
                else if ([weatherReportColorValue intValue] == 3)
                    [[timeDateView heartlinesWeatherReportLabel] setTextColor:[GcColorPickerUtils colorWithHex:customWeatherReportColorValue]];

                if ([weatherConditionColorValue intValue] == 0)
                    [[timeDateView heartlinesWeatherConditionLabel] setTextColor:backgroundWallpaperColor];
                else if ([weatherConditionColorValue intValue] == 1)
                    [[timeDateView heartlinesWeatherConditionLabel] setTextColor:primaryWallpaperColor];
                else if ([weatherConditionColorValue intValue] == 2)
                    [[timeDateView heartlinesWeatherConditionLabel] setTextColor:secondaryWallpaperColor];
                else if ([weatherConditionColorValue intValue] == 3)
                    [[timeDateView heartlinesWeatherConditionLabel] setTextColor:[GcColorPickerUtils colorWithHex:customWeatherConditionColorValue]];
            }
        }
  	});
    
}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 { // reload data after respring

    %orig;

    if (!artworkBasedColorsSwitch) return;
    [[%c(SBMediaController) sharedInstance] setNowPlayingInfo:0];
    
}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.heartlinespreferences"];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];
    if (!enabled) return;

    // style & position
    [preferences registerObject:&styleValue default:@"0" forKey:@"style"];
    [preferences registerObject:&positionValue default:@"0" forKey:@"position"];

    // faceid lock
    [preferences registerBool:&hideFaceIDLockSwitch default:NO forKey:@"hideFaceIDLock"];
    [preferences registerBool:&alignFaceIDLockSwitch default:YES forKey:@"alignFaceIDLock"];
    [preferences registerBool:&smallerFaceIDLockSwitch default:YES forKey:@"smallerFaceIDLock"];

    // text
    [preferences registerBool:&useCustomFontSwitch default:NO forKey:@"useCustomFont"];
    [preferences registerObject:&timeFormatValue default:@"HH:mm" forKey:@"timeFormat"];
    [preferences registerObject:&dateFormatValue default:@"EEEE d MMMM" forKey:@"dateFormat"];
    [preferences registerBool:&useCustomDateLocaleSwitch default:NO forKey:@"useCustomDateLocale"];
    [preferences registerObject:&customDateLocaleValue default:@"" forKey:@"customDateLocale"];
    [preferences registerBool:&useCustomUpNextFontSizeSwitch default:NO forKey:@"useCustomUpNextFontSize"];
    [preferences registerObject:&customUpNextFontSizeValue default:@"19.0" forKey:@"customUpNextFontSize"];
    [preferences registerBool:&useCustomUpNextEventFontSizeSwitch default:NO forKey:@"useCustomUpNextEventFontSize"];
    [preferences registerObject:&customUpNextEventFontSizeValue default:@"15.0" forKey:@"customUpNextEventFontSize"];
    [preferences registerBool:&useCustomTimeFontSizeSwitch default:NO forKey:@"useCustomTimeFontSize"];
    [preferences registerObject:&customTimeFontSizeValue default:@"61.0" forKey:@"customTimeFontSize"];
    [preferences registerBool:&useCustomDateFontSizeSwitch default:NO forKey:@"useCustomDateFontSize"];
    [preferences registerObject:&customDateFontSizeValue default:@"17.0" forKey:@"customDateFontSize"];
    [preferences registerBool:&useCustomWeatherReportFontSizeSwitch default:NO forKey:@"useCustomWeatherReportFontSize"];
    [preferences registerObject:&customWeatherReportFontSizeValue default:@"14.0" forKey:@"customWeatherReportFontSize"];
    [preferences registerBool:&useCustomWeatherConditionFontSizeSwitch default:NO forKey:@"useCustomWeatherConditionFontSize"];
    [preferences registerObject:&customWeatherConditionFontSizeValue default:@"14.0" forKey:@"customWeatherConditionFontSize"];

    // colors
    [preferences registerObject:&faceIDLockColorValue default:@"3" forKey:@"faceIDLockColor"];
    [preferences registerObject:&customFaceIDLockColorValue default:@"FFFFFF" forKey:@"customFaceIDLockColor"];
    [preferences registerObject:&upNextColorValue default:@"3" forKey:@"upNextColor"];
    [preferences registerObject:&customUpNextColorValue default:@"FFFFFF" forKey:@"customUpNextColor"];
    [preferences registerObject:&upNextEventColorValue default:@"1" forKey:@"upNextEventColor"];
    [preferences registerObject:&customUpNextEventColorValue default:@"FFFFFF" forKey:@"customUpNextEventColor"];
    [preferences registerObject:&timeColorValue default:@"3" forKey:@"timeColor"];
    [preferences registerObject:&customTimeColorValue default:@"FFFFFF" forKey:@"customTimeColor"];
    [preferences registerObject:&dateColorValue default:@"3" forKey:@"dateColor"];
    [preferences registerObject:&customDateColorValue default:@"FFFFFF" forKey:@"customDateColor"];
    [preferences registerObject:&weatherReportColorValue default:@"1" forKey:@"weatherReportColor"];
    [preferences registerObject:&customWeatherReportColorValue default:@"FFFFFF" forKey:@"customWeatherReportColor"];
    [preferences registerObject:&weatherConditionColorValue default:@"1" forKey:@"weatherConditionColor"];
    [preferences registerObject:&customWeatherConditionColorValue default:@"FFFFFF" forKey:@"customWeatherConditionColor"];
    [preferences registerBool:&artworkBasedColorsSwitch default:YES forKey:@"artworkBasedColors"];
    [preferences registerObject:&faceIDLockArtworkColorValue default:@"0" forKey:@"faceIDLockArtworkColor"];
    [preferences registerObject:&upNextArtworkColorValue default:@"0" forKey:@"upNextArtworkColor"];
    [preferences registerObject:&upNextEventArtworkColorValue default:@"2" forKey:@"upNextEventArtworkColor"];
    [preferences registerObject:&timeArtworkColorValue default:@"0" forKey:@"timeArtworkColor"];
    [preferences registerObject:&dateArtworkColorValue default:@"0" forKey:@"dateArtworkColor"];
    [preferences registerObject:&weatherReportArtworkColorValue default:@"2" forKey:@"weatherReportArtworkColor"];
    [preferences registerObject:&weatherConditionArtworkColorValue default:@"2" forKey:@"weatherConditionArtworkColor"];

    // weather
    [preferences registerBool:&showWeatherSwitch default:YES forKey:@"showWeather"];

    // up next
    [preferences registerBool:&showUpNextSwitch default:YES forKey:@"showUpNext"];
    [preferences registerBool:&showCalendarEventsSwitch default:YES forKey:@"showCalendarEvents"];
    [preferences registerBool:&showRemindersSwitch default:YES forKey:@"showReminders"];
    [preferences registerBool:&showNextAlarmSwitch default:YES forKey:@"showNextAlarm"];
    [preferences registerBool:&prioritizeRemindersSwitch default:NO forKey:@"prioritizeReminders"];
    [preferences registerBool:&prioritizeAlarmsSwitch default:YES forKey:@"prioritizeAlarms"];
    [preferences registerObject:&dayRangeValue default:@"3" forKey:@"dayRange"];
    [preferences registerBool:&hideUntilAuthenticatedSwitch default:NO forKey:@"hideUntilAuthenticated"];
    [preferences registerBool:&invisibleInkEffectSwitch default:YES forKey:@"invisibleInkEffect"];

    // miscellaneous
    [preferences registerBool:&magsafeCompatibilitySwitch default:NO forKey:@"magsafeCompatibility"];

    if (hideUntilAuthenticatedSwitch && invisibleInkEffectSwitch) dlopen("/System/Library/PrivateFrameworks/ChatKit.framework/ChatKit", RTLD_NOW);
	%init(Heartlines);

}
