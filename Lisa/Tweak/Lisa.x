#import "Lisa.h"

static BBServer* bbServer = nil;

static dispatch_queue_t getBBServerQueue() {

    static dispatch_queue_t queue;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        void* handle = dlopen(NULL, RTLD_GLOBAL);
        if (handle) {
            dispatch_queue_t __weak* pointer = (__weak dispatch_queue_t *) dlsym(handle, "__BBServerQueue");
            if (pointer) queue = *pointer;
            dlclose(handle);
        }
    });

    return queue;

}

static void fakeNotification(NSString* sectionID, NSDate* date, NSString* message, bool banner) {
    
	BBBulletin* bulletin = [[%c(BBBulletin) alloc] init];

	bulletin.title = @"Lisa";
    bulletin.message = message;
    bulletin.sectionID = sectionID;
    bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.publisherBulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.date = date;
    bulletin.defaultAction = [%c(BBAction) actionWithLaunchBundleID:sectionID callblock:nil];
    bulletin.clearable = YES;
    bulletin.showsMessagePreview = YES;
    bulletin.publicationDate = date;
    bulletin.lastInterruptDate = date;

    if (banner) {
        if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:)]) {
            dispatch_sync(getBBServerQueue(), ^{
                [bbServer publishBulletin:bulletin destinations:15];
            });
        }
    } else {
        if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:alwaysToLockScreen:)]) {
            dispatch_sync(getBBServerQueue(), ^{
                [bbServer publishBulletin:bulletin destinations:4 alwaysToLockScreen:YES];
            });
        } else if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:)]) {
            dispatch_sync(getBBServerQueue(), ^{
                [bbServer publishBulletin:bulletin destinations:4];
            });
        }
    }

}

void LSATestNotifications() {

    SpringBoard* springboard = (SpringBoard *)[objc_getClass("SpringBoard") sharedApplication];
	[springboard _simulateLockButtonPress];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        fakeNotification(@"com.apple.mobilephone", [NSDate date], @"Missed Call", false);
        fakeNotification(@"com.apple.Music", [NSDate date], @"ODESZA - For Us (feat. Briana Marela)", false);
        fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Hello, I'm Lisa", false);
        fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Hello, I'm Lisa", false);
        fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Hello, I'm Lisa", false);
        fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Hello, I'm Lisa", false);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (isDNDActive) [springboard _simulateHomeButtonPress];
        });
    });

}

void LSATestBanner() {

    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Hello, I'm Lisa", true);

}

%group Lisa

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add lisa

	%orig;

	lisaView = [LisaView new];
    [lisaView setFrame:[[self view] bounds]];
    [[self view] insertSubview:lisaView atIndex:0];

}

- (void)viewDidDisappear:(BOOL)animated { // hide lisa when unlocked

    %orig;

    [lisaView setVisible:NO];

}

%end

%hook SBMainDisplayPolicyAggregator

- (BOOL)_allowsCapabilityTodayViewWithExplanation:(id *)arg1 { // disable today view swipe

    if (disableTodaySwipeSwitch)
		return NO;
	else
		return %orig;

}

- (BOOL)_allowsCapabilityLockScreenCameraWithExplanation:(id *)arg1 { // disable camera swipe

    if (disableCameraSwipeSwitch)
		return NO;
	else
		return %orig;

}

%end

%hook NCNotificationListView

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 { // tap to dismiss

    %orig;

    if (!tapToDismissLisaSwitch || [lisaView isHidden]) return;
    if (lisaFadeOutAnimationSwitch) {
        [UIView animateWithDuration:[lisaFadeOutAnimationValue doubleValue] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [lisaView setAlpha:0];
        } completion:^(BOOL finished) {
            [lisaView setVisible:NO];
            [lisaView setAlpha:[backgroundAlphaValue doubleValue]];
        }];
        if (hapticFeedbackSwitch) [lisaView playHapticFeedback];
    } else {
        [lisaView setVisible:NO];
        if (hapticFeedbackSwitch) [lisaView playHapticFeedback];
    }

}

%end

%hook SBBacklightController

