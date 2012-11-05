//
//  SecondViewControllerV2.m
//  beDJ
//
//  Created by Garrett Galow on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewControllerV2.h"
#import <QuartzCore/QuartzCore.h>
#import "QueueCell.h"
#import "Venues.h"
#import "VoteViewController.h"
#import "VoteView.h"

@interface SecondViewControllerV2 () {
    SSPullToRefreshView* pullToRefreshView;
}

-(IBAction) segmentChanged:(id)sender;

@property (retain, nonatomic) SSPullToRefreshView* pullToRefreshView;

@end

@implementation SecondViewControllerV2

@synthesize playlistTable, selectedPath, pullToRefreshView;

NSString* noUserVotesCastText = @"Cast A Vote To\n See That Song Here.";
NSString* noVotesCastText =@"No One Has Voted Yet.\n Start Voting and Be Heard!";

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Instance Methods

//On server operation show the loading screen
-(void) startLoading {
//    [indicator startAnimating];
//    [loadingView setHidden:NO];
    [innerNoVenueView setHidden:YES];
//    [innerLoadingView setHidden:NO];
    [noVotesCast setHidden:YES];
}

-(void) stopLoading {
//    [indicator stopAnimating];
//    [loadingView setHidden:YES];
//    [innerLoadingView setHidden:YES];
}

//Force a playlist update
-(IBAction) refreshButtonPressed:(id) sender {
    if ([[Venues sharedVenues] currentVenue] != nil) {
//        [indicator startAnimating];
//        [loadingView setHidden:NO];
        [innerNoVenueView setHidden:YES];
//        [innerLoadingView setHidden:NO];
        [[Playlist sharedPlaylist] updatePlaylistDataWithSender:self];
    }
}

-(void) updatePlaylistTable {
    [songsArray removeAllObjects];
    if (selectedSegment == 0) {
        //            songsArray = (NSMutableArray*)[[[Playlist sharedPlaylist] songs] objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)]];
        for (NSDictionary* song in [[Playlist sharedPlaylist] songs]) {
            if ([[song objectForKey:@"votes"] intValue] != 0) {
                [songsArray addObject:song];
            }
        }
        
        noVotesCast.text = noVotesCastText;
        
    } else if (selectedSegment == 1) {
        for (NSDictionary* song in [[Playlist sharedPlaylist] songs]) {
            if ([[song objectForKey:@"uservotes"] intValue] != 0) {
                [songsArray addObject:song];
            }
        }

        noVotesCast.text = noUserVotesCastText;
    }
    
    noVotesCast.hidden = ([songsArray count] == 0) ? NO : YES;
    
    [nowPlayingTable reloadData];
    [playlistTable reloadData];
//    [playlistTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(IBAction) segmentChanged:(id)sender {
    if ([sender respondsToSelector:@selector(selectedSegmentIndex)]) {
        selectedSegment = [sender selectedSegmentIndex];
        [self updatePlaylistTable];
    }
}

-(void) updateSongsArray {
    [songsArray removeAllObjects];
    for (NSDictionary* song in [[Playlist sharedPlaylist] songs]) {
        if ([[song objectForKey:@"votes"] intValue] == 0) {
            break;
        }
        [songsArray addObject:song];
    }
//    songsArray = [[Playlist sharedPlaylist] songs];
//    NSMutableArray* songsToRemove = [[NSMutableArray alloc] initWithCapacity:1];
//    for (NSDictionary* song in songsArray) {
//        if ([[song objectForKey:@"votes"] intValue] == 0) {
//            [songsToRemove addObject:song];
//        }
//    }
//    for (NSDictionary* song in songsToRemove) {
//        [songsArray removeObject:song];
//    }
}

#pragma mark TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (([tableView isEqual:nowPlayingTable]) && nowPlayingExists) {
        return 1;
    } else if ([tableView isEqual:playlistTable]) { //other table
        return [songsArray count];
    } else {
        return 0;
    }
    
//    if ((section == 0) && nowPlayingExists) {
//        //one row to display for now playing
//        return 1;
//        
//    } else if (((section == 0) && !nowPlayingExists) || section == 1) {
//        //# rows is song count
//        return [songsArray count];
//    } else {
//        return 0;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (([tableView isEqual:nowPlayingTable]) && nowPlayingExists) {
        return 38;
    } else if ([tableView isEqual:playlistTable]) {
        return 0;
    } else {
        return 0;
    }
    
