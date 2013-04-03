//
//  FirstViewController.h
//  QuTrack
//
//  Created by Garrett Galow on 11/1/11.
//  Copyright (c) 2011 Symplexum LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreLocationController.h"
#import "LocationDetailsViewController.h"
#import "Venues.h"
#import "VenueDelegate.h"
#import "SSPullToRefreshView.h"
#import "DJPullToRefreshContentView.h"


@interface FirstViewController : UIViewController <VenueDelegate, SSPullToRefreshViewDelegate> {
//    NSMutableArray *listOfSessions;
    
    //Gets the location of the user
    CoreLocationController *CLController;
    SSPullToRefreshView* pullToRefreshView;
//    NSMutableData* responseData;
    
    //Whether or not the client is connected to a venue
    BOOL connectedToVenue;
    
//	IBOutlet UILabel *locLabel;
    IBOutlet UITableView* table;
    
    //Used to display network activity when loading venues
//    IBOutlet UIActivityIndicatorView* indicator;
//    IBOutlet UIView* loadingView;
//    IBOutlet UIView* innerLoadingView;
    
    //Button to disconnect from a venue
    IBOutlet UIBarButtonItem* leaveVenue;
    
    //Shown when no venues are active
    IBOutlet UIView* noVenuesView;

}

//Disconnects the guest from the connected venue on leaveVenue bar button item pressed
-(IBAction) leaveVenue:(id)sender;

//Refreshes the venue list on refreshbutton press 
//-(IBAction) refreshButtonPressed:(id) sender;

@property (nonatomic, retain) CoreLocationController *CLController;
@property (nonatomic, retain) SSPullToRefreshView* pullToRefreshView;

@end
