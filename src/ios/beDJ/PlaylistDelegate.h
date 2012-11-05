//
//  PlaylistDelegate.h
//  beDJ
//
//  Created by Garrett Galow on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Differentiates the status of the playlistUpdate reuqest
//Either a new request was made - 1
//A request the caller made is still being processed - 0
//A request being processed was initiated by another instant - 2

//selfMadeRequest is 0 so that a bool check can be made to see if another operation is considered started
//typedef enum playlistUpdateStatus {
//    newRequest = 1,
//    selfMadeRequest = 0,
//    otherMadeRequest = 2,
//    } playlistUpdateStatus;

@protocol PlaylistDelegate <NSObject>

@required

-(void) playlistUpdated;
-(void) automatedPlaylistUpdated;

@end
