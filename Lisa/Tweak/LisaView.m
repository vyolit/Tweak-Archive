#import "LisaView.h"

@implementation LisaView

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];

    self.preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.lisapreferences"];
    BOOL blurredBackgroundSwitch = [[[self preferences] objectForKey:@"blurredBackground"] boolValue];
    double backgroundAlphaValue = [[[self preferences] objectForKey:@"backgroundAlpha"] doubleValue];


    // self
	if (!blurredBackgroundSwitch) [self setBackgroundColor:[UIColor blackColor]];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self setAlpha:backgroundAlphaValue];
	[self setHidden:YES];


    // blur
	if (blurredBackgroundSwitch) {
		self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		self.blurView = [[UIVisualEffectView alloc] initWithEffect:[self blur]];
		[[self blurView] setFrame:[self bounds]];
		[[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[self addSubview:[self blurView]];
	}

    return self;

}

- (void)setVisible:(BOOL)visible {

    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    if (visible) {
        [self setHidden:NO];
        [notificationCenter postNotificationName:@"lisaHideElements" object:nil];
        [notificationCenter postNotificationName:@"lisaUpdateNotificationStyleActive" object:nil];
    } else {
        [self setHidden:YES];
        [notificationCenter postNotificationName:@"lisaUnhideElements" object:nil];
        [notificationCenter postNotificationName:@"lisaUpdateNotificationStyleInactive" object:nil];
    }

}

- (void)playHapticFeedback {

    int hapticFeedbackStrengthValue = [[[self preferences] objectForKey:@"hapticFeedbackStrength"] intValue];

    if (hapticFeedbackStrengthValue == 0) AudioServicesPlaySystemSound(1519);
    else if (hapticFeedbackStrengthValue == 1) AudioServicesPlaySystemSound(1520);
    else if (hapticFeedbackStrengthValue == 2) AudioServicesPlaySystemSound(1521);

}

@end