#import "Yuna.h"

%group Yuna

%hook CCUIModularControlCenterOverlayViewController

%property(nonatomic, retain)UIView* yunaView;
%property(nonatomic, retain)UILabel* upcomingHeaderLabel;
%property(nonatomic, retain)UIImageView* upcomingHeaderIcon;
%property(nonatomic, retain)UILabel* eventsTitleLabel;
%property(nonatomic, retain)UITextView* eventsList;
%property(nonatomic, retain)UILabel* remindersTitleLabel;
%property(nonatomic, retain)UITextView* remindersList;
%property(nonatomic, retain)UILabel* alarmsTitleLabel;
%property(nonatomic, retain)UITextView* alarmsList;
%property(nonatomic, retain)UILabel* notesHeaderLabel;
%property(nonatomic, retain)UIImageView* notesHeaderIcon;
%property(nonatomic, retain)UITextView* notesView;
%property(nonatomic, retain)UIView* weatherIconView;
%property(nonatomic, retain)UIImageView* weatherIcon;
%property(nonatomic, retain)UILabel* weatherTemperatureLabel;
%property(nonatomic, retain)UILabel* weatherConditionLabel;

- (void)viewWillAppear:(BOOL)animated { // add yuna

	%orig;
    

    // yuna view
    if (![self yunaView]) self.yunaView = [UIView new];
    [[self view] insertSubview:[self yunaView] atIndex:1];

    [[self yunaView] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.yunaView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
		[self.yunaView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.yunaView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.yunaView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
	]];


    // upcoming header icon
    if (showIconsSwitch && (showEventsSwitch || showRemindersSwitch || showAlarmsSwitch)) {
        if (![self upcomingHeaderIcon]) self.upcomingHeaderIcon = [UIImageView new];
        [[self upcomingHeaderIcon] setImage:[[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:@"com.apple.mobilecal"] scaleImageToSize:CGSizeMake(30,30)]];
        [[self upcomingHeaderIcon] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [[self upcomingHeaderIcon] setContentMode:UIViewContentModeScaleAspectFill];
        [[self yunaView] addSubview:[self upcomingHeaderIcon]];
        
        [[self upcomingHeaderIcon] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.upcomingHeaderIcon.topAnchor constraintEqualToAnchor:self.yunaView.topAnchor constant:[upcomingNotesYAxisValue doubleValue]],
            [self.upcomingHeaderIcon.leadingAnchor constraintEqualToAnchor:self.yunaView.leadingAnchor constant:[upcomingNotesXAxisValue doubleValue]],
            [self.upcomingHeaderIcon.widthAnchor constraintEqualToConstant:30],
            [self.upcomingHeaderIcon.heightAnchor constraintEqualToConstant:30],
        ]];
    }


    // upcoming header
    if (showEventsSwitch || showRemindersSwitch || showAlarmsSwitch) {
        if (![self upcomingHeaderLabel]) self.upcomingHeaderLabel = [UILabel new];
        [[self upcomingHeaderLabel] setText:upcomingHeaderTitleValue];
        [[self upcomingHeaderLabel] setTextColor:[[GcColorPickerUtils colorWithHex:upcomingHeaderColorValue] colorWithAlphaComponent:[upcomingHeaderAlphaValue doubleValue]]];
        [[self upcomingHeaderLabel] setFont:[UIFont systemFontOfSize:27.5 weight:UIFontWeightSemibold]];
        [[self yunaView] addSubview:[self upcomingHeaderLabel]];
        
        [[self upcomingHeaderLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (!showIconsSwitch) {
            [NSLayoutConstraint activateConstraints:@[
                [self.upcomingHeaderLabel.topAnchor constraintEqualToAnchor:self.yunaView.topAnchor constant:[upcomingNotesYAxisValue doubleValue]],
                [self.upcomingHeaderLabel.leadingAnchor constraintEqualToAnchor:self.yunaView.leadingAnchor constant:[upcomingNotesXAxisValue doubleValue]],
            ]];
        } else {
            [NSLayoutConstraint activateConstraints:@[
                [self.upcomingHeaderLabel.topAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.topAnchor constant:-2],
                [self.upcomingHeaderLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.trailingAnchor constant:8],
            ]];
        }
    }


    // events
    if (showEventsSwitch) {
        [self fetchEvents];
        if (availableEvents != 0) {
            // title
            if (![self eventsTitleLabel]) self.eventsTitleLabel = [UILabel new];
            [[self eventsTitleLabel] setText:eventsTitleValue];
            [[self eventsTitleLabel] setTextColor:[[GcColorPickerUtils colorWithHex:eventsTitleColorValue] colorWithAlphaComponent:[eventsTitleAlphaValue doubleValue]]];
            [[self eventsTitleLabel] setFont:[UIFont systemFontOfSize:22.5 weight:UIFontWeightMedium]];
            [[self yunaView] addSubview:[self eventsTitleLabel]];
            
            [[self eventsTitleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            if (!showIconsSwitch) {
                [NSLayoutConstraint activateConstraints:@[
                    [self.eventsTitleLabel.topAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.bottomAnchor constant:8],
                    [self.eventsTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.leadingAnchor],
                ]];
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [self.eventsTitleLabel.topAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.bottomAnchor constant:8],
                    [self.eventsTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.leadingAnchor],
                ]];
            }


            // list
            if (![self eventsList]) self.eventsList = [UITextView new];
            [[self eventsList] setTextContainerInset:UIEdgeInsetsZero];
            [[[self eventsList] textContainer] setLineFragmentPadding:0];
            [[self eventsList] setScrollEnabled:NO];
            [[self eventsList] setEditable:NO];
            [[self eventsList] setSelectable:NO];
            [[self eventsList] setBackgroundColor:[UIColor clearColor]];
            [[self eventsList] setTextColor:[[GcColorPickerUtils colorWithHex:eventsListColorValue] colorWithAlphaComponent:[eventsListAlphaValue doubleValue]]];
            [[self eventsList] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
            [[self yunaView] addSubview:[self eventsList]];
        
            [[self eventsList] setTranslatesAutoresizingMaskIntoConstraints:NO];
            if (!showIconsSwitch) {
                [NSLayoutConstraint activateConstraints:@[
                    [self.eventsList.topAnchor constraintEqualToAnchor:self.eventsTitleLabel.bottomAnchor constant:4],
                    [self.eventsList.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.leadingAnchor],
                    [self.eventsList.widthAnchor constraintEqualToConstant:200],
                ]];
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [self.eventsList.topAnchor constraintEqualToAnchor:self.eventsTitleLabel.bottomAnchor constant:4],
                    [self.eventsList.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.leadingAnchor],
                    [self.eventsList.widthAnchor constraintEqualToConstant:200],
                ]];
            }
        }
    }


    // reminders
    if (showRemindersSwitch) {
        [self fetchReminders];
        if (availableReminders != 0) {
            // title
            if (![self remindersTitleLabel]) self.remindersTitleLabel = [UILabel new];
            [[self remindersTitleLabel] setText:remindersTitleValue];
            [[self remindersTitleLabel] setTextColor:[[GcColorPickerUtils colorWithHex:remindersTitleColorValue] colorWithAlphaComponent:[remindersTitleAlphaValue doubleValue]]];
            [[self remindersTitleLabel] setFont:[UIFont systemFontOfSize:22.5 weight:UIFontWeightMedium]];
            [[self yunaView] addSubview:[self remindersTitleLabel]];
            
            [[self remindersTitleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            if (availableEvents != 0) {
                if (!showIconsSwitch) {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.remindersTitleLabel.topAnchor constraintEqualToAnchor:self.eventsList.bottomAnchor constant:24],
                        [self.remindersTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.leadingAnchor],
                    ]];
                } else {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.remindersTitleLabel.topAnchor constraintEqualToAnchor:self.eventsList.bottomAnchor constant:24],
                        [self.remindersTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.leadingAnchor],
                    ]];
                }
            } else {
                if (!showIconsSwitch) {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.remindersTitleLabel.topAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.bottomAnchor constant:8],
                        [self.remindersTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.leadingAnchor],
                    ]];
                } else {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.remindersTitleLabel.topAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.bottomAnchor constant:8],
                        [self.remindersTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.leadingAnchor],
                    ]];
                }
            }


            // list
            if (![self remindersList]) self.remindersList = [UITextView new];
            [[self remindersList] setTextContainerInset:UIEdgeInsetsZero];
            [[[self remindersList] textContainer] setLineFragmentPadding:0];
            [[self remindersList] setScrollEnabled:NO];
            [[self remindersList] setEditable:NO];
            [[self remindersList] setSelectable:NO];
            [[self remindersList] setBackgroundColor:[UIColor clearColor]];
            [[self remindersList] setTextColor:[[GcColorPickerUtils colorWithHex:remindersListColorValue] colorWithAlphaComponent:[remindersListAlphaValue doubleValue]]];
            [[self remindersList] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
            [[self yunaView] addSubview:[self remindersList]];
        
            [[self remindersList] setTranslatesAutoresizingMaskIntoConstraints:NO];
            if (!showIconsSwitch) {
                [NSLayoutConstraint activateConstraints:@[
                    [self.remindersList.topAnchor constraintEqualToAnchor:self.remindersTitleLabel.bottomAnchor constant:4],
                    [self.remindersList.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.leadingAnchor],
                    [self.remindersList.widthAnchor constraintEqualToConstant:200],
                ]];
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [self.remindersList.topAnchor constraintEqualToAnchor:self.remindersTitleLabel.bottomAnchor constant:4],
                    [self.remindersList.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.leadingAnchor],
                    [self.remindersList.widthAnchor constraintEqualToConstant:200],
                ]];
            }
        }
    }


    // alarms
    if (showAlarmsSwitch) {
        [self fetchAlarms];
        if (availableAlarms != 0) {
            // title
            if (![self alarmsTitleLabel]) self.alarmsTitleLabel = [UILabel new];
            [[self alarmsTitleLabel] setText:alarmsTitleValue];
            [[self alarmsTitleLabel] setTextColor:[[GcColorPickerUtils colorWithHex:alarmsTitleColorValue] colorWithAlphaComponent:[alarmsTitleAlphaValue doubleValue]]];
            [[self alarmsTitleLabel] setFont:[UIFont systemFontOfSize:22.5 weight:UIFontWeightMedium]];
            [[self yunaView] addSubview:[self alarmsTitleLabel]];
            
            [[self alarmsTitleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
            if (availableReminders != 0) {
                if (!showIconsSwitch) {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.alarmsTitleLabel.topAnchor constraintEqualToAnchor:self.remindersList.bottomAnchor constant:24],
                        [self.alarmsTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.leadingAnchor],
                    ]];
                } else {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.alarmsTitleLabel.topAnchor constraintEqualToAnchor:self.remindersList.bottomAnchor constant:24],
                        [self.alarmsTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.leadingAnchor],
                    ]];
                }
            } else if (availableReminders == 0 && availableEvents != 0) {
                if (!showIconsSwitch) {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.alarmsTitleLabel.topAnchor constraintEqualToAnchor:self.eventsList.bottomAnchor constant:24],
                        [self.alarmsTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.leadingAnchor],
                    ]];
                } else {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.alarmsTitleLabel.topAnchor constraintEqualToAnchor:self.eventsList.bottomAnchor constant:24],
                        [self.alarmsTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.leadingAnchor],
                    ]];
                }
            } else {
                if (!showIconsSwitch) {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.alarmsTitleLabel.topAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.bottomAnchor constant:8],
                        [self.alarmsTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.leadingAnchor],
                    ]];
                } else {
                    [NSLayoutConstraint activateConstraints:@[
                        [self.alarmsTitleLabel.topAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.bottomAnchor constant:8],
                        [self.alarmsTitleLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.leadingAnchor],
                    ]];
                }
            }


            // list
            if (![self alarmsList]) self.alarmsList = [UITextView new];
            [[self alarmsList] setTextContainerInset:UIEdgeInsetsZero];
            [[[self alarmsList] textContainer] setLineFragmentPadding:0];
            [[self alarmsList] setScrollEnabled:NO];
            [[self alarmsList] setEditable:NO];
            [[self alarmsList] setSelectable:NO];
            [[self alarmsList] setBackgroundColor:[UIColor clearColor]];
            [[self alarmsList] setTextColor:[[GcColorPickerUtils colorWithHex:alarmsListColorValue] colorWithAlphaComponent:[alarmsListAlphaValue doubleValue]]];
            [[self alarmsList] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
            [[self yunaView] addSubview:[self alarmsList]];
        
            [[self alarmsList] setTranslatesAutoresizingMaskIntoConstraints:NO];
            if (!showIconsSwitch) {
                [NSLayoutConstraint activateConstraints:@[
                    [self.alarmsList.topAnchor constraintEqualToAnchor:self.alarmsTitleLabel.bottomAnchor constant:4],
                    [self.alarmsList.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.leadingAnchor],
                    [self.alarmsList.widthAnchor constraintEqualToConstant:200],
                ]];
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [self.alarmsList.topAnchor constraintEqualToAnchor:self.alarmsTitleLabel.bottomAnchor constant:4],
                    [self.alarmsList.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderIcon.leadingAnchor],
                    [self.alarmsList.widthAnchor constraintEqualToConstant:200],
                ]];
            }
        }
    }


    // notes header icon
    if (showIconsSwitch && showNotesSwitch) {
        if (![self notesHeaderIcon]) self.notesHeaderIcon = [UIImageView new];
        [[self notesHeaderIcon] setImage:[[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:@"com.apple.mobilenotes"] scaleImageToSize:CGSizeMake(30,30)]];
        [[self notesHeaderIcon] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [[self notesHeaderIcon] setContentMode:UIViewContentModeScaleAspectFill];
        [[self yunaView] addSubview:[self notesHeaderIcon]];
        
        [[self notesHeaderIcon] setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (showEventsSwitch || showRemindersSwitch || showAlarmsSwitch) {
            [NSLayoutConstraint activateConstraints:@[
                [self.notesHeaderIcon.topAnchor constraintEqualToAnchor:self.yunaView.topAnchor constant:[upcomingNotesYAxisValue doubleValue]],
                [self.notesHeaderIcon.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.trailingAnchor constant:[upcomingNotesXAxisValue doubleValue]],
                [self.notesHeaderIcon.widthAnchor constraintEqualToConstant:30],
                [self.notesHeaderIcon.heightAnchor constraintEqualToConstant:30],
            ]];
        } else {
            [NSLayoutConstraint activateConstraints:@[
                [self.notesHeaderIcon.topAnchor constraintEqualToAnchor:self.yunaView.topAnchor constant:[upcomingNotesYAxisValue doubleValue]],
                [self.notesHeaderIcon.leadingAnchor constraintEqualToAnchor:self.yunaView.trailingAnchor constant:[upcomingNotesXAxisValue doubleValue]],
                [self.notesHeaderIcon.widthAnchor constraintEqualToConstant:30],
                [self.notesHeaderIcon.heightAnchor constraintEqualToConstant:30],
            ]];
        }
    }


    // notes
    if (showNotesSwitch) {
        // header
        if (![self notesHeaderLabel]) self.notesHeaderLabel = [UILabel new];
        [[self notesHeaderLabel] setText:notesHeaderTitleValue];
        [[self notesHeaderLabel] setTextColor:[[GcColorPickerUtils colorWithHex:notesHeaderColorValue] colorWithAlphaComponent:[notesHeaderAlphaValue doubleValue]]];
        [[self notesHeaderLabel] setFont:[UIFont systemFontOfSize:27.5 weight:UIFontWeightSemibold]];
        [[self yunaView] addSubview:[self notesHeaderLabel]];
        
        [[self notesHeaderLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (showEventsSwitch || showRemindersSwitch || showAlarmsSwitch) {
            if (!showIconsSwitch) {
                [NSLayoutConstraint activateConstraints:@[
                    [self.notesHeaderLabel.topAnchor constraintEqualToAnchor:self.yunaView.topAnchor constant:[upcomingNotesYAxisValue doubleValue]],
                    [self.notesHeaderLabel.leadingAnchor constraintEqualToAnchor:self.upcomingHeaderLabel.trailingAnchor constant:[upcomingNotesXAxisValue doubleValue]],
                ]];
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [self.notesHeaderLabel.topAnchor constraintEqualToAnchor:self.notesHeaderIcon.topAnchor constant:-2],
                    [self.notesHeaderLabel.leadingAnchor constraintEqualToAnchor:self.notesHeaderIcon.trailingAnchor constant:8],
                ]];
            }
        } else {
            if (!showIconsSwitch) {
                [NSLayoutConstraint activateConstraints:@[
                    [self.notesHeaderLabel.topAnchor constraintEqualToAnchor:self.yunaView.topAnchor constant:[upcomingNotesYAxisValue doubleValue]],
                    [self.notesHeaderLabel.leadingAnchor constraintEqualToAnchor:self.yunaView.leadingAnchor constant:[upcomingNotesXAxisValue doubleValue]],
                ]];
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [self.notesHeaderLabel.topAnchor constraintEqualToAnchor:self.notesHeaderIcon.topAnchor constant:-2],
                    [self.notesHeaderLabel.leadingAnchor constraintEqualToAnchor:self.notesHeaderIcon.trailingAnchor constant:8],
                ]];
            }
        }


        // notes
        if (![self notesView]) self.notesView = [UITextView new];
        [[self notesView] setTextContainerInset:UIEdgeInsetsZero];
        [[[self notesView] textContainer] setLineFragmentPadding:0];
        [[self notesView] setScrollEnabled:NO];
        [[self notesView] setEditable:YES];
        [[self notesView] setSelectable:YES];
        [[self notesView] setBackgroundColor:[UIColor clearColor]];
        [[self notesView] setTextColor:[[GcColorPickerUtils colorWithHex:notesTextColorValue] colorWithAlphaComponent:[notesTextAlphaValue doubleValue]]];
        [[self notesView] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
        [[self notesView] setText:[notesPreferences objectForKey:@"notes"]];
        [[self view] addSubview:[self notesView]];
        
        [[self notesView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (showEventsSwitch || showRemindersSwitch || showAlarmsSwitch) {
            if (!showIconsSwitch) {
                [NSLayoutConstraint activateConstraints:@[
                    [self.notesView.topAnchor constraintEqualToAnchor:self.notesHeaderLabel.bottomAnchor constant:8],
                    [self.notesView.leadingAnchor constraintEqualToAnchor:self.notesHeaderLabel.leadingAnchor],
                    [self.notesView.widthAnchor constraintEqualToConstant:300],
                    [self.notesView.heightAnchor constraintEqualToConstant:400],
                ]];
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [self.notesView.topAnchor constraintEqualToAnchor:self.notesHeaderLabel.bottomAnchor constant:8],
                    [self.notesView.leadingAnchor constraintEqualToAnchor:self.notesHeaderIcon.leadingAnchor],
                    [self.notesView.widthAnchor constraintEqualToConstant:300],
                    [self.notesView.heightAnchor constraintEqualToConstant:400],
                ]];
            }
        } else if (!showEventsSwitch && !showRemindersSwitch && !showAlarmsSwitch) {
            if (!showIconsSwitch) {
                [NSLayoutConstraint activateConstraints:@[
                    [self.notesView.topAnchor constraintEqualToAnchor:self.notesHeaderLabel.bottomAnchor constant:8],
                    [self.notesView.leadingAnchor constraintEqualToAnchor:self.notesHeaderLabel.leadingAnchor],
                    [self.notesView.widthAnchor constraintEqualToConstant:300],
                    [self.notesView.heightAnchor constraintEqualToConstant:400],
                ]];
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [self.notesView.topAnchor constraintEqualToAnchor:self.notesHeaderLabel.bottomAnchor constant:8],
                    [self.notesView.leadingAnchor constraintEqualToAnchor:self.notesHeaderIcon.leadingAnchor],
                    [self.notesView.widthAnchor constraintEqualToConstant:300],
                    [self.notesView.heightAnchor constraintEqualToConstant:400],
                ]];
            }
        }
    }


    // weather
    if (showWeatherSwitch) {
        [self updateWeather];
        // icon view
        if (![self weatherIconView]) self.weatherIconView = [UIView new];
        [[self yunaView] addSubview:[self weatherIconView]];

        [[self weatherIconView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.weatherIconView.bottomAnchor constraintEqualToAnchor:self.yunaView.bottomAnchor constant:-[weatherYAxisValue doubleValue]],
            [self.weatherIconView.leadingAnchor constraintEqualToAnchor:self.yunaView.leadingAnchor constant:[weatherXAxisValue doubleValue]],
            [self.weatherIconView.widthAnchor constraintEqualToConstant:60],
            [self.weatherIconView.heightAnchor constraintEqualToConstant:60],
        ]];


        // icon
        if (![self weatherIcon]) self.weatherIcon = [UIImageView new];
        [[self weatherIcon] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [[self weatherIcon] setContentMode:UIViewContentModeScaleAspectFit];
        [[self weatherIcon] setTintColor:[[GcColorPickerUtils colorWithHex:weatherIconColorValue] colorWithAlphaComponent:[weatherIconAlphaValue doubleValue]]];
        [[self weatherIconView] addSubview:[self weatherIcon]];
        
        [[self weatherIcon] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.weatherIcon.centerXAnchor constraintEqualToAnchor:self.weatherIconView.centerXAnchor],
            [self.weatherIcon.centerYAnchor constraintEqualToAnchor:self.weatherIconView.centerYAnchor],
            [self.weatherIcon.widthAnchor constraintEqualToAnchor:self.weatherIconView.widthAnchor],
            [self.weatherIcon.heightAnchor constraintEqualToAnchor:self.weatherIconView.heightAnchor],
        ]];


        // temperature
        if (![self weatherTemperatureLabel]) self.weatherTemperatureLabel = [UILabel new];
        [[self weatherTemperatureLabel] setTextColor:[[GcColorPickerUtils colorWithHex:weatherTemperatureColorValue] colorWithAlphaComponent:[weatherTemperatureAlphaValue doubleValue]]];
        [[self weatherTemperatureLabel] setFont:[UIFont systemFontOfSize:32.5 weight:UIFontWeightSemibold]];
        [[self yunaView] addSubview:[self weatherTemperatureLabel]];
            
        [[self weatherTemperatureLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.weatherTemperatureLabel.topAnchor constraintEqualToAnchor:self.weatherIconView.topAnchor],
            [self.weatherTemperatureLabel.leadingAnchor constraintEqualToAnchor:self.weatherIconView.trailingAnchor constant:8],
        ]];


        // condition
        if (![self weatherConditionLabel]) self.weatherConditionLabel = [UILabel new];
        [[self weatherConditionLabel] setTextColor:[[GcColorPickerUtils colorWithHex:weatherConditionColorValue] colorWithAlphaComponent:[weatherConditionAlphaValue doubleValue]]];
        [[self weatherConditionLabel] setFont:[UIFont systemFontOfSize:22.5 weight:UIFontWeightMedium]];
        [[self yunaView] addSubview:[self weatherConditionLabel]];
            
        [[self weatherConditionLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.weatherConditionLabel.bottomAnchor constraintEqualToAnchor:self.weatherIconView.bottomAnchor],
            [self.weatherConditionLabel.leadingAnchor constraintEqualToAnchor:self.weatherIconView.trailingAnchor constant:4],
        ]];
    }


    // present yuna
    [self presentYunaWithUpcomingAndNotesAnimation:[upcomingNotesAnimationValue boolValue] andWeatherAnimation:[weatherAnimationValue boolValue]];

}

