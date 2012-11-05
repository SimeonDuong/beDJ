//
//  SecondViewController.h
//  QuTrack
//
//  Created by Garrett Galow on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "Server.h"
#import "PlaylistDelegate.h"

@interface SecondViewController : UIViewController <PlaylistDelegate, UIActionSheetDelegate> {
    
//    UInt32 outstandingOperations;
    BOOL nowPlayingExists;
    NSMutableArray* songsArray;
    
    IBOutlet UITableView* playlistTable;
    NSIndexPath* selectedPath;

    IBOutlet UIActivityIndicatorView* indicator;
    IBOutlet UIBarButtonItem* refresh;
    IBOutlet UILabel* numVotes;
//    IBOutlet UILabel* voteText;
    IBOutlet UIView* loadingView;
    IBOutlet UIView* innerLoadingView;
    IBOutlet UIView* innerNoVenueView;

}

-(IBAction) refreshButtonPressed:(id) sender;
-(void) startLoading;

@property (retain, readonly, nonatomic) IBOutlet UITableView* playlistTable;
@property (retain, readonly, nonatomic) NSIndexPath* selectedPath;

@end