//    if ((section == 0) && nowPlayingExists) {
//        return 38;
//    } else if (((section == 0) && !nowPlayingExists) || section == 1) {
//        return 38;
//    } else {
//        return 0;
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (([tableView isEqual:nowPlayingTable]) && nowPlayingExists) {
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.text = @"Now Playing";
//        headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
//        {class:16-bit RGB color, red:60432, green:28089, blue:0}
        headerLabel.textColor = [UIColor colorWithRed:(60432.0/65535.0) green:(28089.0/65535.0) blue:0 alpha:1];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
        headerLabel.textAlignment = UITextAlignmentCenter;
        return headerLabel;
    } else if ([tableView isEqual:playlistTable]) {
        return nil;
    } else {
        return nil;
    }
    
//    if ((section == 0) && nowPlayingExists) {
//        UILabel* headerLabel = [[UILabel alloc] init];
//        headerLabel.text = @"Now Playing";
//        headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
//        headerLabel.textAlignment = UITextAlignmentCenter;
//        return headerLabel;
//        
//    } else if (((section == 0) && !nowPlayingExists) || section == 1) {
//        UILabel* headerLabel = [[UILabel alloc] init];
//        headerLabel.text = @"Top Songs";
//        headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
//        headerLabel.textAlignment = UITextAlignmentCenter;
//        return headerLabel;
//    } else {
//        return nil;
//    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView { 
    
    if ([[Venues sharedVenues] currentVenue] == nil) {
        return 0;
    }
    
    if (([tableView isEqual:nowPlayingTable]) && nowPlayingExists) {
        return 1;
    } else if ([tableView isEqual:playlistTable]) {
        return 1;
    } else {
        return 0;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
    
//    if ((section == 0) && nowPlayingExists) {
//        //        return @"Now Playing";
//        return nil;
//    } else if (((section == 0) && !nowPlayingExists) || section == 1) {
//        return nil;
//    } else {
//        return nil;
//    }
}

//Loads a tableCell for each item in the listOfSongs
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"QueueCell";
    
    QueueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QueueCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (([tableView isEqual:nowPlayingTable]) && nowPlayingExists) {
        cell.title.text = [[[Playlist sharedPlaylist] nowPlaying] objectForKey:@"name"];
        cell.artist.text = [[[Playlist sharedPlaylist] nowPlaying] objectForKey:@"artist"];
        cell.votes.text = nil;
        cell.selfVotes.text = nil;
        cell.songImage.image = [UIImage imageNamed:@"194-note-2@2xw.png"];
        return cell;
    } else {
        
        // Set up the cell...
        NSDictionary* song = [songsArray objectAtIndex:indexPath.row];
        
        cell.title.text = [song objectForKey:@"name"];
        cell.artist.text = [song objectForKey:@"artist"];
        
        cell.votes.text = [[song objectForKey:@"votes"] stringValue];
        
        cell.selfVotes.text = [NSString stringWithFormat:@"(%@)",[[song objectForKey:@"uservotes"] stringValue]];
        
        cell.songImage.image = [UIImage imageNamed:@"194-note-2@2xw.png"];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == nowPlayingTable) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    selectedPath = indexPath;
    NSDictionary* song = [songsArray objectAtIndex:selectedPath.row];
    
    
//    VoteViewController* voteController = [self.storyboard instantiateViewControllerWithIdentifier:@"VoteViewController"];
    VoteViewController* voteController = [[VoteViewController alloc] init];
    
    VoteView* voteView = (VoteView*)voteController.view;
    [voteView setSong:song];
    [voteView setDelegate:self];
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^(){
        [voteView setCenter:CGPointMake(160, 480+voteView.bounds.size.height/2)];
        [self.parentViewController.view addSubview:voteView];
        [voteView setCenter:CGPointMake(160, 481-voteView.bounds.size.height/2)];
    }completion:nil];
    [[voteView picker] selectRow:0 inComponent:0 animated:YES];
    [voteView setInitialVoteValue];
    [voteController viewDidAppear:NO];
    
    //Set up inset view to cast vote
    //    [[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Cast Vote", @"Undo Vote", nil] showInView:self.parentViewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* song = [[songsArray objectAtIndex:selectedPath.row] valueForKey:@"SONG_id"];
    if (buttonIndex == 2) {
        return;
    } else {
        if (buttonIndex == 0) {
            
            [[Playlist sharedPlaylist] castVote:song withVotes:@"1" withSender:self];
            
        } else if (buttonIndex == 1) {
            
            [[Playlist sharedPlaylist] undoVote:song withVotes:@"1" withSender:self];
        }
//        [indicator startAnimating];
//        [loadingView setHidden:NO];
        [innerNoVenueView setHidden:YES];
//        [innerLoadingView setHidden:NO];
        
    }
}