- (void)presentAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 { // present yuna when swipe gesture was cancelled

    %orig;

    [self presentYunaWithUpcomingAndNotesAnimation:[upcomingNotesAnimationValue boolValue] andWeatherAnimation:[weatherAnimationValue boolValue]];

}

- (void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 { // dismiss yuna before control center was fully dismissed and save notes

	%orig;

    if (showNotesSwitch) [self saveNotes];
    [self dismissYunaWithUpcomingAndNotesAnimation:[upcomingNotesAnimationValue boolValue] andWeatherAnimation:[weatherAnimationValue boolValue]];

}

- (void)_dismissalPanGestureRecognizerBegan:(id)arg1 { // dismiss yuna when performing dismissal swipe

    %orig;

	[self dismissYunaWithUpcomingAndNotesAnimation:[upcomingNotesAnimationValue boolValue] andWeatherAnimation:[weatherAnimationValue boolValue]];

}

%new
- (void)presentYunaWithUpcomingAndNotesAnimation:(BOOL)bouncy andWeatherAnimation:(BOOL)fancy { // present yuna with set animations

    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]) || !shouldAnimateIn) return;
    shouldAnimateIn = NO;

    // upcoming & notes
    double upcomingHeaderIconDelay = 0;
    double upcomingHeaderLabelDelay = 0;
    double eventsTitleLabelDelay = 0.05;
    double eventsListDelay = 0.1;
    double remindersTitleLabelDelay = 0.15;
    double remindersListDelay = 0.2;
    double alarmsTitleLabelDelay = 0.25;
    double alarmsListDelay = 0.3;
    double notesHeaderIconDelay = 0;
    double notesHeaderLabelDelay = 0;
    double notesViewDelay = 0.05;

    // weather
    double weatherIconViewDelay = 0.05;
    double weatherTemperatureLabelDelay = 0.1;
    double weatherConditionLabelDelay = 0.15;

    if ((!showEventsSwitch || availableEvents == 0) && showRemindersSwitch && showAlarmsSwitch) {
        remindersTitleLabelDelay = 0.05;
        remindersListDelay = 0.1;
        alarmsTitleLabelDelay = 0.15;
        alarmsListDelay = 0.2;
    } else if ((!showEventsSwitch || availableEvents == 0) && showRemindersSwitch && (!showAlarmsSwitch || availableAlarms == 0)) {
        remindersTitleLabelDelay = 0.05;
        remindersListDelay = 0.1;
    } else if ((!showEventsSwitch || availableEvents == 0) && (!showRemindersSwitch || availableReminders == 0) && showAlarmsSwitch) {
        alarmsTitleLabelDelay = 0.05;
        alarmsListDelay = 0.1;
    } else if (showEventsSwitch && (!showRemindersSwitch || availableReminders == 0) && showAlarmsSwitch) {
        alarmsTitleLabelDelay = 0.15;
        alarmsListDelay = 0.2;
    }

    // upcoming & notes
    if (bouncy) {
        [[self upcomingHeaderIcon] setAlpha:0];
        [[self upcomingHeaderLabel] setAlpha:0];
        [[self eventsTitleLabel] setAlpha:0];
        [[self eventsList] setAlpha:0];
        [[self remindersTitleLabel] setAlpha:0];
        [[self remindersList] setAlpha:0];
        [[self alarmsTitleLabel] setAlpha:0];
        [[self alarmsList] setAlpha:0];
        [[self notesHeaderIcon] setAlpha:0];
        [[self notesHeaderLabel] setAlpha:0];
        [[self notesView] setAlpha:0];

        [[self upcomingHeaderIcon] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self upcomingHeaderLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self eventsTitleLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self eventsList] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self remindersTitleLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self remindersList] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self alarmsTitleLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self alarmsList] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self notesHeaderIcon] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self notesHeaderLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self notesView] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];

        [UIView animateWithDuration:0.3 delay:upcomingHeaderIconDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self upcomingHeaderIcon] setAlpha:1];
            [[self upcomingHeaderIcon] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];
        
        [UIView animateWithDuration:0.3 delay:upcomingHeaderLabelDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self upcomingHeaderLabel] setAlpha:1];
            [[self upcomingHeaderLabel] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:eventsTitleLabelDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self eventsTitleLabel] setAlpha:1];
            [[self eventsTitleLabel] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:eventsListDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self eventsList] setAlpha:1];
            [[self eventsList] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:remindersTitleLabelDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self remindersTitleLabel] setAlpha:1];
            [[self remindersTitleLabel] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:remindersListDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self remindersList] setAlpha:1];
            [[self remindersList] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:alarmsTitleLabelDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self alarmsTitleLabel] setAlpha:1];
            [[self alarmsTitleLabel] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:alarmsListDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self alarmsList] setAlpha:1];
            [[self alarmsList] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:notesHeaderIconDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self notesHeaderIcon] setAlpha:1];
            [[self notesHeaderIcon] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];
        
        [UIView animateWithDuration:0.3 delay:notesHeaderLabelDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self notesHeaderLabel] setAlpha:1];
            [[self notesHeaderLabel] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:notesViewDelay usingSpringWithDamping:250 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self notesView] setAlpha:1];
            [[self notesView] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];
    } else {
        [[self upcomingHeaderIcon] setAlpha:0];
        [[self upcomingHeaderLabel] setAlpha:0];
        [[self eventsTitleLabel] setAlpha:0];
        [[self eventsList] setAlpha:0];
        [[self remindersTitleLabel] setAlpha:0];
        [[self remindersList] setAlpha:0];
        [[self alarmsTitleLabel] setAlpha:0];
        [[self alarmsList] setAlpha:0];
        [[self notesHeaderIcon] setAlpha:0];
        [[self notesHeaderLabel] setAlpha:0];
        [[self notesView] setAlpha:0];

        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [[self upcomingHeaderIcon] setAlpha:1];
            [[self upcomingHeaderLabel] setAlpha:1];
            [[self eventsTitleLabel] setAlpha:1];
            [[self eventsList] setAlpha:1];
            [[self remindersTitleLabel] setAlpha:1];
            [[self remindersList] setAlpha:1];
            [[self alarmsTitleLabel] setAlpha:1];
            [[self alarmsList] setAlpha:1];
            [[self notesHeaderIcon] setAlpha:1];
            [[self notesHeaderLabel] setAlpha:1];
            [[self notesView] setAlpha:1];
        } completion:nil];
    }

    // weather
    if (fancy) {
        [[self weatherIconView] setAlpha:0];
        [[self weatherTemperatureLabel] setAlpha:0];
        [[self weatherConditionLabel] setAlpha:0];

        [[self weatherIconView] setTransform:CGAffineTransformConcat(CGAffineTransformMakeRotation(-45 * M_PI / 180), CGAffineTransformMakeScale(0.7, 0.7))];
        [[self weatherTemperatureLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [[self weatherConditionLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];

        [UIView animateWithDuration:0.75 delay:weatherIconViewDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self weatherIconView] setAlpha:1];
            [[self weatherIconView] setTransform:CGAffineTransformConcat(CGAffineTransformMakeRotation(0), CGAffineTransformMakeScale(1, 1))];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:weatherTemperatureLabelDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self weatherTemperatureLabel] setAlpha:1];
            [[self weatherTemperatureLabel] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];

        [UIView animateWithDuration:0.3 delay:weatherConditionLabelDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self weatherConditionLabel] setAlpha:1];
            [[self weatherConditionLabel] setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];
    } else {
        [[self weatherIconView] setAlpha:0];
        [[self weatherTemperatureLabel] setAlpha:0];
        [[self weatherConditionLabel] setAlpha:0];

        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [[self weatherIconView] setAlpha:1];
            [[self weatherTemperatureLabel] setAlpha:1];
            [[self weatherConditionLabel] setAlpha:1];
        } completion:nil];
    }

}

