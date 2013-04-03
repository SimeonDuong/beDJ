//
//  SecondViewController.m
//  QuTrack
//
//  Created by Garrett Galow on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SecondViewController.h"
#import "QueueCell.h"
#import "Server.h"
#import "Venues.h"
#import "VoteViewController.h"
#import "VoteView.h"

@implementation SecondViewController

@synthesize playlistTable, selectedPath;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Instance Methods

//On server operation show the loading screen
-(void) startLoading {
    [indicator startAnimating];
    [loadingView setHidden:NO];
    [innerNoVenueView setHidden:YES];
    [innerLoadingView setHidden:NO];
}

//Force a playlist update
-(IBAction) refreshButtonPressed:(id) sender {
    [indicator startAnimating];
    [loadingView setHidden:NO];
    [innerNoVenueView setHidden:YES];
    [innerLoadingView setHidden:NO];
    [[Playlist sharedPlaylist] updatePlaylistDataWithSender:self];
}

-(void) updateSongsArray {
    songsArray = [[Playlist sharedPlaylist] songs];
    NSMutableArray* songsToRemove = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSDictionary* song in songsArray) {
        if ([[song objectForKey:@"votes"] intValue] == 0) {
            [songsToRemove addObject:song];
        }
    }
    for (NSDictionary* song in songsToRemove) {
        [songsArray removeObject:song];
    }
}

#pragma mark TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ((section == 0) && nowPlayingExists) {
        //one row to display for now playing
        return 1;
        
    } else if (((section == 0) && !nowPlayingExists) || section == 1) {
        //# rows is song count
        return [songsArray count];
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ((section == 0) && nowPlayingExists) {
        return 38;
    } else if (((section == 0) && !nowPlayingExists) || section == 1) {
        return 38;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ((section == 0) && nowPlayingExists) {
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.text = @"Now Playing";
        headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
        headerLabel.textAlignment = UITextAlignmentCenter;
        return headerLabel;

    } else if (((section == 0) && !nowPlayingExists) || section == 1) {
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.text = @"Top Songs";
        headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
        headerLabel.textAlignment = UITextAlignmentCenter;
        return headerLabel;
    } else {
        return nil;
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView { 
    
    if ([[Venues sharedVenues] currentVenue] == nil) {
        return 0;
    } if (!nowPlayingExists) {
        return 1;
    }else {
        return 2;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ((section == 0) && nowPlayingExists) {
//        return @"Now Playing";
        return nil;
    } else if (((section == 0) && !nowPlayingExists) || section == 1) {
        return nil;
    } else {
        return nil;
    }
}

//Loads a tableCell for each item in the listOfSongs
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"QueueCell";
    
    QueueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QueueCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if ((indexPath.section == 0) && nowPlayingExists) {
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
    
    if ((indexPath.section == 0) && (nowPlayingExists)) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    selectedPath = indexPath;
    NSDictionary* song = [songsArray objectAtIndex:selectedPath.row];

    
    VoteViewController* voteController = [self.storyboard instantiateViewControllerWithIdentifier:@"VoteViewController"];
    
    VoteView* voteView = (VoteView*)voteController.view;
    [voteView setSong:song];
    [voteView setDelegate:self];
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^(){
        [voteView setCenter:CGPointMake(160, 480+voteView.bounds.size.height/2)];
        [self.parentViewController.view addSubview:voteView];
        [voteView setCenter:CGPointMake(160, 481-voteView.bounds.size.height/2)];
    }completion:nil];
    [[voteView picker] selectRow:0 inComponent:0 animated:YES];
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
        [indicator startAnimating];
        [loadingView setHidden:NO];
        [innerNoVenueView setHidden:YES];
        [innerLoadingView setHidden:NO];

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
    [self updateSongsArray];
    [playlistTable reloadData];

    [indicator stopAnimating];
    [loadingView setHidden:YES];
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
    [self updateSongsArray];
    [playlistTable reloadData];
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
    innerLoadingView.layer.cornerRadius = 5.0;
    innerLoadingView.layer.masksToBounds = YES;
    
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
    //If no venue connection Show no venue view over table
    if ([[Venues sharedVenues] currentVenue] == nil) {
        [loadingView setHidden:NO];
        [innerNoVenueView setHidden:NO];
        [innerLoadingView setHidden:YES];
        
        //if 10 sec have passed since last update then update again
    } else if ([[NSDate date] timeIntervalSinceDate:[[Playlist sharedPlaylist] lastUpdate]] > 10) {
        
//        nowPlayingExists = ([[Playlist sharedPlaylist] nowPlaying] == nil) ? NO : YES;
        [indicator startAnimating];
        [loadingView setHidden:NO];
        [innerNoVenueView setHidden:YES];
        [innerLoadingView setHidden:NO];
    
        [[Playlist sharedPlaylist] updatePlaylistDataWithSender:self];
        
        //else just reload the table
    } else {
        [innerNoVenueView setHidden:YES];
        [loadingView setHidden:YES];
        nowPlayingExists = ([[Playlist sharedPlaylist] nowPlaying] == nil) ? NO : YES;
        [self updateSongsArray];
        [playlistTable reloadData];
    }
    
    //Always update the userVoteCount field
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
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
