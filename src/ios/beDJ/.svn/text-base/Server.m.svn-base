//
//  Server.m
//  QuTrack
//
//  Created by Garrett Galow on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Server.h"
#import "SecondViewController.h"
#import "ServerRequestType.h"
#import "ServerDelegate.h"
#import "UserData.h"

#import "AFNetworking.h"

@implementation Server

static Server* sharedInstance = nil;

#pragma mark Singleton Methods

+(Server*) sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        if (outstandingConnections == nil) {
            outstandingConnections = [[NSMutableDictionary alloc] init];
        }
    }
    
    return self;
}

+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark Server Request

-(NSURLConnection*) serverRequest:(NSString*) requestPage withDictionary:(NSMutableDictionary*) requestDictionary {
    
    NSError* Error;
    NSData* requestData;
    if (requestDictionary == nil) {
        requestDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    [requestDictionary setValue:[NSString stringWithFormat:@"%@ b%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] forKey:@"Version"];
    [requestDictionary setValue:[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]] forKey:@"Platform"];
    requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:!NSJSONWritingPrettyPrinted error:&Error];
//    NSLog([[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);
    NSString* urlString = [NSString stringWithFormat:@"http://www.questionforanswer.com/%@",requestPage];
    
    //Create HTTP Post
    NSMutableURLRequest* serverRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [serverRequest setHTTPMethod:@"POST"];
    [serverRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serverRequest setHTTPBody:requestData];
    
    return [NSURLConnection connectionWithRequest:serverRequest delegate:self];
    
//    NSURL* urlString = [NSURL URLWithString:@"http://www.questionforanswer.com/"];
//    
//    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
//    
//    NSMutableURLRequest* serverRequest = [httpClient requestWithMethod:@"POST" path:requestPage parameters:requestDictionary];
//    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:serverRequest success:
//        ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//            
//            NSMutableArray* connectionArray = [outstandingConnections valueForKey:[request description]];
//            
//            NSLog(@"%@",[JSON description]);    
//            
//            id sender = [connectionArray objectAtIndex:1];
//            ServerRequestType requestType = [[connectionArray objectAtIndex:0] intValue];
//            
//            [sender serverResponse:JSON forRequest:requestType];
//            
//            [outstandingConnections removeObjectForKey:[request description]];
//            
//        } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON){
//            NSLog(@"%@\n%@\n%@",[request description], [response description], [error description]);
//        }];
//    
//    [operation start];
//    
//    return serverRequest;
}

#pragma mark Server Call Functions

-(void) getPlaylistForHost:(NSString*) HOST_id andPlaylist:(NSNumber*) PLAYLIST_id andUser:(NSString *)USER_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:HOST_id, @"HOST_id",[PLAYLIST_id stringValue],@"PLAYLIST_id", USER_id, @"USER_id", nil];
        
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:PlaylistUpdate], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"GetPlaylist.php" withDictionary:requestData] description]];
    
}

-(void) loginwithUsername:(NSString *)user andPassword:(NSString *)pass withSender:(id)sender {
    
    //Create JSON NSData Object with login data and UNIQUE_id to upvote
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:user, @"user_name", pass, @"password", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:Login], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"Login.php" withDictionary:requestData] description]];
}

//-(void) getPlaylistVotesForHost:(NSString*) HOST_id withSender:(id) sender {
//    
//    //Create JSON NSData Object
//    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:HOST_id, @"HOST_id", nil];
//    
//    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:PlaylistVotes], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"GetPlaylistVotesForHost.php" withDictionary:requestData] description]];
//}

-(void) getVoteCountForHost:(NSString*) HOST_id ofUser:(NSString*) USER_id withSender:(id) sender {
    
    //Create JSON NSData Object
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:USER_id, @"USER_id", HOST_id, @"HOST_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:VoteCount], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"GetVoteCount.php" withDictionary:requestData] description]];
}

-(void) UserCastVoteforSong:(NSString*) SONG_id fromUser:(NSString*) USER_id atHost:(NSString*) HOST_id withVoteCount:(NSString*) voteCount withSender:(id) sender {
    
    //Create JSON NSData Object
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:SONG_id, @"SONG_id", USER_id, @"USER_id", HOST_id, @"HOST_id", voteCount, @"votes", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:CastVote], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"CastVote.php" withDictionary:requestData] description]];
}