%new
- (void)dismissYunaWithUpcomingAndNotesAnimation:(BOOL)bouncy andWeatherAnimation:(BOOL)fancy { // dismiss yuna with set animations

    shouldAnimateIn = YES;

    // upcoming & notes
    double upcomingHeaderIconDelay = 0.15;
    double upcomingHeaderLabelDelay = 0.15;
    double eventsTitleLabelDelay = 0.125;
    double eventsListDelay = 0.1;
    double remindersTitleLabelDelay = 0.075;
    double remindersListDelay = 0.05;
    double alarmsTitleLabelDelay = 0.025;
    double alarmsListDelay = 0;
    double notesHeaderIconDelay = 0.025;
    double notesHeaderLabelDelay = 0.025;
    double notesViewDelay = 0;

    // weather
    double weatherIconViewDelay = 0.075;
    double weatherTemperatureLabelDelay = 0.05;
    double weatherConditionLabelDelay = 0.025;

    if ((!showEventsSwitch || availableEvents == 0) && showRemindersSwitch && showAlarmsSwitch) {
        remindersTitleLabelDelay = 0.025;
        remindersListDelay = 0.05;
        alarmsTitleLabelDelay = 0.075;
        alarmsListDelay = 0.1;
    } else if ((!showEventsSwitch || availableEvents == 0) && showRemindersSwitch && (!showAlarmsSwitch || availableAlarms == 0)) {
        remindersTitleLabelDelay = 0.025;
        remindersListDelay = 0.05;
    } else if ((!showEventsSwitch || availableEvents == 0) && (!showRemindersSwitch || availableReminders == 0) && showAlarmsSwitch) {
        alarmsTitleLabelDelay = 0.025;
        alarmsListDelay = 0.05;
    } else if (showEventsSwitch && (!showRemindersSwitch || availableReminders == 0) && showAlarmsSwitch) {
        alarmsTitleLabelDelay = 0.075;
        alarmsListDelay = 0.1;
    }

    if (bouncy) {
        [UIView animateWithDuration:0.15 delay:upcomingHeaderIconDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self upcomingHeaderIcon] setAlpha:0];
            [[self upcomingHeaderIcon] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];
        
        [UIView animateWithDuration:0.15 delay:upcomingHeaderLabelDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self upcomingHeaderLabel] setAlpha:0];
            [[self upcomingHeaderLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:eventsTitleLabelDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self eventsTitleLabel] setAlpha:0];
            [[self eventsTitleLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:eventsListDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self eventsList] setAlpha:0];
            [[self eventsList] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:remindersTitleLabelDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self remindersTitleLabel] setAlpha:0];
            [[self remindersTitleLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:remindersListDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self remindersList] setAlpha:0];
            [[self remindersList] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:alarmsTitleLabelDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self alarmsTitleLabel] setAlpha:0];
            [[self alarmsTitleLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:alarmsListDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self alarmsList] setAlpha:0];
            [[self alarmsList] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:notesHeaderIconDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self notesHeaderIcon] setAlpha:0];
            [[self notesHeaderIcon] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];
        
        [UIView animateWithDuration:0.15 delay:notesHeaderLabelDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self notesHeaderLabel] setAlpha:0];
            [[self notesHeaderLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:notesViewDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self notesView] setAlpha:0];
            [[self notesView] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [[self upcomingHeaderIcon] setAlpha:0];
            [[self upcomingHeaderLabel] setAlpha:0];
            [[self eventsTitleLabel] setAlpha:0];
            [[self eventsList] setAlpha:0];
            [[self remindersTitleLabel] setAlpha:0];
            [[self remindersList] setAlpha:0];
            [[self alarmsTitleLabel] setAlpha:0];
            [[self alarmsList] setAlpha:0];
            [[self notesHeaderIcon] setAlpha:0];
            [[self notesHeaderLabel] setAlpha:0];
            [[self notesView] setAlpha:0];
        } completion:nil];
    }

    if (fancy) {
        [UIView animateWithDuration:0.375 delay:weatherIconViewDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self weatherIconView] setAlpha:0];
            [[self weatherIconView] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:weatherTemperatureLabelDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self weatherTemperatureLabel] setAlpha:0];
            [[self weatherTemperatureLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];

        [UIView animateWithDuration:0.15 delay:weatherConditionLabelDelay usingSpringWithDamping:250 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self weatherConditionLabel] setAlpha:0];
            [[self weatherConditionLabel] setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [[self weatherIconView] setAlpha:0];
            [[self weatherTemperatureLabel] setAlpha:0];
            [[self weatherConditionLabel] setAlpha:0];
        } completion:nil];
    }
    
}

