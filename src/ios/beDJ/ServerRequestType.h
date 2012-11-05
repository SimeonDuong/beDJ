//
//  ServerRequestType.h
//  beDJ
//
//  Created by Garrett Galow on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef beDJ_ServerRequestType_h
#define beDJ_ServerRequestType_h

typedef enum {
    Login,
    CreateAccount,
    EditInfo,
    
    PlaylistUpdate,
    PlaylistVotes,
    CastVote,
    UndoVote,
    VoteCount,
    
    GetHosts,
    GetHostVotes,
    JoinLocation,
    LeaveLocation,
    
    NowPlaying,
    
    CreatePlaylist,
    AllocateVotes,
    
    SetNowPlaying,
    GetAllHostNamesForUser,
    ManagerHostConnect,
    ManagerHostDisconnect,
    ChoosePlaylist,
    CreateHost,
    EditHostInfo,
    SyncInfo,
    
}ServerRequestType;

//Differentiates the status of the Update reuqest
//Either a new request was made - 1
//A request the caller made is still being processed - 0
//A request being processed was initiated by another instant - 2

//selfMadeRequest is 0 so that a bool check can be made to see if another operation is considered started

typedef enum updateStatus {
    newRequest = 1,
    selfMadeRequest = 0,
    otherMadeRequest = 2,
} updateStatus;

#endif
