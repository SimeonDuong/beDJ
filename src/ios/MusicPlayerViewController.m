//
//  MusicPlayerViewController.m
//  beDJ
//
//  Created by Garrett Galow on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "QueueCell.h"
#import "HostManager.h"
#import <CoreMedia/CoreMedia.h>

@interface MusicPlayerViewController () {
    BOOL playlistPicked;
    BOOL newPlaylistPicked;
}

@end

@implementation MusicPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Instance Methods

-(IBAction) nextButtonPressed:(id)sender {
    [[HostManager sharedHostManager] nextSong];
}

-(IBAction) backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    playlistPicked = NO;
//    [[[HostManager sharedHostManager] musicPlayer] pause];
}

-(IBAction) playStateButtonPressed:(id)sender {
    AVPlayer* currentPlayer = [[HostManager sharedHostManager] musicPlayer];
    if (currentPlayer == nil) {
        [playState setTitle:@"Paused" forState:UIControlStateNormal];
        return;
    }
    if (currentPlayer.rate == 0.0) {
        currentPlayer.rate = 1.0;
        [playState setTitle:@"Playing" forState:UIControlStateNormal];
    } else if (currentPlayer.rate == 1.0) {
        currentPlayer.rate = 0.0;
        [playState setTitle:@"Paused" forState:UIControlStateNormal];
    }
}

-(IBAction) newPlaylistButtonSelected:(id)sender {
    [self showMediaPicker];
}

-(void) updateSongInfo {
    if ([[HostManager sharedHostManager] musicPlayer] == nil) {
        return;
    }
    [self updateSongProgress];
//    NSLog(@"songinfo update");
    [self nowPlayingItemChanged];
//    [playlistTable reloadData];
}