#pragma mark Playlist Delegate Methods

-(void) playlistUpdated {
    //reload the table and stop the indicator
    
    nowPlayingExists = ([[Playlist sharedPlaylist] nowPlaying] == nil) ? NO : YES;
    
    NSNumber* voteCount = [[Playlist sharedPlaylist] userVotes];
    if ([voteCount intValue] == -1) {
        numVotes.text = @"~ Votes";
    }else {
        if ([voteCount intValue] == 1) {
            numVotes.text = [NSString stringWithFormat:@"%@ Vote",[voteCount stringValue]];
        } else {
            numVotes.text = [NSString stringWithFormat:@"%@ Votes",[voteCount stringValue]];
        }
    }
    [self updatePlaylistTable];
//    [self updateSongsArray];
//    [playlistTable reloadData];
    [self.pullToRefreshView finishLoading];
//    [indicator stopAnimating];
//    [loadingView setHidden:YES];
}

-(void)automatedPlaylistUpdated {
    nowPlayingExists = ([[Playlist sharedPlaylist] nowPlaying] == nil) ? NO : YES;
    
    NSNumber* voteCount = [[Playlist sharedPlaylist] userVotes];
    if ([voteCount intValue] == -1) {
        numVotes.text = @"~ Votes";
    }else {
        if ([voteCount intValue] == 1) {
            numVotes.text = [NSString stringWithFormat:@"%@ Vote",[voteCount stringValue]];
        } else {
            numVotes.text = [NSString stringWithFormat:@"%@ Votes",[voteCount stringValue]];
        }
    }
    [self updatePlaylistTable];
}

#pragma mark SSPullToRefresh Delegate Methods

- (void)refresh {
    [self.pullToRefreshView startLoadingAndExpand:YES];
    // Load data...
    [[Playlist sharedPlaylist] updatePlaylistDataWithSender:self];
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //    outstandingOperations = 0;
    songsArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    innerNoVenueView.layer.cornerRadius = 5.0;
    innerNoVenueView.layer.masksToBounds = YES;
//    innerLoadingView.layer.cornerRadius = 5.0;
//    innerLoadingView.layer.masksToBounds = YES;
    noVotesCast.layer.cornerRadius = 5.0;
    noVotesCast.layer.masksToBounds = YES;
    noVotesCast.hidden = YES;
    
    [listControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:playlistTable delegate:self];
    pullToRefreshView.contentView = [[DJPullToRefreshContentView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Playlist sharedPlaylist] addDelegate:self];
    //If no venue connection Show no venue view over table
    if ([[Venues sharedVenues] currentVenue] == nil) {
//        [loadingView setHidden:NO];
        [innerNoVenueView setHidden:NO];
//        [innerLoadingView setHidden:YES];
        [noVotesCast setHidden:YES];
        
        songsArray = [NSMutableArray arrayWithCapacity:1];
        nowPlayingExists = NO;
        [nowPlayingTable reloadData];
        [playlistTable reloadData];
        
        //if 10 sec have passed since last update then update again
    } else if ([[NSDate date] timeIntervalSinceDate:[[Playlist sharedPlaylist] lastUpdate]] > 10) {
        
        //        nowPlayingExists = ([[Playlist sharedPlaylist] nowPlaying] == nil) ? NO : YES;
        [self refresh];
//        [self startLoading];
//        [indicator startAnimating];
//        [loadingView setHidden:NO];
        [innerNoVenueView setHidden:YES];
//        [innerLoadingView setHidden:NO];
        
//        [[Playlist sharedPlaylist] updatePlaylistDataWithSender:self];
        
        //else just reload the table
    } else {
        [innerNoVenueView setHidden:YES];
//        [loadingView setHidden:YES];
        nowPlayingExists = ([[Playlist sharedPlaylist] nowPlaying] == nil) ? NO : YES;
        [self updatePlaylistTable];
//        [self updateSongsArray];
//        [playlistTable reloadData];
        
        NSNumber* voteCount = [[Playlist sharedPlaylist] userVotes];
        if ([voteCount intValue] == -1) {
            numVotes.text = @"~ Votes";
        }else {
            numVotes.text = [voteCount stringValue];
            if ([voteCount intValue] == 1) {
                numVotes.text = [NSString stringWithFormat:@"%@ Vote",[voteCount stringValue]];
            } else {
                numVotes.text = [NSString stringWithFormat:@"%@ Votes",[voteCount stringValue]];
            }
        }
    }    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[Playlist sharedPlaylist] removeDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
