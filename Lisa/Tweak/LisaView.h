#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <Cephei/HBPreferences.h>

@interface LisaView : UIView
@property(nonatomic, retain)HBPreferences* preferences;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UIVisualEffectView* blurView;
- (void)setVisible:(BOOL)visible;
- (void)playHapticFeedback;
@end