%new
- (void)saveNotes { // save notes

    [[self notesView] resignFirstResponder];
    [notesPreferences setObject:[[self notesView] text] forKey:@"notes"];

}

%new
- (void)fetchEvents { // get a list of events

    EKEventStore* store = [EKEventStore new];
    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* todayEventsComponents = [NSDateComponents new];
    todayEventsComponents.day = 0;
    NSDate* todayEvents = [calendar dateByAddingComponents:todayEventsComponents toDate:[NSDate date] options:0];

    NSDateComponents* daysFromNowComponents = [NSDateComponents new];
    daysFromNowComponents.day = [eventsRangeValue intValue];
    NSDate* daysFromNow = [calendar dateByAddingComponents:daysFromNowComponents toDate:[NSDate date] options:0];

    NSPredicate* calendarPredicate = [store predicateForEventsWithStartDate:todayEvents endDate:daysFromNow calendars:nil];

    NSArray* events = [store eventsMatchingPredicate:calendarPredicate];

    if ([events count]) {
        availableEvents = [events count];
        NSString* fetchedEvents = nil;

        if (availableEvents >= 1 && [eventsAmountValue intValue] >= 1) fetchedEvents = [NSString stringWithFormat:@"%@",[events[0] title]];
        if (availableEvents >= 2 && [eventsAmountValue intValue] >= 2) fetchedEvents = [NSString stringWithFormat:@"%@\n%@",[events[0] title], [events[1] title]];
        if (availableEvents >= 3 && [eventsAmountValue intValue] >= 3) fetchedEvents = [NSString stringWithFormat:@"%@\n%@\n%@",[events[0] title], [events[1] title], [events[2] title]];
        if (availableEvents >= 4 && [eventsAmountValue intValue] >= 4) fetchedEvents = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",[events[0] title], [events[1] title], [events[2] title], [events[3] title]];
        if (availableEvents >= 5 && [eventsAmountValue intValue] >= 5) fetchedEvents = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",[events[0] title], [events[1] title], [events[2] title], [events[3] title], [events[4] title]];
        if (availableEvents >= 6 && [eventsAmountValue intValue] >= 6) fetchedEvents = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",[events[0] title], [events[1] title], [events[2] title], [events[3] title], [events[4] title], [events[4] title]];
        if (availableEvents >= 7 && [eventsAmountValue intValue] >= 7) fetchedEvents = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@",[events[0] title], [events[1] title], [events[2] title], [events[3] title], [events[4] title], [events[4] title], [events[4] title]];

        [[self eventsList] setText:[NSString stringWithFormat:@"%@", fetchedEvents]];
    } else {
        availableEvents = 0;
    }

}