-(void) UndoVoteforSong:(NSString*) SONG_id fromUser:(NSString*) USER_id atHost:(NSString*) HOST_id withVoteCount:(NSString*) voteCount withSender:(id) sender {
    
    //Create JSON NSData Object
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:SONG_id, @"SONG_id", USER_id, @"USER_id", HOST_id, @"HOST_id", voteCount, @"votes", nil];

    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:UndoVote], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"RemoveVote.php" withDictionary:requestData] description]];
}

-(void) createAccount:(NSString*) user andPassword:(NSString*) pass andEmail:(NSString *)email withSender:(id)sender {
    
    //Create JSON NSData Object with login data and UNIQUE_id to upvote
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:user, @"user_name", pass, @"password", email,@"email", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:CreateAccount], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"CreateUser.php" withDictionary:requestData] description]];
}

-(void) getHostswithSender:(id) sender {
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:GetHosts], sender, [NSDictionary dictionary], [NSMutableData data], nil] forKey:[[self serverRequest:@"GetHosts.php" withDictionary:nil] description]];
}

-(void) joinLocationForHost:(NSString*) HOST_id andUser:(NSString*) USER_id withSender:(id)sender {
    
    //Create JSON NSData Object with login data and UNIQUE_id to upvote
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:HOST_id, @"HOST_id", USER_id, @"USER_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:JoinLocation], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"UserHostConnect.php" withDictionary:requestData] description]];
}

-(void) leaveLocationForHost:(NSString *)HOST_id User:(NSString *)USER_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:HOST_id, @"HOST_id", USER_id, @"USER_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:LeaveLocation], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"UserHostDisconnect.php" withDictionary:requestData] description]];
}

-(void) editUserInfowithSender:(id)sender {
    
    //Create JSON NSData Object with login data and UNIQUE_id to upvote
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"galow1", @"current_password", @"galow2", @"password", @"fuq_u_biq@buklau.com", @"email",@"1", @"USER_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:EditInfo], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"EditUserInfo.php" withDictionary:requestData] description]];
}

-(void) getHostVotesForUserWithSender:(id) sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"], @"USER_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:GetHostVotes], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"GetUserVotesForAllHosts.php" withDictionary:requestData] description]];
}

//-(void) getNowPLayingForHost:(NSString*) hostID withSender:(id) sender {
//    
//    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:hostID, @"HOST_id", nil];
//    
//    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:NowPlaying], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"NowPlaying.php" withDictionary:requestData] description]];
//}

-(void) allocateVotesForHost:(NSString*) HOST_id andUser:(NSString*) USER_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:USER_id, @"USER_id", HOST_id, @"HOST_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:AllocateVotes], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"AllocateVotes.php" withDictionary:requestData] description]];
}

-(void) getAllHostNamesForUser:(NSString *)USER_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:USER_id, @"USER_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:GetAllHostNamesForUser], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"GetAllHostNamesForUser.php" withDictionary:requestData] description]];
}

-(void) userHostConnectForUser:(NSString *)USER_id andHost:(NSString *)HOST_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:USER_id, @"USER_id", HOST_id, @"HOST_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:ManagerHostConnect], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"ManagerHostConnect.php" withDictionary:requestData] description]];
}

-(void) userHostDisconnectforUser:(NSString *)USER_id Host:(NSString *)HOST_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:USER_id, @"USER_id", HOST_id, @"HOST_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:ManagerHostDisconnect], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"ManagerHostDisconnect.php" withDictionary:requestData] description]];
}

-(void) createPlaylist:(NSArray*) playlist forHost:(NSNumber*)HOST_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [[NSMutableDictionary alloc] init];
    [requestData setValue:playlist forKey:@"songs"];
    [requestData setValue:HOST_id forKey:@"HOST_id"];
    [requestData setValue:@"iOS Playlist" forKey:@"name"];
    [requestData setValue:@"Hell no" forKey:@"description"];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:CreatePlaylist], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"CreatePlaylist.php" withDictionary:requestData] description]];
}

