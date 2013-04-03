//
//  FirstViewController.m
//  QuTrack
//
//  Created by Garrett Galow on 11/1/11.
//  Copyright (c) 2011 Symplexum LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FirstViewController.h"
#import "Server.h"
#import "Playlist.h"
#import "LocationCell.h"
#import "SecondViewControllerV2.h"
//#import "SSPullToRefreshView.h"

@implementation FirstViewController

@synthesize CLController, pullToRefreshView;

//HostID of the venue selected to display info for.
NSNumber* selectedVenue;
NSNumber* venueRangeLimiter;
const static int VENUE_RANGE = 805; //Meters

//- (void)locationUpdate:(CLLocation *)location {
//	locLabel.text = [location description];
//}
//
//- (void)locationError:(NSError *)error {
//	locLabel.text = [error description];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc {
    
}

//Disconnect from the current venue
-(IBAction) leaveVenue:(id)sender {
    if ([[Venues sharedVenues] currentVenue] != nil) {
        
        [[Server sharedInstance] leaveLocationForHost:[[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"]  User:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"] withSender:[Venues sharedVenues]];
        
        [[Venues sharedVenues] setCurrentVenue:nil];
        connectedToVenue = NO;
        [table reloadData];
        
        [[Venues sharedVenues] updateVenuesWithSender:self];
        
//        [loadingView setHidden:NO];
//        [indicator startAnimating];
        
        [leaveVenue setEnabled:NO];
        
//        [[Playlist sharedPlaylist] clearPlaylist];
    }
    
}

-(void) setVenueOutOfRangeLimiter {
    NSInteger index = -1;;
    CLLocation* currentLoc = [[CLController locMgr] location];

    for (index = 0; index < [[[Venues sharedVenues] venuesArray] count]; index++) {
        NSDictionary* dict = [[[Venues sharedVenues] venuesArray] objectAtIndex:index];
        CLLocation* loc = [[CLLocation alloc] initWithLatitude:[[dict valueForKey:@"position_x"] doubleValue] longitude:[[dict valueForKey:@"position_y"] doubleValue]];
        NSNumber* dist = [NSNumber numberWithDouble:[currentLoc distanceFromLocation:loc]];
        
        if ([dist intValue] > VENUE_RANGE) {
            break;
        }
    }
    venueRangeLimiter = [NSNumber numberWithInt:index];
}

//Refresh the venue list
//-(IBAction) refreshButtonPressed:(id) sender {
//    [[Venues sharedVenues] updateVenuesWithSender:self];
//    
//    [loadingView setHidden:NO];
//    [indicator startAnimating];
//}

#pragma mark Table Methods

//Returns how many sections are in the table
//If connected to a venue there are 2 else 1
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView { 

    if (!connectedToVenue) {
        return 1;
    } else {
        return 2;
    }

}

//Returns the number of rows in a given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    
    if ((section == 0) && connectedToVenue) {
        //one row to display for current venue
        return 1;
        
    } else if (((section == 0) && !connectedToVenue) || section == 1) {
        //# rows is venue count
        if ([[[Venues sharedVenues] venuesArray] count] == 0) {
            noVenuesView.hidden = NO;
        } else {
            noVenuesView.hidden = YES;
        }
        return [[[Venues sharedVenues] venuesArray] count];
    } else {
        return 0;
    }
}

//Return the String title for the header of a section
//Currently using views so returnning nil
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ((section == 0) && connectedToVenue) {
//        return @"Current Location";
        return  nil;
    } else if (((section == 0) && !connectedToVenue) || section == 1) {
//        return @"Locations";
        return nil;
    } else {
        return nil;
    }
}

//Return the height value for a header section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ((section == 0) && connectedToVenue) {
        return 38;
    } else if (((section == 0) && !connectedToVenue) || section == 1) {
        return 38;
    } else {
        return 0;
    }
}

//Views to set as headers for sections
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ((section == 0) && connectedToVenue) {
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.text = @"Current Location";
//        {class:16-bit RGB color, red:8443, green:38605, blue:42495}
//        headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
        //orange color {class:8-bit RGB color, red:252, green:181, blue:95}
        headerLabel.textColor = [UIColor colorWithRed:(60432.0/65535.0) green:(28089.0/65535.0) blue:0 alpha:1];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
        headerLabel.textAlignment = UITextAlignmentCenter;
        return headerLabel;

    } else if (((section == 0) && !connectedToVenue) || section == 1) {
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.text = @"Locations";
//        headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
        headerLabel.textColor = [UIColor colorWithRed:(60432.0/65535.0) green:(28089.0/65535.0) blue:0 alpha:1];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
        headerLabel.textAlignment = UITextAlignmentCenter;
        return headerLabel;
        
    } else {
        return nil;
    }
    
}

