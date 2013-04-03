//
//  VenueDelegate.h
//  beDJ
//
//  Created by Garrett Galow on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol VenueDelegate <NSObject>

@required

@optional
-(void) venuesUpdated;

-(void) venueConnection;

@end
