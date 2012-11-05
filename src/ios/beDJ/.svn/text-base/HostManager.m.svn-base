//
//  HostManager.m
//  beDJ
//
//  Created by Garrett Galow on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HostManager.h"
#import "Server.h"
#import "HostManagerDelegate.h"
#import "MusicPlayerViewController.h"

@interface HostManager () {

    BOOL playlistUpdateWaiting;
    BOOL hostActive;
    
    NSMutableArray* delegates;
    
    id songEndingObserver;
    id songBeginningObserver;
    
    AVQueuePlayer* musicPlayerA;
    AVQueuePlayer* musicPlayerB;
    BOOL onPlayerA;

}

@end

@implementation HostManager

@synthesize hostInfo, playlistID, playlist, musicPlayer, nowPlaying, songFiles, delegates;

static HostManager* sharedInstance = nil;

#pragma mark - Singleton Methods

+(HostManager*) sharedHostManager {
    if(sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        songFiles = [[NSMutableDictionary alloc] initWithCapacity:1];
        playlistUpdateWaiting = NO;
        delegates = [NSMutableArray arrayWithCapacity:1];
        onPlayerA = YES;
        hostActive = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handle_NowPlayingItemChanged)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:musicPlayer];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    return self;
}

-(void) dealloc {
    if (songEndingObserver) {
        [musicPlayer removeTimeObserver:songEndingObserver];
    }
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedHostManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Instance Methods

-(BOOL)isHostActive {
    return hostActive;
}

-(void) setHostActive {
    hostActive = YES;
}

-(void) setHostInactive {
    hostActive = NO;
    [musicPlayer pause];
    musicPlayer = nil;
    playlist = nil;
    [updateTimer invalidate];
    updateTimer = nil;
    songFiles = nil;
    
    mediaCollection = nil;
    
    tempPlaylist = nil;;
    
    hostInfo = nil;
    
    playlistID = nil;
    
    nowPlaying = nil;
    nextPlaying = nil;
    
}

- (void) handle_NowPlayingItemChanged
{
//    NSURL* mediaItemUrl = [[songFiles valueForKey:[nextPlaying valueForKey:@"SONG_id"]] valueForProperty:MPMediaItemPropertyAssetURL];
//    AVPlayerItem *mediaItem = [AVPlayerItem playerItemWithURL:mediaItemUrl];

    [[Server sharedInstance] setNowPlayingwithSong:[nextPlaying valueForKey:@"SONG_id"] andHost:[hostInfo valueForKey:@"HOST_id"] withSender:self];
    
    nowPlaying = nextPlaying;
    nextPlaying = nil;
    
//    NSString* mediaItemSongID = [nowPlaying valueForKey:@"SONG_id"];
//    NSInteger songDuration = [[[songFiles valueForKey:mediaItemSongID] valueForProperty:MPMediaItemPropertyPlaybackDuration] integerValue];
//    NSInteger songDuration = (NSInteger)CMTimeGetSeconds([((AVPlayerItem*)[songFiles valueForKey:mediaItemSongID]) duration]);
    
//    [musicPlayer removeTimeObserver:songEndingObserver];
    
    //With fade in player
    
////    AVQueuePlayer* fadeInPlayer = [AVPlayer playerWithURL:mediaItemUrl];
//    AVQueuePlayer* fadeInPlayer = [AVQueuePlayer queuePlayerWithItems:[NSArray arrayWithObject:mediaItem]];
//    [fadeInPlayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
//    [fadeInPlayer play];
//    
//    onPlayerA ? (musicPlayerB = fadeInPlayer) : (musicPlayerA = fadeInPlayer);
//
//    songEndingObserver = [fadeInPlayer addBoundaryTimeObserverForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMake(songDuration-3, 1)]] queue:NULL usingBlock:
//                          ^() {
//                              [[HostManager sharedHostManager] handle_NowPlayingItemChanged];
//                          }];
//
//    musicPlayer = fadeInPlayer;
//
//    onPlayerA = !onPlayerA;
    
    //without fade in player
    
//    songEndingObserver = [musicPlayer addBoundaryTimeObserverForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMake(songDuration-3, 1)]] queue:NULL usingBlock:
//                          ^() {
//                              [[HostManager sharedHostManager] handle_NowPlayingItemChanged];
//                          }];
    
    //with either
    for (id <HostManagerDelegate> delegate in delegates) {
        [delegate nowPlayingItemChanged];
    }

}

-(void) nextSong {
    [self updatePlaylist];
    [self handle_NowPlayingItemChanged];
    [musicPlayerA advanceToNextItem];
}

-(void)selectedNewPlaylist:(MPMediaItemCollection *)playlistFiles {
    
    NSMutableArray* tempSongFiles = [NSMutableArray arrayWithCapacity:25];
    
    tempPlaylist = [NSMutableArray arrayWithCapacity:1];
    NSArray* mediaArray = [playlistFiles items];
    
    for (MPMediaItem* mediaItem in mediaArray) {
        if (![tempSongFiles containsObject:mediaItem]) {
            [tempSongFiles addObject:mediaItem];
        }
    }
    
    mediaCollection = [MPMediaItemCollection collectionWithItems:tempSongFiles];
    
    for (MPMediaItem* mediaItem in tempSongFiles) {
        
        NSString* name = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
        NSString* artist = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
        NSString* album = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        NSString* genre = [mediaItem valueForProperty:MPMediaItemPropertyGenre];
        NSNumber* duration = [mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
        
        name = ((name == @"") || (name == nil)) ? @"Unknown" : name;
        artist = ((artist == @"") || (artist == nil)) ? @"Unknown" : artist;
        album = ((album == @"") || (album == nil)) ? @"Unknown" : album;
        genre = ((genre == @"") || (genre == nil)) ? @"Unknown" : genre;
        duration = (duration == nil) ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:[duration intValue]];
        
        NSMutableDictionary* song = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:name, artist, album, genre, duration, nil] forKeys:[NSArray arrayWithObjects:@"name",@"artist",@"album",@"genre",@"duration", nil]];
        
        [tempPlaylist addObject:song];
        
    }
