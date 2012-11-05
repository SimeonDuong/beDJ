//
//  MusicPlayerViewController.h
//  beDJ
//
//  Created by Garrett Galow on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPLayer.h>
#import "HostManagerDelegate.h"

@interface MusicPlayerViewController : UIViewController <MPMediaPickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, HostManagerDelegate> {
    
    IBOutlet UILabel* trackName;
    IBOutlet UILabel* trackArtist;
    IBOutlet UILabel* trackAlbum;
    IBOutlet UILabel* trackTime;
    IBOutlet UIButton* playState;
    IBOutlet UIImageView* albumArt;
    
    IBOutlet UIProgressView* trackTimeBar;
    IBOutlet UIBarButtonItem* newPlaylistButton;
    
    NSTimer* playbackTimer;
    
    IBOutlet UITableView* playlistTable;
}

-(IBAction) nextButtonPressed:(id)sender;
-(IBAction) backButtonPressed:(id)sender;
-(IBAction) newPlaylistButtonSelected:(id)sender;
-(void) updateSongProgress;
-(void) nowPlayingItemChanged;
-(IBAction) playStateButtonPressed:(id)sender;

@end
