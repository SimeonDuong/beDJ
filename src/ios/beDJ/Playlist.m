//
//  Playlist.m
//  beDJ
//
//  Created by Garrett Galow on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Playlist.h"
#import "Server.h"
#import "Venues.h"
#import "PlaylistDelegate.h"
#import "UserData.h"

#define kInitialRate 5
#define kMaxRate 15
#define kMinRate 3
#define kRateIncreaseMultiplier .2
#define KRateDecreaseMultiplier .5

@interface Playlist () {
    NSTimeInterval timerRate;
//    NSTimer* playlistUpdateTimer;
    NSMutableArray* delegates;
}

@end

@implementation Playlist

static Playlist* sharedInstance = nil;
NSInteger operationsWaiting = 2; 

@synthesize songs, nowPlaying, lastUpdate, userVotes;
//@synthesize songVotes;

#pragma mark Singleton Methods

+(Playlist*) sharedPlaylist {
    if(sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        if (songs == nil) {
            songs = [[NSMutableArray alloc] init];
//            songVotes = [[NSMutableDictionary alloc] init];
            waitingInstances = [[NSMutableArray alloc] init];
            playlistUpdating = false;
            lastUpdate = [NSDate dateWithTimeIntervalSince1970:0];
            playlistID = [NSNumber numberWithInt:0];
            doneUpdating = 0;
            userVotes = [NSNumber numberWithInt:0];
            timerRate = kInitialRate;
            delegates = [NSMutableArray arrayWithCapacity:2];
        }
    }
    
    return self;
}

+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedPlaylist];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark Playlist Methods

-(void) addDelegate:(id<PlaylistDelegate>) sender {
    [delegates addObject:sender];
}

-(void) removeDelegate:(id<PlaylistDelegate>) sender {
    [delegates removeObject:sender];
}

//-(void) clearPlaylist {
//    songs = [[NSMutableArray alloc] init];
//    nowPlaying = nil;
//}

-(NSTimeInterval) calculateNewTimerRate:(NSTimeInterval) oldRate updated:(BOOL) didPlaylistChange {
    NSTimeInterval tempNewRate;
    if (didPlaylistChange) {
        //reduce timer rate
        tempNewRate = oldRate * (1.0 - KRateDecreaseMultiplier);
        return MAX(tempNewRate, kMinRate);
    } else {
        //increase timer rate
        tempNewRate = oldRate * (1.0 + kRateIncreaseMultiplier);
        return MIN(tempNewRate, kMaxRate);
    }
//    NSLog(@"HI");
}

