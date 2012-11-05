//
//  LocationDetailsViewController.m
//  beDJ
//
//  Created by Garrett Galow on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LocationDetailsViewController.h"
#import "Venues.h"
#import "VenueDelegate.h"
#import "Server.h"

@implementation LocationDetailsViewController

@synthesize BackButton, hostID, name, address, description, hostPic, inRange;

-(LocationDetailsViewController*) initWithHostID:(NSNumber *) ID {
    
    self = [super init];
    
    if (self) {
        hostID = ID;
    }
    
    return self;

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction) backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction) connectToVenue:(id)sender {
    UITabBarController* tabBar = [[(UINavigationController*)[self presentingViewController] viewControllers] objectAtIndex:0];
    UIViewController* viewController = [[tabBar viewControllers] objectAtIndex:0];
    [indicator setHidden:NO];
    [loadingView setHidden:NO];
    if ([[Venues sharedVenues] currentVenue] != nil) {
        [[Server sharedInstance] leaveLocationForHost:[hostID stringValue] User:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"] withSender:[NSNull null]];
    }
    [[Venues sharedVenues] connectToVenue:hostID withSender:viewController];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    innerLoadingView.layer.cornerRadius = 5.0;
    innerLoadingView.layer.masksToBounds = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSMutableArray* venues = [[Venues sharedVenues] venuesArray];
    NSMutableDictionary* currentHost;
    [indicator setHidden:NO];
    [loadingView setHidden:YES];
    
    for (NSMutableDictionary* host in venues) {
        if ([[host valueForKey:@"HOST_id"] isEqualToString:[hostID stringValue]]) {
            currentHost = host;
            break;
        }
    }
    
    name.text = ([currentHost valueForKey:@"name"] == nil || [currentHost valueForKey:@"name"] == [NSNull null]) ? nil : [currentHost valueForKey:@"name"];
    address.text = ([currentHost valueForKey:@"address"] == nil || [currentHost valueForKey:@"address"] == [NSNull null]) ? nil : [currentHost valueForKey:@"address"];
    description.text = ([currentHost valueForKey:@"description"] == nil || [currentHost valueForKey:@"description"] == [NSNull null]) ? nil : [currentHost valueForKey:@"description"];
    
    hostPic.image = ([[currentHost valueForKey:@"host_type"] isEqualToString:@"1"]) ? [UIImage imageNamed:@"53-house@2xw.png"] : [UIImage imageNamed:@"42-info@2xw.png"];

    if ([[hostID stringValue] isEqualToString: [[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"]]) {
        [joinButton setEnabled:NO];
        [joinButton setTitle:@"You are here!" forState:UIControlStateDisabled];
    } else if(!inRange){
        [joinButton setEnabled:NO];
        [joinButton setTitle:@"Too far to connect." forState:UIControlStateDisabled];
    }else {
        [joinButton setEnabled:YES];
        [joinButton setTitle:@"Join the Party!" forState:UIControlStateNormal];
    }
    
}
-(void) viewWillDisappear:(BOOL)animated {
    [indicator setHidden:NO];
    [loadingView setHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