%new
- (void)fetchReminders { // get a list of reminders

    EKEventStore* store = [EKEventStore new];
    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* todayRemindersComponents = [NSDateComponents new];
    todayRemindersComponents.day = -1;
    NSDate* todayReminders = [calendar dateByAddingComponents:todayRemindersComponents toDate:[NSDate date] options:0];

    NSDateComponents* daysFromNowComponents = [NSDateComponents new];
    daysFromNowComponents.day = [remindersRangeValue intValue];
    NSDate* daysFromNow = [calendar dateByAddingComponents:daysFromNowComponents toDate:[NSDate date] options:0];

    NSPredicate* reminderPredicate = [store predicateForIncompleteRemindersWithDueDateStarting:todayReminders ending:daysFromNow calendars:nil];\
    
    [store fetchRemindersMatchingPredicate:reminderPredicate completion:^(NSArray* reminders) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([reminders count]) {
                availableReminders = [reminders count];
                NSString* fetchedReminders = nil;
                
                if (availableReminders >= 1 && [remindersAmountValue intValue] >= 1) fetchedReminders = [NSString stringWithFormat:@"%@",[reminders[0] title]];
                if (availableReminders >= 2 && [remindersAmountValue intValue] >= 2) fetchedReminders = [NSString stringWithFormat:@"%@\n%@",[reminders[0] title], [reminders[1] title]];
                if (availableReminders >= 3 && [remindersAmountValue intValue] >= 3) fetchedReminders = [NSString stringWithFormat:@"%@\n%@\n%@",[reminders[0] title], [reminders[1] title], [reminders[2] title]];
                if (availableReminders >= 4 && [remindersAmountValue intValue] >= 4) fetchedReminders = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",[reminders[0] title], [reminders[1] title], [reminders[2] title], [reminders[3] title]];
                if (availableReminders >= 5 && [remindersAmountValue intValue] >= 5) fetchedReminders = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",[reminders[0] title], [reminders[1] title], [reminders[2] title], [reminders[3] title], [reminders[4] title]];
                if (availableReminders >= 6 && [remindersAmountValue intValue] >= 6) fetchedReminders = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",[reminders[0] title], [reminders[1] title], [reminders[2] title], [reminders[3] title], [reminders[4] title], [reminders[4] title]];
                if (availableReminders >= 7 && [remindersAmountValue intValue] >= 7) fetchedReminders = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@",[reminders[0] title], [reminders[1] title], [reminders[2] title], [reminders[3] title], [reminders[4] title], [reminders[4] title], [reminders[4] title]];

                [[self remindersList] setText:[NSString stringWithFormat:@"%@", fetchedReminders]];
            } else {
                availableReminders = 0;
            }
        });
    }];

}

