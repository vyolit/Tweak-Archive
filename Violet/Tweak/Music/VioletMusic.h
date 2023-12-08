#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

UIImage* currentArtwork = nil;
UIImageView* musicArtworkBackgroundImageView = nil;
UIBlurEffect* musicBlur = nil;
UIVisualEffectView* musicBlurView = nil;
UIView* musicDimView = nil;
UIView* theTransportView = nil;
BOOL queueIsVisible = NO;

// music
BOOL musicArtworkBackgroundSwitch = NO;
NSString* musicArtworkBlurMode = @"0";
NSString* musicArtworkBlurAmountValue = @"1.0";
NSString* musicArtworkOpacityValue = @"1.0";
NSString* musicArtworkDimValue = @"0.0";
BOOL hideGrabberViewSwitch = NO;
BOOL hideArtworkViewSwitch = NO;
BOOL hideTimeControlSwitch = NO;
BOOL hideKnobViewSwitch = NO;
BOOL hideElapsedTimeLabelSwitch = NO;
BOOL hideRemainingTimeLabelSwitch = NO;
BOOL hideContextualActionsButtonSwitch = NO;
BOOL hideVolumeSliderSwitch = NO;
BOOL hideMinImageSwitch = NO;
BOOL hideMaxImageSwitch = NO;
BOOL hideTitleLabelSwitch = NO;
BOOL hideSubtitleButtonSwitch = NO;
BOOL hideLyricsButtonSwitch = NO;
BOOL hideRouteButtonSwitch = NO;
BOOL hideRouteLabelSwitch = NO;
BOOL hideQueueButtonSwitch = NO;
BOOL hideQueueModeBadgeSwitch = NO;

@interface MusicNowPlayingControlsViewController : UIViewController
- (void)setArtwork;
@end

@interface _TtCC16MusicApplication29NowPlayingQueueViewController14CollectionView : UIView
@end

@interface TimeControl : UISlider
@end

@interface ContextualActionsButton : UIButton
@end

@interface TransportView : UIView
@end

@interface _TtCC16MusicApplication32NowPlayingControlsViewController12VolumeSlider : UISlider
@end

@interface _UISlideriOSVisualElement : UIView
@end

@interface MPRouteButton : UIButton
@end

@interface _TtCC16MusicApplication23PaletteTabBarController23PaletteVisualEffectView : UIView
@end