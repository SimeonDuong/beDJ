//
//  SecondViewControllerV2.h
//  beDJ
//
//  Created by Garrett Galow on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistDelegate.h"
#import "Playlist.h"
#import "DJPullToRefreshContentView.h"
#import "SSPullToRefreshView.h"

@interface SecondViewControllerV2 : UIViewController <PlaylistDelegate, UIActionSheetDelegate, SSPullToRefreshViewDelegate> {
    
    BOOL nowPlayingExists;
    NSMutableArray* songsArray;
    
    IBOutlet UITableView* nowPlayingTable;
    IBOutlet UITableView* playlistTable;
    NSIndexPath* selectedPath;
    
//    IBOutlet UIActivityIndicatorView* indicator;
    IBOutlet UIBarButtonItem* refresh;
    IBOutlet UILabel* numVotes;
    
//    IBOutlet UIView* loadingView;
//    IBOutlet UIView* innerLoadingView;
    IBOutlet UIView* innerNoVenueView;
    IBOutlet UILabel* noVotesCast;
    
    IBOutlet UISegmentedControl* listControl;
    NSInteger selectedSegment;
    
}

-(IBAction) refreshButtonPressed:(id) sender;
-(void) startLoading;
-(void) updatePlaylistTable;
-(void) refresh;

@property (retain, readonly, nonatomic) IBOutlet UITableView* playlistTable;
@property (retain, readonly, nonatomic) NSIndexPath* selectedPath;

@end