%new
- (void)fetchAlarms { // get a list of alarms
    
    [[[[%c(SBScheduledAlarmObserver) sharedInstance] valueForKey:@"_alarmManager"] cache] setOrderedAlarms:[[[[%c(SBScheduledAlarmObserver) sharedInstance] valueForKey:@"_alarmManager"] cache] orderedAlarms]];
    NSMutableArray* alarms = [[[[%c(SBScheduledAlarmObserver) sharedInstance] valueForKey:@"_alarmManager"] cache] orderedAlarms];
    if ([alarms count]) {
        availableAlarms = [alarms count];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            NSDate* fireDate1 = nil;
            NSDateComponents* components1 = nil;
            NSDate* fireDate2 = nil;
            NSDateComponents* components2 = nil;
            NSDate* fireDate3 = nil;
            NSDateComponents* components3 = nil;
            NSDate* fireDate4 = nil;
            NSDateComponents* components4 = nil;
            NSDate* fireDate5 = nil;
            NSDateComponents* components5 = nil;
            NSDate* fireDate6 = nil;
            NSDateComponents* components6 = nil;
            NSDate* fireDate7 = nil;
            NSDateComponents* components7 = nil;

            if (availableAlarms >= 1 && [alarmsAmountValue intValue] >= 1) {
                fireDate1 = [alarms[0] nextFireDate];
                components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:fireDate1];
            }
            if (availableAlarms >= 2 && [alarmsAmountValue intValue] >= 2) {
                fireDate2 = [alarms[1] nextFireDate];
                components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:fireDate2];
            }
            if (availableAlarms >= 3 && [alarmsAmountValue intValue] >= 3) {
                fireDate3 = [alarms[2] nextFireDate];
                components3 = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:fireDate3];
            }
            if (availableAlarms >= 4 && [alarmsAmountValue intValue] >= 4) {
                fireDate4 = [alarms[3] nextFireDate];
                components4 = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:fireDate4];
            }
            if (availableAlarms >= 5 && [alarmsAmountValue intValue] >= 5) {
                fireDate5 = [alarms[4] nextFireDate];
                components5 = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:fireDate5];
            }
            if (availableAlarms >= 6 && [alarmsAmountValue intValue] >= 6) {
                fireDate6 = [alarms[5] nextFireDate];
                components6 = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:fireDate6];
            }
            if (availableAlarms >= 7 && [alarmsAmountValue intValue] >= 7) {
                fireDate7 = [alarms[6] nextFireDate];
                components7 = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:fireDate7];
            }

            NSString* fetchedAlarms = nil;
            if (availableAlarms >= 1 && [alarmsAmountValue intValue] >= 1) fetchedAlarms = [NSString stringWithFormat:@"%02ld:%02ld", [components1 hour], [components1 minute]];
            if (availableAlarms >= 2 && [alarmsAmountValue intValue] >= 2) fetchedAlarms = [NSString stringWithFormat:@"%02ld:%02ld\n%02ld:%02ld", [components1 hour], [components1 minute], [components2 hour], [components2 minute]];
            if (availableAlarms >= 3 && [alarmsAmountValue intValue] >= 3) fetchedAlarms = [NSString stringWithFormat:@"%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld", [components1 hour], [components1 minute], [components2 hour], [components2 minute], [components3 hour], [components3 minute]];
            if (availableAlarms >= 4 && [alarmsAmountValue intValue] >= 4) fetchedAlarms = [NSString stringWithFormat:@"%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld", [components1 hour], [components1 minute], [components2 hour], [components2 minute], [components3 hour], [components3 minute], [components4 hour], [components4 minute]];
            if (availableAlarms >= 5 && [alarmsAmountValue intValue] >= 5) fetchedAlarms = [NSString stringWithFormat:@"%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld", [components1 hour], [components1 minute], [components2 hour], [components2 minute], [components3 hour], [components3 minute], [components4 hour], [components4 minute], [components5 hour], [components5 minute]];
            if (availableAlarms >= 6 && [alarmsAmountValue intValue] >= 6) fetchedAlarms = [NSString stringWithFormat:@"%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld", [components1 hour], [components1 minute], [components2 hour], [components2 minute], [components3 hour], [components3 minute], [components4 hour], [components4 minute], [components5 hour], [components5 minute], [components6 hour], [components6 minute]];
            if (availableAlarms >= 7 && [alarmsAmountValue intValue] >= 7) fetchedAlarms = [NSString stringWithFormat:@"%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld\n%02ld:%02ld", [components1 hour], [components1 minute], [components2 hour], [components2 minute], [components3 hour], [components3 minute], [components4 hour], [components4 minute], [components5 hour], [components5 minute], [components6 hour], [components6 minute], [components7 hour], [components7 minute]];

            [[self alarmsList] setText:[NSString stringWithFormat:@"%@", fetchedAlarms]];
        });
    } else {
        availableAlarms = 0;
    }

}