//    NSLog(@"NEW PLAYLIST!");
    playlist = tempPlaylist;
    [[Server sharedInstance] createPlaylist:tempPlaylist forHost:[hostInfo valueForKey:@"HOST_id"] withSender:self];
}

-(void) createSongFilesMatching:(NSArray*) songIDs {
    songFiles = [NSMutableDictionary dictionaryWithCapacity:1];
    NSArray* mediaFileArray = [mediaCollection items];
    for (int i = 0; i < [mediaFileArray count]; i++) {
//        NSLog(@"2");
        NSString* songID = [[songIDs objectAtIndex:i] stringValue];
        
//        NSURL* songURL = [[mediaFileArray objectAtIndex:i] valueForProperty:MPMediaItemPropertyAssetURL];
//        AVPlayerItem* song = [AVPlayerItem playerItemWithURL:songURL];
//        [songFiles setValue:song forKey:songID];
//        NSLog(@"3");
        [songFiles setValue:[mediaFileArray objectAtIndex:i] forKey:songID];
//        NSLog(@"4");
        [[playlist objectAtIndex:i] setValue:songID forKey:@"SONG_id"];
    }
}

-(void) updatePlaylist {
    if ((playlistUpdateWaiting == NO) && (hostActive)) {
        [[Server sharedInstance] getPlaylistForHost:[hostInfo valueForKey:@"HOST_id"] andPlaylist:playlistID andUser:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"] withSender:self];
        playlistUpdateWaiting = YES;
    }
}

-(void) addDelegate:(id)sender {
    if (![delegates containsObject:sender]) {
        [delegates addObject:sender];
    }
}

-(void) removeDelegate:(id)sender {
    if ([delegates containsObject:sender]) {
        [delegates removeObject:sender];
    }
}

#pragma mark - Server Delegate Methods

- (void) serverResponse:(NSMutableDictionary*) responseData forRequest:(ServerRequestType) requestType {
    if (hostActive) {
    switch (requestType) {
        case CreatePlaylist:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                
                NSArray* songIDs = [[responseData valueForKey:@"Data"] valueForKey:@"SONG_ids"];
                
                playlistID = [[responseData valueForKey:@"Data"] valueForKey:@"PLAYLIST_id"];
                
                [self updatePlaylist];
                if (updateTimer == nil) {
                    updateTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updatePlaylist) userInfo:nil repeats:YES];
                }
                
                [[Server sharedInstance] choosePlaylist:[playlistID stringValue] forHost:[hostInfo valueForKey:@"HOST_id"] withSender:self];
//                NSLog(@"5");
                [[Server sharedInstance] setNowPlayingwithSong:[[songIDs objectAtIndex:0] stringValue] andHost:[hostInfo valueForKey:@"HOST_id"] withSender:self];
                
                [self createSongFilesMatching:songIDs];
//                NSLog(@"6");
                nowPlaying = [playlist objectAtIndex:0];
                for (id <HostManagerDelegate> delegate in delegates) {
                    [delegate nowPlayingItemChanged];
                }
//                NSLog(@"7");
                NSString* mediaItemSongID = [[songIDs objectAtIndex:0] stringValue];
                NSURL* mediaItemURL = [[songFiles valueForKey:mediaItemSongID] valueForProperty:MPMediaItemPropertyAssetURL];
                AVPlayerItem* mediaItem = [AVPlayerItem playerItemWithURL:mediaItemURL];
//                musicPlayerA = [AVQueuePlayer playerWithPlayerItem:mediaItem];
                musicPlayerA = [AVQueuePlayer queuePlayerWithItems:[NSArray arrayWithObject:mediaItem]];
                [musicPlayerA setActionAtItemEnd:AVPlayerActionAtItemEndAdvance];
                musicPlayer = musicPlayerA;
                
//                NSInteger songDuration = [[[songFiles valueForKey:mediaItemSongID] valueForProperty:MPMediaItemPropertyPlaybackDuration] integerValue];
//                NSInteger songDuration = (NSInteger)CMTimeGetSeconds([((AVPlayerItem*)[songFiles valueForKey:mediaItemSongID]) duration]);
                
//                songEndingObserver = [musicPlayer addBoundaryTimeObserverForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMake(songDuration-3, 1)]] queue:NULL usingBlock:
//                    ^() {
//                        [[HostManager sharedHostManager] handle_NowPlayingItemChanged];
//                    }];
//                
//                for (MusicPlayerViewController* delegate in delegates) {
//                    [delegate nowPlayingItemChanged];
//                }
                
                [musicPlayer play];
            }
            break;
            
        case PlaylistUpdate:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                NSDictionary* data = [responseData valueForKey:@"Data"];
                if (([data valueForKey:@"songs"] != nil) && (![[data valueForKey:@"songs"] isKindOfClass:[NSNull class]])) {
                        if ([data valueForKey:@"PLAYLIST_id"] == NULL) {
                            if (([data valueForKey:@"songs"] != nil) && (![[data valueForKey:@"songs"] isKindOfClass:[NSNull class]])) {
                                NSMutableArray* tempSongs = [data valueForKey:@"songs"];
                                for (NSMutableDictionary* song in tempSongs) {
                                    for (NSDictionary* staticSong in playlist) {
                                        if ([[song valueForKey:@"SONG_id"] isEqual:[staticSong valueForKey:@"SONG_id"]]) {
                                            [song setValue:[staticSong valueForKey:@"name"] forKey:@"name"];
                                            [song setValue:[staticSong valueForKey:@"artist"] forKey:@"artist"];
                                            [song setValue:[staticSong valueForKey:@"album"] forKey:@"album"];
                                            [song setValue:[staticSong valueForKey:@"genre"] forKey:@"genre"];
                                            [song setValue:[staticSong valueForKey:@"duration"] forKey:@"duration"];
                                        }
                                    }
                                }
                                playlist = tempSongs;
                            }
                            
                        } else {
                            //get playlistID
                            playlistID = [data valueForKey:@"PLAYLIST_id"];
                            if (([data valueForKey:@"songs"] != nil) && (![[data valueForKey:@"songs"] isKindOfClass:[NSNull class]])) {
                                playlist = [data valueForKey:@"songs"];
                            }
                        }
//                    NSLog([playlist description]);
                    for (id <HostManagerDelegate> delegate in delegates) {
                        [delegate hostPlaylistUpdated];
                    }
                    playlistUpdateWaiting = NO;
//                    NSLog(@"8");
                    nextPlaying = [playlist objectAtIndex:0];
                    AVPlayerItem* nextSong = [AVPlayerItem playerItemWithURL:[[songFiles valueForKey:[nextPlaying valueForKey:@"SONG_id"]] valueForProperty:MPMediaItemPropertyAssetURL]];
                    if ([[musicPlayerA items] count] > 1) {
//                        NSLog(@"9");
                        if (![nextSong isEqual:[[musicPlayerA items] objectAtIndex:1]]) {
//                            NSLog(@"10");
                            [musicPlayerA insertItem:nextSong afterItem:[[musicPlayerA items] objectAtIndex:0]];
//                            NSLog(@"11");
                            [musicPlayerA removeItem:[[musicPlayerA items] objectAtIndex:2]];
                        }
                    } else {
//                        NSLog(@"12");
                        [musicPlayerA insertItem:nextSong afterItem:[[musicPlayerA items] objectAtIndex:0]];
                    }
                }
            } else {
                playlistUpdateWaiting = NO;
            }
            break;
            
        case ChoosePlaylist:
            
            break;
            
        case SetNowPlaying:    
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                
            }
            break;
            
        case ManagerHostDisconnect:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                hostInfo = nil;
            }
            break;
        default:
            break;
    }
    }
}

@end