//Internal playlist updater
-(void) updatePlaylist {
    NSString* currentVenue = [[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"];
    NSString* userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"];
    [[Server sharedInstance] getPlaylistForHost:currentVenue andPlaylist:playlistID andUser:userID withSender:self];
    [[Server sharedInstance] getVoteCountForHost:currentVenue ofUser:userID withSender:self];
//    [[Server sharedInstance] syncInfoForHost:currentVenue user:userID sender:self];
    playlistUpdating = TRUE;
}

-(updateStatus) updatePlaylistDataWithSender:(id)sender {
    updateStatus status;
    //Check if an update is currently happening
    //if not then start an update
    //if so then just add this sender to the waiting list
    if (!playlistUpdating) {
        
        [self updatePlaylist];
        
        [waitingInstances addObject:sender];
        status = newRequest;
    } else {
        status = selfMadeRequest;
        if (![waitingInstances containsObject:sender]) {
            [waitingInstances addObject:sender];
            status = otherMadeRequest;
        }
    }
    playlistUpdating = true;
    return status;
    
}

-(void) castVote:(NSString*) SONG_id withVotes:(NSString *)voteCount withSender:(id)sender {
    NSString* currentVenue = [[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"];
    [[Server sharedInstance] UserCastVoteforSong:SONG_id fromUser:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"] atHost:currentVenue withVoteCount:voteCount withSender:self];
    [waitingInstances addObject:sender];
    operationsWaiting = 3;
}

-(void) undoVote:(NSString*) SONG_id withVotes:(NSString *)voteCount withSender:(id)sender {
    NSString* currentVenue = [[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"];
    [[Server sharedInstance] UndoVoteforSong:SONG_id fromUser:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"] atHost:currentVenue withVoteCount:voteCount withSender:self];
    [waitingInstances addObject:sender];
    operationsWaiting = 3;
}

#pragma mark Server Delegate Methods

/*
 
So at some point make playlist update
 
*/

-(void) serverResponse:(NSMutableDictionary *)responseData forRequest:(ServerRequestType)requestType {
    switch (requestType) {
        case SyncInfo:
            break;
        case PlaylistUpdate:
            //do something
            lastUpdate = [NSDate date];
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                NSDictionary* data = [responseData valueForKey:@"Data"];
                //get song data if there otherwise song stays the same

                BOOL didPlaylistChange;
                //if playlistID is there then new playlist otherwise just vote update
                if ([data valueForKey:@"PLAYLIST_id"] == NULL) {
                    if (([data valueForKey:@"songs"] != nil) && (![[data valueForKey:@"songs"] isKindOfClass:[NSNull class]])) {
                        NSMutableArray* tempSongs = [data valueForKey:@"songs"];
                        for (NSMutableDictionary* song in tempSongs) {
                            for (NSDictionary* staticSong in songs) {
                                if ([[song valueForKey:@"SONG_id"] isEqual:[staticSong valueForKey:@"SONG_id"]]) {
                                    [song setValue:[staticSong valueForKey:@"name"] forKey:@"name"];
                                    [song setValue:[staticSong valueForKey:@"artist"] forKey:@"artist"];
                                    [song setValue:[staticSong valueForKey:@"album"] forKey:@"album"];
                                    [song setValue:[staticSong valueForKey:@"genre"] forKey:@"genre"];
                                    [song setValue:[staticSong valueForKey:@"duration"] forKey:@"duration"];
                                }
                            }
                        }
                        didPlaylistChange = ![songs isEqualToArray:tempSongs];
                        songs = tempSongs;
                    }
                     
                } else {
                    //get playlistID
                    playlistID = [data valueForKey:@"PLAYLIST_id"];
                    if (([data valueForKey:@"songs"] != nil) && (![[data valueForKey:@"songs"] isKindOfClass:[NSNull class]])) {
                        didPlaylistChange = ![songs isEqualToArray:[data valueForKey:@"songs"]];
                        songs = [data valueForKey:@"songs"];
                    }
                }
                
                //This code sets timer rate and does updates
//                timerRate = [self calculateNewTimerRate:timerRate updated:didPlaylistChange];
//                NSLog(@"%f",timerRate);
////                //Now that the new rate is set we need to reset the NSTimer
//                [playlistUpdateTimer invalidate];
//                playlistUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:timerRate target:self selector:@selector(updatePlaylist) userInfo:nil repeats:NO];                
                
                for (id <PlaylistDelegate> delegate in delegates) {
                    [delegate automatedPlaylistUpdated];
                }
                
                //set now playing
                NSNumber* nowplayingID = [data valueForKey:@"nowplaying"];
                if ([nowplayingID intValue] == 0) {
                    nowPlaying = nil;
                } else {
                    for (NSDictionary* dict in songs) {
                        if ([[dict valueForKey:@"SONG_id"] isEqualToString:[nowplayingID stringValue]]) {
                            nowPlaying = dict;
                            break;
                        }
                    }
                }
                
                
            } else {
                //error
            }
            doneUpdating += 1;
            break;
            
        case VoteCount:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                //do something
                userVotes = [[responseData valueForKey:@"Data"] valueForKey:@"votes"];
                for (id <PlaylistDelegate> delegate in delegates) {
                    [delegate automatedPlaylistUpdated];
                }
                
            } else {
                //do something
//                userVotes = 0;
            }
            doneUpdating += 1;
            break;
            
        case CastVote:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                //do something
                doneUpdating += 1;
                //update the playlist
                lastUpdate = [NSDate date];
                NSString* currentVenue = [[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"];
                NSString* userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"];
                [[Server sharedInstance] getPlaylistForHost:currentVenue andPlaylist:playlistID andUser:userID withSender:self];
                [[Server sharedInstance] getVoteCountForHost:currentVenue ofUser:userID withSender:self];
                
            } else {
                //do something
                doneUpdating += 1;
                //update the playlist
                lastUpdate = [NSDate date];
                NSString* currentVenue = [[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"];
                NSString* userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"];
                [[Server sharedInstance] getPlaylistForHost:currentVenue andPlaylist:playlistID andUser:userID withSender:self];
                [[Server sharedInstance] getVoteCountForHost:currentVenue ofUser:userID withSender:self];
            }
            break;
            
        case UndoVote:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                //do something
                doneUpdating += 1;
                //update the playlist
                lastUpdate = [NSDate date];
                NSString* currentVenue = [[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"];
                NSString* userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"];
                [[Server sharedInstance] getPlaylistForHost:currentVenue andPlaylist:playlistID andUser:userID withSender:self];
                [[Server sharedInstance] getVoteCountForHost:currentVenue ofUser:userID withSender:self];
            } else {
                //do something
                doneUpdating += 1;
                //update the playlist
                lastUpdate = [NSDate date];
                NSString* currentVenue = [[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"];
                NSString* userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"];
                [[Server sharedInstance] getPlaylistForHost:currentVenue andPlaylist:playlistID andUser:userID withSender:self];
                [[Server sharedInstance] getVoteCountForHost:currentVenue ofUser:userID withSender:self];
            }
            break;
            
        case AllocateVotes:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                //do something
                
            } else {
                //do something
            }
            break;
            
        default:
            break;
    }
    
    if (doneUpdating == operationsWaiting) {
        
        for (id receiver in waitingInstances) {
            [receiver playlistUpdated];
        }
        
        [waitingInstances removeAllObjects];
        
        playlistUpdating = false;
        doneUpdating = 0;
        operationsWaiting = 2;
    }
    
}

@end
