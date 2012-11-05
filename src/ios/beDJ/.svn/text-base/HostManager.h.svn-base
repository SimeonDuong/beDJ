//
//  HostManager.h
//  beDJ
//
//  Created by Garrett Galow on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPLayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ServerDelegate.h"

@interface HostManager : NSObject <ServerDelegate> {
    
    //Contains song info for the playlist
    NSArray* playlist;
    
    //Matches a songID to a MPMediaItem
    NSMutableDictionary* songFiles;
    
    MPMediaItemCollection* mediaCollection;
    
    NSMutableArray* tempPlaylist;
    
    //Contains details about the host such as name, description, lat, long...
    NSMutableDictionary* hostInfo;
    
    NSNumber* playlistID;
    
    //Contains info on the nowPlaying item
    NSDictionary* nowPlaying;
    //Contains info on the nextPlaying item
    NSDictionary* nextPlaying;
    
    //The music player
    AVPlayer* musicPlayer;
    
    //Update timer for refreshing the playlist
    NSTimer* updateTimer;
    
}

@property (retain, nonatomic) NSMutableDictionary* hostInfo;
@property (retain, readonly, nonatomic) NSNumber* playlistID;
@property (retain, readonly, nonatomic) NSArray* playlist;
@property (retain, readonly, nonatomic) AVPlayer* musicPlayer;
@property (retain, readonly, nonatomic) NSDictionary* nowPlaying;
@property (retain, readonly, nonatomic) NSMutableDictionary* songFiles;
@property (retain, readonly, nonatomic) NSMutableArray* delegates;

+(HostManager*) sharedHostManager;

-(void) selectedNewPlaylist:(MPMediaItemCollection*) playlistFiles;
-(BOOL) isHostActive;
-(void) setHostActive;
-(void) setHostInactive;
-(void) addDelegate:(id) sender;
-(void) removeDelegate:(id) sender;

-(void) nextSong;

@end