%new
- (void)updateWeather { // update weather data

    [[PDDokdo sharedInstance] refreshWeatherData];

    // icon
    WALockscreenWidgetViewController* weatherWidget = [[PDDokdo sharedInstance] weatherWidget];
	WAForecastModel* currentModel = [weatherWidget currentForecastModel];
	WACurrentForecast* currentCond = [currentModel currentConditions];
	NSInteger currentCode = [currentCond conditionCode];

	if (currentCode <= 2)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"tornado"]];
	else if (currentCode <= 4)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.bolt.rain.fill"]];
	else if (currentCode <= 8)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
	else if (currentCode == 9)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.drizzle.fill"]];
	else if (currentCode == 10)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
	else if (currentCode <= 12)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.rain.fill"]];
    else if (currentCode == 13)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
    else if (currentCode == 14)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
	else if (currentCode <= 16)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.snow.fill"]];
    else if (currentCode == 17)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.hail.fill"]];
	else if (currentCode <= 22)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.fog.fill"]];
	else if (currentCode <= 24)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"wind"]];
	else if (currentCode == 25)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"snow"]];
	else if (currentCode == 26)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.fill"]];
	else if (currentCode <= 28)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.sun.fill"]];
	else if (currentCode <= 30)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.sun.fill"]];
	else if (currentCode <= 32)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"sun.max.fill"]];
	else if (currentCode <= 34)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.sun.fill"]];
	else if (currentCode == 35)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.sleet.fill"]];
	else if (currentCode == 36)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"thermometer.sun.fill"]];
	else if (currentCode <= 38)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.bolt.fill"]];
	else if (currentCode == 39)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.sun.rain.fill"]];
	else if (currentCode == 40)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.heavyrain.fill"]];
	else if (currentCode <= 43)
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"cloud.snow.fill"]];
	else
		[[self weatherIcon] setImage:[UIImage systemImageNamed:@"exclamationmark.triangle.fill"]];

    // temperature
    [[self weatherTemperatureLabel] setText:[NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentTemperature]]];

    // condition
    [[self weatherConditionLabel] setText:[NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentConditions]]];

}