- (void)turnOnScreenFullyWithBacklightSource:(long long)arg1 { // show lisa based on user settings

	%orig;

    if (isScreenOn) return;
    isScreenOn = YES;

    if (![[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible]) return;
    if (onlyWhileChargingSwitch && ![[%c(SBUIController) sharedInstance] isOnAC]) return;
    
    if (onlyWhenDNDIsActiveSwitch && isDNDActive) {
        if (whenNotificationArrivesSwitch && arg1 == 12)
            [lisaView setVisible:YES];
        else if (whenPlayingMusicSwitch && [[%c(SBMediaController) sharedInstance] isPlaying])
            [lisaView setVisible:YES];
        else if (alwaysWhenNotificationsArePresentedSwitch && notificationCount > 0)
            [lisaView setVisible:YES];
        else
            [lisaView setVisible:NO];
    } else if (!onlyWhenDNDIsActiveSwitch) {
        if (whenNotificationArrivesSwitch && arg1 == 12)
            [lisaView setVisible:YES];
        else if (whenPlayingMusicSwitch && [[%c(SBMediaController) sharedInstance] isPlaying])
            [lisaView setVisible:NO];
        else if (alwaysWhenNotificationsArePresentedSwitch && notificationCount > 0)
            [lisaView setVisible:YES];
        else
            [lisaView setVisible:NO];
    }

}

%end

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 { // note when screen turned off

	%orig;

    isScreenOn = NO;

}

%end

%hook NCNotificationMasterList

- (unsigned long long)notificationCount { // get the notification count

    notificationCount = %orig;

    return notificationCount;

}

%end

%hook DNDState

- (BOOL)isActive { // get the dnd state

    isDNDActive = %orig;

    return isDNDActive;

}

%end

%hook NCNotificationViewControllerView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    id orig = %orig;

    if ([notificationStyleValue intValue] != 0) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(updateNotificationStyle:) name:@"lisaUpdateNotificationStyleActive" object:nil];
        [notificationCenter addObserver:self selector:@selector(updateNotificationStyle:) name:@"lisaUpdateNotificationStyleInactive" object:nil];
    }

    return orig;

}

- (void)didMoveToWindow {

    %orig;

    if ([notificationStyleValue intValue] != 0 && ![lisaView isHidden]) [self setOverrideUserInterfaceStyle:[notificationStyleValue intValue]];

}

%new
- (void)updateNotificationStyle:(NSNotification *)notification { // set light/dark notification style

    if ([notification.name isEqual:@"lisaUpdateNotificationStyleActive"]) {
        previousNotificationStyle = [self overrideUserInterfaceStyle];
        [self setOverrideUserInterfaceStyle:[notificationStyleValue intValue]];
    } else if ([notification.name isEqual:@"lisaUpdateNotificationStyleInactive"]) {
        [self setOverrideUserInterfaceStyle:previousNotificationStyle];
    }

}

%end

%hook UIStatusBar_Modern

- (void)setFrame:(CGRect)arg1 { // add a notification observer

    if (hideStatusBarSwitch && !hasAddedStatusBarObserver) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
        hasAddedStatusBarObserver = YES;
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide status bar

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [[self statusBar] setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:[self statusBar] duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [[self statusBar] setHidden:NO];
        } completion:nil];
    }

}

%end

%hook SBUIProudLockIconView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideFaceIDLockSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide faceid lock

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook SBFLockScreenDateView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideTimeAndDateSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide time and date

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook CSQuickActionsButton

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideQuickActionsSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide quick actions

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook CSTeachableMomentsContainerView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideControlCenterIndicatorSwitch || hideUnlockTextSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide control center indicator and or unlock text

    if ([notification.name isEqual:@"lisaHideElements"]) {
        if (hideControlCenterIndicatorSwitch) [[self controlCenterGrabberContainerView] setHidden:YES];
        if (hideUnlockTextSwitch) [[self callToActionLabelContainerView] setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            if (hideControlCenterIndicatorSwitch) [[self controlCenterGrabberContainerView] setHidden:NO];
            if (hideUnlockTextSwitch) [[self callToActionLabelContainerView] setHidden:NO];
        } completion:nil];
    }

}

%end

%hook SBUICallToActionLabel

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideUnlockTextSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide unlock text

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook CSHomeAffordanceView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideHomebarSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide homebar

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook CSPageControl

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hidePageDotsSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide page dots

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook ComplicationsView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideComplicationsSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide complications

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook KAIBatteryPlatter

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideKaiSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide kai

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook APEPlatter

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideAperioSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide aperio

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook LibellumView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideLibellumSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide lebellum

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook VezaView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideVezaSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide veza

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook AXNView

- (id)initWithFrame:(CGRect)frame { // add a notification observer

    if (hideVezaSwitch) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaHideElements" object:nil];
        [notificationCenter addObserver:self selector:@selector(receiveHideNotification:) name:@"lisaUnhideElements" object:nil];
    }

	return %orig;

}

%new
- (void)receiveHideNotification:(NSNotification *)notification { // receive notification and hide or unhide axon

	if ([notification.name isEqual:@"lisaHideElements"]) {
        [self setHidden:YES];
    } else if ([notification.name isEqual:@"lisaUnhideElements"]) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setHidden:NO];
        } completion:nil];
    }

}

%end

%hook BBServer

- (id)initWithQueue:(id)arg1 {

    bbServer = %orig;
    
    return bbServer;

}

- (id)initWithQueue:(id)arg1 dataProviderManager:(id)arg2 syncService:(id)arg3 dismissalSyncCache:(id)arg4 observerListener:(id)arg5 utilitiesListener:(id)arg6 conduitListener:(id)arg7 systemStateListener:(id)arg8 settingsListener:(id)arg9 {
    
    bbServer = %orig;

    return bbServer;

}