-(void) setNowPlayingwithSong:(NSString*) SONG_id andHost:(NSString*) HOST_id withSender:(id) sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:SONG_id, @"SONG_id", HOST_id, @"HOST_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:SetNowPlaying], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"SetNowPlaying.php" withDictionary:requestData] description]];
}

-(void) choosePlaylist:(NSString*) PLAYLIST_id forHost:(NSString*) HOST_id withSender:(id) sender {

    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:PLAYLIST_id, @"PLAYLIST_id", HOST_id, @"HOST_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:ChoosePlaylist], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"ChoosePlaylist.php" withDictionary:requestData] description]];
}

-(void) createHostWithName:(NSString *)name address:(NSString *)address description:(NSString *)description xPos:(NSNumber*)xPos yPos:(NSNumber*)yPos type:(NSString *)hostType userID:(NSString *)USER_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", address, @"address", description, @"description", xPos, @"position_x", yPos, @"position_y", hostType, @"host_type", USER_id, @"USER_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:CreateHost], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"CreateHost.php" withDictionary:requestData] description]];
}

-(void) editHostInfoWithName:(NSString *)name address:(NSString *)address description:(NSString *)description xPos:(NSNumber*)xPos yPos:(NSNumber*)yPos type:(NSString *)hostType userID:(NSString *)USER_id hostID:(NSString *)HOST_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", address, @"address", description, @"description", xPos, @"position_x", yPos, @"position_y", hostType, @"host_type", USER_id, @"USER_id", HOST_id, @"HOST_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:EditHostInfo], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"EditHostInfo.php" withDictionary:requestData] description]];
}

-(void)connectHost:(NSString *)HOST_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:HOST_id, @"HOST_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:ManagerHostConnect], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"ConnectHost.php" withDictionary:requestData] description]];
}

-(void)disconnectHost:(NSString *)HOST_id withSender:(id)sender {
    
    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:HOST_id, @"HOST_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:ManagerHostDisconnect], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"DisconnectHost.php" withDictionary:requestData] description]];
}

-(void) syncInfoForHost:(NSString*) HOST_id user:(NSString*) USER_id sender:(id) sender {

    NSMutableDictionary* requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:HOST_id, @"HOST_id", USER_id, @"USER_id", nil];
    
    [outstandingConnections setValue:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:SyncInfo], sender, requestData, [NSMutableData data], nil] forKey:[[self serverRequest:@"SyncInfo.php" withDictionary:requestData] description]];
}

#pragma mark Connection Delegate Methods

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //Uh oh something went wrong...we should probably retry?
    NSLog(@"%@",[error description]);
    NSMutableArray* connectionArray = [outstandingConnections valueForKey:[connection description]];
    id sender = [connectionArray objectAtIndex:1];
    ServerRequestType requestType = [[connectionArray objectAtIndex:0] intValue];
    
    [outstandingConnections removeObjectForKey:[connection description]];
    
//    tempData = nil;
    
    UIAlertView* failureAlertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Uh oh! A network request failed. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [failureAlertView show];
    
    if (![sender isEqual:[NSNull null]]) {
        [sender serverResponse:nil forRequest:requestType];
    }

}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    if (tempData == nil) {
//        tempData = [[NSMutableData alloc] initWithCapacity:0];
//    }
    NSMutableArray* connectionArray = [outstandingConnections valueForKey:[connection description]];
    [[connectionArray objectAtIndex:3] appendData:data];
//    NSLog([[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSMutableArray* connectionArray = [outstandingConnections valueForKey:[connection description]];
    
    NSLog(@"%@",[[NSString alloc] initWithData:[connectionArray objectAtIndex:3] encoding:NSASCIIStringEncoding]);
    
    //make sure it worked then proceed
    NSMutableDictionary* response = (NSMutableDictionary*)[NSJSONSerialization JSONObjectWithData:[connectionArray objectAtIndex:3] options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@",[response description]);    
    
    id sender = [connectionArray objectAtIndex:1];
    ServerRequestType requestType = [[connectionArray objectAtIndex:0] intValue];
    if (![sender isEqual:[NSNull null]]) {
        [sender serverResponse:response forRequest:requestType];
    }
    
    [outstandingConnections removeObjectForKey:[connection description]];

}


@end