//Set up a cell for the table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    NSLog(@"%f, %f, %f, %f",cell.bounds.origin.x, cell.bounds.origin.y, cell.bounds.size.height, cell.bounds.size.width);
//    gradient.frame = CGRectMake(10, 3, 300, 41);
//    gradient.frame = [[cell.layer.sublayers objectAtIndex:0] bounds];
//    gradient.frame = cell.backgroundView.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:(141.0/255.0) green:(141.0/255.0) blue:(151.0/255.0) alpha:.95] CGColor],(id)[[UIColor colorWithRed:(30.0/255.0) green:(31.0/255.0) blue:(45.0/255.0) alpha:.95] CGColor], nil];
//    gradient.cornerRadius = 6.0;
//    gradient.masksToBounds = YES;
//    cell.layer.superlayer = nil;
//    gradient.mask = cell.layer;
//    [[cell.layer.sublayers objectAtIndex:0] insertSublayer:gradient atIndex:0];
//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableCellGradient.png"]];
    cell.backgroundColor = [UIColor blackColor];

    
    // Set up the cell...
    
    if ((indexPath.section == 0) && connectedToVenue) {
        NSString* cellValue = [[[Venues sharedVenues] currentVenue] valueForKey:@"name"];
        cell.locName.text = cellValue;
    } else {
        
        NSString *cellValue = [[[[Venues sharedVenues] venuesArray] objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.locName.text = cellValue;
        if (indexPath.row >= [venueRangeLimiter intValue]) {
            cell.distanceLabel.text = @"Too far to connect";
        } else {
            cell.distanceLabel.text = @"In Range to Connect";
        }
    }
    
    return cell;
}

//On row selection a segue to the locationDetailsView is initiated from storyboard
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    if (indexPath.row < [venueRangeLimiter intValue]) {
        [self performSegueWithIdentifier:@"DetailSegue" sender:self];
//    } else {
//        UIAlertView* outOfRangeAlert = [[UIAlertView alloc] initWithTitle:@"Venue out of range" message:@"You are too far away to connect to this venue" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [outOfRangeAlert show];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Segue to the view for detailed info about a venue
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        //Before segueing set the hostID in the detailViewController so it can display info for the correct host
        NSIndexPath* indexPath = [table indexPathForSelectedRow];
        if (!connectedToVenue || (connectedToVenue && indexPath.section == 1)) {
            selectedVenue = [NSNumber numberWithInt:[[[[[Venues sharedVenues] venuesArray] objectAtIndex:indexPath.row] valueForKey:@"HOST_id"] intValue]];
        } else {
            selectedVenue = [NSNumber numberWithInt:[[[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"] intValue]];
        }
        [[segue destinationViewController] setHostID:selectedVenue];

        [[segue destinationViewController] setInRange:(indexPath.row < [venueRangeLimiter intValue]) ? YES : NO];
    }
}

#pragma mark SSPullToRefresh Delegate Methods

- (void)refresh {
    [self.pullToRefreshView startLoadingAndExpand:YES];
    // Load data...
    [[Venues sharedVenues] updateVenuesWithSender:self];
    
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

#pragma mark Venue Delegate Methods

//Called when the venue list is updated
-(void) venuesUpdated {
    
    [[Venues sharedVenues] sortVenueListWithLocation:[[CLController locMgr] location]];
    connectedToVenue = ([[Venues sharedVenues] currentVenue] == nil) ? NO : YES;
    [self setVenueOutOfRangeLimiter];
    [table reloadData];
    [self.pullToRefreshView finishLoading];
//    [indicator stopAnimating];
//    [loadingView setHidden:YES];
    
}

//Called when a successful connection to a venue is made
-(void) venueConnection {
    
    [leaveVenue setEnabled:YES];
    
    int controllerIndex = 1;
    
    UITabBarController *tabBarController = self.tabBarController;
    //        //Get the current view
    //        UIView * fromView = tabBarController.selectedViewController.view;
    //        //Get the view we are going to which is the secondViewController view
    //        UIView * toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    //        
    //        // Transition using a page curl.
    //        //Need to get it to not be offset when it loads
    //        [UIView transitionFromView:fromView toView:toView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve completion:
    //         ^(BOOL finished) {
    //             if (finished) {
    //                 tabBarController.selectedIndex = controllerIndex;
    //             }
    //         }];
    tabBarController.selectedIndex = controllerIndex;
    SecondViewControllerV2* secondController = [tabBarController.viewControllers objectAtIndex:controllerIndex];
//    [[Playlist sharedPlaylist] updatePlaylistDataWithSender:secondController];
    [secondController refresh];
    [[self modalViewController] dismissViewControllerAnimated:YES completion:^(void) {}];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    venueRangeLimiter = [NSNumber numberWithInt:-1];
    
    CLController = [[CoreLocationController alloc] init];
    //Not necessary right now
//	CLController.delegate = self;
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:table delegate:self];
    pullToRefreshView.contentView = [[DJPullToRefreshContentView alloc] initWithFrame:CGRectZero];
    
    //Round the corners of the loading view
//    innerLoadingView.layer.cornerRadius = 5.0;
//    innerLoadingView.layer.masksToBounds = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [CLController.locMgr startUpdatingLocation];
    //If the hosts haven't been updated in 30 seconds then update them
    if ([[NSDate date] timeIntervalSinceDate:[[Venues sharedVenues] lastUpdate]] > 30) {
        connectedToVenue = ([[Venues sharedVenues] currentVenue] == nil) ? NO : YES;
        [self refresh];
//        [[Venues sharedVenues] updateVenuesWithSender:self];
//        
//        [loadingView setHidden:NO];
//        [indicator startAnimating];
        
    } else {
        //otherwise simply check if we are connected and reload the table
        connectedToVenue = ([[Venues sharedVenues] currentVenue] == nil) ? NO : YES;
        [table reloadData];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [CLController.locMgr stopUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