%end

%end

%ctor {

    preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.yunapreferences"];
    notesPreferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.yuna-notes"];

    [preferences registerBool:&enabled default:NO forKey:@"Enabled"];
    struct utsname systemInfo;
	uname(&systemInfo);
    if (!enabled || ![[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding] containsString:@"iPad"]) return;

    // upcoming & notes
    [preferences registerBool:&showIconsSwitch default:YES forKey:@"showIcons"];
    [preferences registerBool:&showEventsSwitch default:YES forKey:@"showEvents"];
    [preferences registerBool:&showRemindersSwitch default:YES forKey:@"showReminders"];
    [preferences registerBool:&showAlarmsSwitch default:YES forKey:@"showAlarms"];
    [preferences registerObject:&upcomingNotesXAxisValue default:@"100" forKey:@"upcomingNotesXAxis"];
    [preferences registerObject:&upcomingNotesYAxisValue default:@"100" forKey:@"upcomingNotesYAxis"];
    [preferences registerObject:&upcomingNotesAnimationValue default:@"1" forKey:@"upcomingNotesAnimation"];
    [preferences registerObject:&upcomingHeaderTitleValue default:@"Upcoming" forKey:@"upcomingHeaderTitle"];
    [preferences registerObject:&upcomingHeaderColorValue default:@"ffffffff" forKey:@"upcomingHeaderColor"];
    [preferences registerObject:&upcomingHeaderAlphaValue default:@"1" forKey:@"upcomingHeaderAlpha"];
    [preferences registerObject:&eventsTitleValue default:@"Events" forKey:@"eventsTitle"];
    [preferences registerObject:&eventsRangeValue default:@"3" forKey:@"eventsRange"];
    [preferences registerObject:&eventsAmountValue default:@"2" forKey:@"eventsAmount"];
    [preferences registerObject:&eventsTitleColorValue default:@"ffffffff" forKey:@"eventsTitleColor"];
    [preferences registerObject:&eventsListColorValue default:@"ffffffff" forKey:@"eventsListColor"];
    [preferences registerObject:&eventsTitleAlphaValue default:@"0.9" forKey:@"eventsTitleAlpha"];
    [preferences registerObject:&eventsListAlphaValue default:@"0.8" forKey:@"eventsListAlpha"];
    [preferences registerObject:&remindersTitleValue default:@"Reminders" forKey:@"remindersTitle"];
    [preferences registerObject:&remindersRangeValue default:@"3" forKey:@"remindersRange"];
    [preferences registerObject:&remindersAmountValue default:@"5" forKey:@"remindersAmount"];
    [preferences registerObject:&remindersTitleColorValue default:@"ffffffff" forKey:@"remindersTitleColor"];
    [preferences registerObject:&remindersListColorValue default:@"ffffffff" forKey:@"remindersListColor"];
    [preferences registerObject:&remindersTitleAlphaValue default:@"0.9" forKey:@"remindersTitleAlpha"];
    [preferences registerObject:&remindersListAlphaValue default:@"0.8" forKey:@"remindersListAlpha"];
    [preferences registerObject:&alarmsTitleValue default:@"Alarms" forKey:@"alarmsTitle"];
    [preferences registerObject:&alarmsAmountValue default:@"1" forKey:@"alarmsAmount"];
    [preferences registerObject:&alarmsTitleColorValue default:@"ffffffff" forKey:@"alarmsTitleColor"];
    [preferences registerObject:&alarmsListColorValue default:@"ffffffff" forKey:@"alarmsListColor"];
    [preferences registerObject:&alarmsTitleAlphaValue default:@"0.9" forKey:@"alarmsTitleAlpha"];
    [preferences registerObject:&alarmsListAlphaValue default:@"0.8" forKey:@"alarmsListAlpha"];
    [preferences registerBool:&showNotesSwitch default:YES forKey:@"showNotes"];
    [preferences registerObject:&weatherXAxisValue default:@"0" forKey:@"weatherXAxis"];
    [preferences registerObject:&weatherYAxisValue default:@"0" forKey:@"weatherYAxis"];
    [preferences registerObject:&notesHeaderTitleValue default:@"Notes" forKey:@"notesHeaderTitle"];
    [preferences registerObject:&notesHeaderColorValue default:@"ffffffff" forKey:@"notesHeaderColor"];
    [preferences registerObject:&notesHeaderAlphaValue default:@"1" forKey:@"notesHeaderAlpha"];
    [preferences registerObject:&notesTextColorValue default:@"ffffffff" forKey:@"notesTextColor"];
    [preferences registerObject:&notesTextAlphaValue default:@"1" forKey:@"notesTextAlpha"];
    [notesPreferences registerObject:&notes default:@"" forKey:@"notes"];

    // weather
    [preferences registerBool:&showWeatherSwitch default:YES forKey:@"showWeather"];
    [preferences registerObject:&weatherXAxisValue default:@"100" forKey:@"weatherXAxis"];
    [preferences registerObject:&weatherYAxisValue default:@"100" forKey:@"weatherYAxis"];
    [preferences registerObject:&weatherAnimationValue default:@"1" forKey:@"weatherAnimation"];
    [preferences registerObject:&weatherIconColorValue default:@"ffffffff" forKey:@"weatherIconColor"];
    [preferences registerObject:&weatherIconAlphaValue default:@"1" forKey:@"weatherIconAlpha"];
    [preferences registerObject:&weatherTemperatureColorValue default:@"ffffffff" forKey:@"weatherTemperatureColor"];
    [preferences registerObject:&weatherTemperatureAlphaValue default:@"0.9" forKey:@"weatherTemperatureAlpha"];
    [preferences registerObject:&weatherConditionColorValue default:@"ffffffff" forKey:@"weatherConditionColor"];
    [preferences registerObject:&weatherConditionAlphaValue default:@"0.8" forKey:@"weatherConditionAlpha"];

	%init(Yuna);

}