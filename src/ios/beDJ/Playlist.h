//
//  Playlist.h
//  beDJ
//
//  Created by Garrett Galow on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerDelegate.h"
#import "PlaylistDelegate.h"
#import "ServerRequestType.h"

@interface Playlist : NSObject <ServerDelegate> {
    
    NSMutableArray* songs;
//    NSMutableDictionary* songVotes;
    NSMutableArray* waitingInstances;
    NSInteger doneUpdating;
    NSNumber* userVotes;
    NSDictionary* nowPlaying;
    NSDate* lastUpdate;
    bool playlistUpdating;
    NSNumber* playlistID;
    
}

+(Playlist*) sharedPlaylist;

//Returns whether a new request was made 
-(void) addDelegate:(id<PlaylistDelegate>) sender;
-(void) removeDelegate:(id<PlaylistDelegate>) sender;
-(updateStatus) updatePlaylistDataWithSender:(id) sender;
-(void) castVote:(NSString*) SONG_id withVotes:(NSString*) voteCount withSender:(id) sender;
-(void) undoVote:(NSString*) SONG_id withVotes:(NSString*) voteCount withSender:(id) sender;
//-(void) clearPlaylist;

@property (readonly, nonatomic) NSMutableArray* songs;
//@property (readonly, nonatomic) NSMutableDictionary* songVotes;
@property (readonly, nonatomic) NSDictionary* nowPlaying;
@property (readonly, nonatomic) NSDate* lastUpdate;
@property (readonly, nonatomic) NSNumber* userVotes;

@end