- (void)dealloc {

    if (bbServer == self) bbServer = nil;

    %orig;

}

%end

%end

%ctor {

    preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.lisapreferences"];
    [preferences registerBool:&enabled default:NO forKey:@"Enabled"];
    if (!enabled) return;

    // customization
    [preferences registerBool:&onlyWhenDNDIsActiveSwitch default:NO forKey:@"onlyWhenDNDIsActive"];
    [preferences registerBool:&whenNotificationArrivesSwitch default:YES forKey:@"whenNotificationArrives"];
    [preferences registerBool:&alwaysWhenNotificationsArePresentedSwitch default:YES forKey:@"alwaysWhenNotificationsArePresented"];
    [preferences registerBool:&whenPlayingMusicSwitch default:YES forKey:@"whenPlayingMusic"];
    [preferences registerBool:&onlyWhileChargingSwitch default:NO forKey:@"onlyWhileCharging"];
    [preferences registerBool:&hideStatusBarSwitch default:YES forKey:@"hideStatusBar"];
    [preferences registerBool:&hideControlCenterIndicatorSwitch default:YES forKey:@"hideControlCenterIndicator"];
    [preferences registerBool:&hideFaceIDLockSwitch default:YES forKey:@"hideFaceIDLock"];
    [preferences registerBool:&hideTimeAndDateSwitch default:YES forKey:@"hideTimeAndDate"];
    [preferences registerBool:&hideQuickActionsSwitch default:YES forKey:@"hideQuickActions"];
    [preferences registerBool:&hideUnlockTextSwitch default:YES forKey:@"hideUnlockText"];
    [preferences registerBool:&hideHomebarSwitch default:YES forKey:@"hideHomebar"];
    [preferences registerBool:&hidePageDotsSwitch default:YES forKey:@"hidePageDots"];
    [preferences registerBool:&hideComplicationsSwitch default:YES forKey:@"hideComplications"];
    [preferences registerBool:&hideKaiSwitch default:YES forKey:@"hideKai"];
    [preferences registerBool:&hideAperioSwitch default:YES forKey:@"hideAperio"];
    [preferences registerBool:&hideLibellumSwitch default:YES forKey:@"hideLibellum"];
    [preferences registerBool:&hideVezaSwitch default:YES forKey:@"hideVeza"];
    [preferences registerBool:&hideAxonSwitch default:YES forKey:@"hideAxon"];
    [preferences registerBool:&disableTodaySwipeSwitch default:NO forKey:@"disableTodaySwipe"];
    [preferences registerBool:&disableCameraSwipeSwitch default:NO forKey:@"disableCameraSwipe"];
    [preferences registerBool:&blurredBackgroundSwitch default:NO forKey:@"blurredBackground"];
    [preferences registerBool:&tapToDismissLisaSwitch default:YES forKey:@"tapToDismissLisa"];
    [preferences registerObject:&backgroundAlphaValue default:@"1" forKey:@"backgroundAlpha"];
    [preferences registerObject:&notificationStyleValue default:@"0" forKey:@"notificationStyle"];
    
    // animations
    [preferences registerBool:&lisaFadeOutAnimationSwitch default:YES forKey:@"lisaFadeOutAnimation"];
    [preferences registerObject:&lisaFadeOutAnimationValue default:@"0.5" forKey:@"lisaFadeOutAnimation"];

    // haptic feedback
    [preferences registerBool:&hapticFeedbackSwitch default:NO forKey:@"hapticFeedback"];
    if (hapticFeedbackSwitch) [preferences registerObject:&hapticFeedbackStrengthValue default:@"0" forKey:@"hapticFeedbackStrength"];

    if (hideComplicationsSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Complications.dylib"]) dlopen("/Library/MobileSubstrate/DynamicLibraries/Complications.dylib", RTLD_NOW);
    if (hideKaiSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Kai.dylib"]) dlopen("/Library/MobileSubstrate/DynamicLibraries/Kai.dylib", RTLD_NOW);
    if (hideAperioSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Aperio.dylib"]) dlopen("/Library/MobileSubstrate/DynamicLibraries/Aperio.dylib", RTLD_NOW);
    if (hideLibellumSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Libellum.dylib"]) dlopen("/Library/MobileSubstrate/DynamicLibraries/Libellum.dylib", RTLD_NOW);
    if (hideVezaSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Veza.dylib"]) dlopen("/Library/MobileSubstrate/DynamicLibraries/Veza.dylib", RTLD_NOW);
    if (hideAxonSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Axon.dylib"]) dlopen("/Library/MobileSubstrate/DynamicLibraries/Axon.dylib", RTLD_NOW);

    %init(Lisa);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)LSATestNotifications, (CFStringRef)@"love.litten.lisa/TestNotifications", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)LSATestBanner, (CFStringRef)@"love.litten.lisa/TestBanner", NULL, (CFNotificationSuspensionBehavior)kNilOptions);

}