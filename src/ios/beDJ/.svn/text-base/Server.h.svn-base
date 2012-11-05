//
//  Server.h
//  QuTrack
//
// Anyone that calls functions in the server class must implement the following function
//
// -(void) serverResponse:(NSMutableDictionary*) responseData forRequest:(ServerRequestType) type
//
//
//  Created by Garrett Galow on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject <NSURLConnectionDelegate> {
    
//    NSMutableData* tempData;
    
    /*
        outstanding connections is a mapping of the address' of NSURLConnection objects as the keys to NSArray's that contains the following values.
     index 0 - the type of request as a NSNumber
     1 - the instance that made the request (the delegate)
     2 - the request data in case the connection has an issue and has to be retried
     3 - a data object that stores the data returned by the NSURLConnection
     */
    NSMutableDictionary* outstandingConnections;
    
}

+(id) sharedInstance;

#pragma mark - In Progress

//+(void) createHostwithSender:(id)sender;

//+(void) playSongwithSender:(id)sender;

-(void) editUserInfowithSender:(id)sender;

//+(void) addUserHostwithSender:(id)sender;

#pragma mark - Host Calls

-(void) getAllHostNamesForUser:(NSString*) USER_id withSender:(id) sender;

-(void) userHostConnectForUser:(NSString*) USER_id andHost:(NSString*) HOST_id withSender:(id) sender;

-(void) userHostDisconnectforUser:(NSString*) USER_id Host:(NSString*) HOST_id withSender:(id) sender;

-(void) createPlaylist:(NSArray*) playlist forHost:(NSNumber*) HOST_id withSender:(id) sender;

-(void) setNowPlayingwithSong:(NSString*) SONG_id andHost:(NSString*) HOST_id withSender:(id) sender;

-(void) choosePlaylist:(NSString*) PLAYLIST_id forHost:(NSString*) HOST_id withSender:(id) sender;

-(void) createHostWithName:(NSString*) name address:(NSString*) address description:(NSString*) description xPos:(NSNumber*) xPos yPos:(NSNumber*) yPos type:(NSString*) hostType userID:(NSString*) USER_id withSender:(id) sender;

-(void) editHostInfoWithName:(NSString*) name address:(NSString*) address description:(NSString*) description xPos:(NSNumber*) xPos yPos:(NSNumber*) yPos type:(NSString*) hostType userID:(NSString*) USER_id hostID:(NSString*) HOST_id withSender:(id) sender;

-(void) connectHost:(NSString*) HOST_id withSender:(id) sender;

-(void) disconnectHost:(NSString*) HOST_id withSender:(id) sender;

#pragma mark - Guest/User Calls

//Final (i.e. must be contained here as the structure currently stands)
-(void) loginwithUsername:(NSString*) user andPassword:(NSString*) pass withSender:(id) sender;

-(void) createAccount:(NSString*) user andPassword:(NSString*) pass andEmail:(NSString*) email withSender:(id) sender;

-(void) getHostswithSender:(id) sender;

-(void) getPlaylistForHost:(NSString*) HOST_id andPlaylist:(NSNumber*) PLAYLIST_id andUser:(NSString*) USER_id withSender:(id) sender;

//-(void) getPlaylistVotesForHost:(NSString*) HOST_id withSender:(id) sender;

-(void) UserCastVoteforSong:(NSString*) SONG_id fromUser:(NSString*) USER_id atHost:(NSString*) HOST_id withVoteCount:(NSString*) voteCount withSender:(id) sender;

-(void) UndoVoteforSong:(NSString*) SONG_id fromUser:(NSString*) USER_id atHost:(NSString*) HOST_id withVoteCount:(NSString*) voteCount withSender:(id) sender;

-(void) getVoteCountForHost:(NSString*) HOST_id ofUser:(NSString*) USER_id withSender:(id) sender;

-(void) getHostVotesForUserWithSender:(id) sender;

-(void) joinLocationForHost:(NSString*) HOST_id andUser:(NSString*) USER_id withSender:(id)sender;

-(void) leaveLocationForHost:(NSString*) HOST_id User:(NSString*) USER_id withSender:(id) sender;

//-(void) getNowPLayingForHost:(NSString*) hostID withSender:(id) sender;

-(void) allocateVotesForHost:(NSString*) HOST_id andUser:(NSString*) USER_id withSender:(id) sender;

-(void) syncInfoForHost:(NSString*) HOST_id user:(NSString*) USER_id sender:(id) sender;




@end
