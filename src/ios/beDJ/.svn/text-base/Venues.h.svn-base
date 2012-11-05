//
//  Venues.h
//  beDJ
//
//  Created by Garrett Galow on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface Venues : NSObject <ServerDelegate> {
    
    NSMutableArray* venuesArray;
    NSMutableDictionary* currentVenue;
    NSMutableArray* venueVotes;
    NSDate* lastUpdate;
    
    id pendingConnection;
    
    NSMutableArray* waitingInstances;
    bool venuesUpdating;
    bool readyToUpdateVenueDelegates;
}

+(Venues*) sharedVenues;
-(updateStatus) updateVenuesWithSender:(id) sender;
-(void) connectToVenue:(NSNumber*) venueID withSender:(id) sender;
-(void) sortVenueListWithLocation:(CLLocation*) currentLoc;

@property (readonly, nonatomic) NSMutableArray* venuesArray;
@property (retain, nonatomic) NSMutableDictionary* currentVenue;
@property (readonly, nonatomic) NSMutableArray* venueVotes;
@property (readonly, nonatomic) NSDate* lastUpdate;

@end
