//
//  ThirdViewController.h
//  QuTrack
//
//  Created by Garrett Galow on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Playlist.h"
#import "Server.h"
#import "ServerDelegate.h"
#import "PlaylistDelegate.h"
#import "SSPullToRefreshView.h"
#import "DJPullToRefreshContentView.h"

@interface ThirdViewController : UIViewController <UITableViewDataSource, PlaylistDelegate, UIActionSheetDelegate, UISearchBarDelegate, SSPullToRefreshViewDelegate> {
    
    SSPullToRefreshView* pullToRefreshView;
    
    IBOutlet UITableView* playlistTable;
    NSIndexPath* selectedPath;
//    IBOutlet UIActivityIndicatorView* indicator;
    IBOutlet UILabel* numVotes;
//    IBOutlet UILabel* voteText;
//    IBOutlet UIView* loadingView;
//    IBOutlet UIView* innerLoadingView;
    IBOutlet UIView* innerNoVenueView;
//    IBOutlet UIView* tableViewHeader;
    IBOutlet UISearchBar* sBar;
    NSMutableArray* searchArray;
    BOOL searching;
    
//    NSMutableArray* tempplaylist;
//    UInt32 outstandingOperations;
    NSArray* tableArray;

    
}

-(IBAction) refreshButtonPressed:(id)sender;
-(IBAction) backgroundTapped:(id)sender;
-(void) startLoading;

@property (retain, readonly, nonatomic) IBOutlet UITableView* playlistTable;
@property (retain, readonly, nonatomic) NSIndexPath* selectedPath;

@property (retain, nonatomic) SSPullToRefreshView* pullToRefreshView;

@end

//@interface NSDictionary (Song)
//
//-(NSString*) getArtistForSong;
//
//@end
