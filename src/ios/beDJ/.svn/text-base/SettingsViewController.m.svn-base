//
//  SettingsViewController.m
//  beDJ
//
//  Created by Garrett Galow on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserData.h"
#import "LoginViewController.h"
#import "Venues.h"

@implementation SettingsViewController

@synthesize BackButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) logoutButtonPressed:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"password"];
    [defaults removeObjectForKey:@"USER_id"];
    [defaults synchronize];
//    LoginViewController* loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    LoginViewController* loginView = [[LoginViewController alloc] init];
    [self.navigationController presentViewController:loginView animated:YES completion:^(void) {
        [[[self.navigationController viewControllers] objectAtIndex:0] setSelectedIndex:0];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(IBAction) allocateVotesButtonPressed:(id)sender {
    if ([[Venues sharedVenues] currentVenue] != nil) {
        NSString* currentVenue = [[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"];
        NSString* userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"];
        [[Server sharedInstance] allocateVotesForHost:currentVenue andUser:userID withSender:self];
        AllocateStatus.text = @"Working...";
    } else {
        AllocateStatus.text = @"Connect to a venue first!";
    }
}

-(void)serverResponse:(NSMutableDictionary *)responseData forRequest:(ServerRequestType)requestType {
    switch (requestType) {
        case AllocateVotes:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                //do something
                AllocateStatus.text = @"Votes Allocated Successfully!";
                
            } else {
                //do something
                AllocateStatus.text = @"Votes Not Allocated.";
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

-(void) viewWillAppear:(BOOL)animated {
    AllocateStatus.text = @"";
}

-(void)viewWillDisappear:(BOOL)animated {
    [UIView beginAnimations:@"animation2" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO]; 
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
