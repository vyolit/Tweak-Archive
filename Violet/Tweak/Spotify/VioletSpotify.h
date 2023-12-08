#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

UIImage* currentArtwork = nil;
UIImageView* spotifyArtworkBackgroundImageView = nil;
UIBlurEffect* spotifyBlur = nil;
UIVisualEffectView* spotifyBlurView = nil;
UIView* spotifyDimView = nil;

// spotify
BOOL spotifyArtworkBackgroundSwitch = NO;
NSString* spotifyArtworkBlurMode = @"0";
NSString* spotifyArtworkBlurAmountValue = @"1.0";
NSString* spotifyArtworkOpacityValue = @"1.0";
NSString* spotifyArtworkDimValue = @"0.0";
BOOL hideArtworkSwitch = NO;
BOOL hideNextTrackButtonSwitch = NO;
BOOL hidePreviousTrackButtonSwitch = NO;
BOOL hidePlayButtonSwitch = NO;
BOOL hideShuffleButtonSwitch = NO;
BOOL hideRepeatButtonSwitch = NO;
BOOL hideDevicesButtonSwitch = NO;
BOOL hideQueueButtonSwitch = NO;
BOOL hideSongTitleSwitch = NO;
BOOL hideTimeSliderSwitch = NO;
BOOL hideRemainingTimeLabelSwitch = NO;
BOOL hideElapsedTimeLabelSwitch = NO;
BOOL hideLikeButtonSwitch = NO;
BOOL hideBackButtonSwitch = NO;
BOOL hideContextButtonSwitch = NO;
BOOL hidePlaylistTitleSwitch = NO;

@interface SPTNowPlayingViewController : UIViewController
- (void)setArtwork;
@end

@interface SPTNowPlayingCoverArtCell : UIView
@end

@interface SPTNowPlayingNextTrackButton : UIView
@end

@interface SPTNowPlayingPreviousTrackButton : UIView
@end

@interface SPTNowPlayingPlayButtonV2 : UIView
@end

@interface SPTNowPlayingShuffleButton : UIView
@end

@interface SPTNowPlayingRepeatButton : UIView
@end

@interface SPTGaiaDevicesAvailableViewImplementation : UIView
@end

@interface SPTNowPlayingQueueButton : UIView
@end

@interface SPTNowPlayingSliderV2 : UIView
@end

@interface SPTNowPlayingDurationViewV2 : UIView
@end

@interface SPTNowPlayingAnimatedLikeButton : UIView
@end

@interface SPTNowPlayingTitleButton : UIView
@end

@interface SPTContextMenuAccessoryButton : UIView
@end

@interface SPTNowPlayingMarqueeLabel : UIView
@end

@interface SPTCanvasNowPlayingContentLayerCellCollectionViewCell : UIView
@end

@interface SPTNowPlayingNavigationBarViewV2 : UIView
@end