-(void) updateSongProgress {
    AVPlayer* currentMusicPlayer = [[HostManager sharedHostManager] musicPlayer];
    NSString* currentSongID = [[[HostManager sharedHostManager] nowPlaying] valueForKey:@"SONG_id"];
    MPMediaItem* currentItem = [[[HostManager sharedHostManager] songFiles] valueForKey:currentSongID];
    NSTimeInterval trackLength = [[currentItem valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    NSTimeInterval playbackTime = CMTimeGetSeconds([currentMusicPlayer currentTime]);
    [trackTimeBar setProgress:(playbackTime/trackLength) animated:YES];
    int playbackMins = (int)playbackTime/60;
    int playbackSecs = (int)playbackTime%60;
    int trackLengthMins = (int)trackLength/60;
    int trackLengthSecs = (int)trackLength%60;
    NSString* playbackTimeString = (playbackSecs < 10) ? [NSString stringWithFormat:@"%d:0%d",playbackMins,playbackSecs] : [NSString stringWithFormat:@"%d:%d",playbackMins,playbackSecs];
    NSString* trackLengthString = (trackLengthSecs < 10) ? [NSString stringWithFormat:@"%d:0%d",trackLengthMins,trackLengthSecs] : [NSString stringWithFormat:@"%d:%d",trackLengthMins,trackLengthSecs];
    trackTime.text = [NSString stringWithFormat:@"%@/%@",playbackTimeString,trackLengthString];
    
    
    //playback state
    if (currentMusicPlayer.rate == 0.0) {
        //player is paused/stopped
        [playState setTitle:@"Paused" forState:UIControlStateNormal];
    } else if (currentMusicPlayer.rate == 1.0) {
        //player is playing
        [playState setTitle:@"Playing" forState:UIControlStateNormal];
    }
}

#pragma mark - HostManager Delegate Methods

-(void) hostPlaylistUpdated {
//    NSLog(@"playlistUpdate");
    [playlistTable reloadData];
}

-(void)nowPlayingItemChanged {
    NSString* nowPlayingSongID = [[[HostManager sharedHostManager] nowPlaying] valueForKey:@"SONG_id"];
    MPMediaItem *currentItem = [[[HostManager sharedHostManager] songFiles] valueForKey:nowPlayingSongID]; 
//    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    UIImage* artworkImage = [artwork imageWithSize:CGSizeMake(100, 100)];
    if (artworkImage) {
        [albumArt setImage:artworkImage];
    } else {
        artworkImage = [UIImage imageNamed:@"musicNoteandDisc.png"];
        [albumArt setImage:artworkImage];
    }
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if ((![titleString isEqualToString:@""]) && (titleString != nil) ) {
        trackName.text = [NSString stringWithFormat:@"%@",titleString];
    } else {
        trackName.text = @"Unknown Title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if ((![artistString isEqualToString:@""]) && (artistString != nil) ) {
        trackArtist.text = [NSString stringWithFormat:@"%@",artistString];
    } else {
        trackArtist.text = @"Unknown Artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if ((![albumString isEqualToString:@""]) && (albumString != nil) ) {
        trackAlbum.text = [NSString stringWithFormat:@"%@",albumString];
    } else {
        trackAlbum.text = @"Unknown Album";
    }

}

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"Playlist";
//    headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
    headerLabel.textColor = [UIColor colorWithRed:(60432.0/65535.0) green:(28089.0/65535.0) blue:0 alpha:1];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    headerLabel.textAlignment = UITextAlignmentLeft;
    return headerLabel;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView { 
    
    return 1;
}


#pragma mark - TableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[HostManager sharedHostManager] playlist] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"QueueCell";
    
    QueueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QueueCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
//    NSLog(@"1");
    NSDictionary* song = [[[HostManager sharedHostManager] playlist] objectAtIndex:indexPath.row];
    
    cell.title.text = [song objectForKey:@"name"];
    cell.artist.text = [song objectForKey:@"artist"];
    
    cell.votes.text = [[song objectForKey:@"votes"] stringValue];
    
    cell.selfVotes.text = [NSString stringWithFormat:@"(%@)",[[song objectForKey:@"uservotes"] stringValue]];
    
    cell.songImage.image = [UIImage imageNamed:@"194-note-2@2xw.png"];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Media Methods

- (void)showMediaPicker
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentModalViewController:mediaPicker animated:YES];
    playlistPicked = YES;
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        [[HostManager sharedHostManager] selectedNewPlaylist:mediaItemCollection];
        newPlaylistPicked = YES;
        [[HostManager sharedHostManager] setHostActive];
        if (playbackTimer == nil) {
            [self updateSongInfo];
            playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSongInfo) userInfo:nil repeats:YES];
            [[HostManager sharedHostManager] addDelegate:self];
        }
        
    } else {
        playlistPicked = NO;
    }
    
    [self dismissModalViewControllerAnimated: YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    trackName.text = nil;
    trackArtist.text = nil;
    trackAlbum.text = nil;
    trackTime.text = nil;
    newPlaylistPicked = NO;
    if ([[HostManager sharedHostManager] isHostActive] == false) {
        if (playbackTimer != nil) {
            [playbackTimer invalidate];
        }
        playbackTimer = nil;
//        trackName.text = nil;
//        trackArtist.text = nil;
//        trackAlbum.text = nil;
//        trackTime.text = nil;
        playlistPicked = NO;
    } else {
        playlistPicked = YES;
        if (playbackTimer == nil) {
            [self updateSongInfo];
            playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSongInfo) userInfo:nil repeats:YES];
            [[HostManager sharedHostManager] addDelegate:self];
        }

    }
}

-(void) viewWillAppear:(BOOL)animated {
//    NSLog(@"willappear");
    if (newPlaylistPicked) {
        [playlistTable reloadData];
        newPlaylistPicked = NO;
    }
}

-(void) viewDidAppear:(BOOL)animated {
    if (!playlistPicked) {
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
        
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = YES;
        mediaPicker.prompt = @"Select songs to play";
        
        [self presentModalViewController:mediaPicker animated:YES];
        playlistPicked = YES;
    }
//    NSLog(@"didappear");
    if ([[HostManager sharedHostManager] isHostActive]) {
        if (playbackTimer == nil) {
            [self updateSongInfo];
            playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSongInfo) userInfo:nil repeats:YES];
        }
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    if ([[HostManager sharedHostManager] isHostActive]) {
        if (playbackTimer != nil) {
            [playbackTimer invalidate];
            playbackTimer = nil;
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
//    playbackTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
