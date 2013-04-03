//
//  Venues.m
//  beDJ
//
//  Created by Garrett Galow on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Venues.h"
#import "Server.h"
#import "UserData.h"
#import "VenueDelegate.h"

@implementation Venues

@synthesize venuesArray, currentVenue, venueVotes, lastUpdate;

static Venues* sharedInstance = nil;

+(Venues*) sharedVenues {
    if(sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        if (venuesArray == nil) {
            venuesArray = [[NSMutableArray alloc] init];
            currentVenue = nil;
            waitingInstances = [[NSMutableArray alloc] init];
            readyToUpdateVenueDelegates = false;
            venuesUpdating = false;
            lastUpdate = [NSDate dateWithTimeIntervalSince1970:0];
        }
    }
    
    return self;
}

+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedVenues];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void) sortVenueListWithLocation:(CLLocation*)currentLoc {
    [venuesArray sortUsingComparator:^(id obj1, id obj2) {
        CLLocation* loc1 = [[CLLocation alloc] initWithLatitude:[[obj1 valueForKey:@"position_x"] doubleValue] longitude:[[obj1 valueForKey:@"position_y"] doubleValue]];
        CLLocation* loc2 = [[CLLocation alloc] initWithLatitude:[[obj2 valueForKey:@"position_x"] doubleValue] longitude:[[obj2 valueForKey:@"position_y"] doubleValue]];
        NSNumber* dist1 = [NSNumber numberWithDouble:[currentLoc distanceFromLocation:loc1]];
        NSNumber* dist2 = [NSNumber numberWithDouble:[currentLoc distanceFromLocation:loc2]];
        return (NSComparisonResult)[dist1 compare:dist2];
    }];
}

-(updateStatus) updateVenuesWithSender:(id) sender {
    
    updateStatus status;
    //Check if an update is currently happening
    //if not then start an update
    //if so then just add this sender to the waiting list
    if (!venuesUpdating) {
        lastUpdate = [NSDate date];
        [[Server sharedInstance] getHostswithSender:self];
        [[Server sharedInstance] getHostVotesForUserWithSender:self];
        [waitingInstances addObject:sender];
        status = newRequest;
        venuesUpdating = true;
    } else {
        status = selfMadeRequest;
        if (![waitingInstances containsObject:sender]) {
            [waitingInstances addObject:sender];
            status = otherMadeRequest;
        }
    }
    
    return status;

}

-(void) connectToVenue:(NSNumber *)venueID withSender:(id) sender {
//    NSLog(@"venue:%@, user:%@",[venueID stringValue],[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"]);
    [[Server sharedInstance] joinLocationForHost:[venueID stringValue] andUser:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"] withSender:self];
    pendingConnection = sender;
//    currentVenue = venueID;
}

-(void) serverResponse:(NSMutableDictionary *)responseData forRequest:(ServerRequestType)requestType {
    switch (requestType) {
        case GetHosts:
            //do something
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                venuesArray = [responseData valueForKey:@"Data"];
                if (([venuesArray count] == 0) || ([venuesArray isKindOfClass:[NSNull class]])) {
                    venuesArray = [NSMutableArray arrayWithCapacity:1];
                }
            } else {
                //error
            }
            break;
            
        case JoinLocation:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                //Eventually set hostID here, but for now it is set before
                NSNumber* currentVenueID = [NSNumber numberWithInt:[[[responseData valueForKey:@"Data"] valueForKey:@"HOST_id"] intValue]];
                for (NSMutableDictionary* venue in venuesArray) {
                    if ([[venue valueForKey:@"HOST_id"] isEqualToString:[currentVenueID stringValue]]) {
                        currentVenue = venue;
                    }
                }

            } else {
                //do something
                //if it didn't work for now reset currentVenue to nil;
                
            }
            break;
            
        case LeaveLocation:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                currentVenue = nil;
            }
            
        case GetHostVotes:
            //do something
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                
            } else {
                //error
            }
            break;
            
//        case CastVote:
//            if ([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) {
//                //do something
//            } else {
//                //do something
//            }
//            break;
//            
//        case UndoVote:
//            if ([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) {
//                //do something
//            } else {
//                //do something
//            }
//            break;
            
        default:
            break;
    }
    
    if ((requestType == GetHosts) || (requestType == GetHostVotes)) {
        if (readyToUpdateVenueDelegates == true) {
            
            for (id receiver in waitingInstances) {
                [receiver venuesUpdated];
            }
            
            [waitingInstances removeAllObjects];
            
            venuesUpdating = false;
            readyToUpdateVenueDelegates = false;
        } else {
            readyToUpdateVenueDelegates = true;
        }
    } else if (requestType == JoinLocation) {
        [pendingConnection venueConnection];
        pendingConnection = NULL;
    }
    

}

@end
