//
//  LoadScreenViewController.m
//  beDJ
//
//  Created by Garrett Galow on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadScreenViewController.h"
#import "UserData.h"
#import "Server.h"
#import "Reachability.h"
#import "NoConnectionViewController.h"
#import "LoginViewController.h"

@implementation LoadScreenViewController
NSMutableData* tempData;

-(id) init {
    self = [super initWithNibName:@"LoadScreenViewController" bundle:nil];
    if (self)
    {
        // Further initialization if needed
    }
    return self;
}

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

-(void) serverResponse:(NSMutableDictionary *)responseData forRequest:(ServerRequestType)requestType {
    
    if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
//        [[UserData sharedInstance] setUserID:[NSNumber numberWithInt:[[[responseData valueForKey:@"Data"] valueForKey:@"USER_id"] intValue]]];
        
        [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"Data"] valueForKey:@"USER_id"] forKey:@"USER_id"];
      
        [self.navigationController popViewControllerAnimated:YES];
//        [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    //if not go to login screen

//    UIViewController* LoginScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    LoginViewController* LoginScreen = [[LoginViewController alloc] init];

    [self presentViewController:LoginScreen animated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:NO];

//    [self.navigationController pushViewController:LoginScreen animated:YES];
}

-(void) loginGranted {

}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [indicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSDictionary* dict = [[UserData sharedInstance] readLoginData];
//    [[Server sharedInstance] loginwithUsername:[dict objectForKey:@"username"] andPassword:[dict objectForKey:@"password"] withSender:self];
//    [[Server sharedInstance] loginwithUsername:@"hi" andPassword:@"hi" withSender:self];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        NoConnectionViewController* noInternetController = [[NoConnectionViewController alloc] init];
        [self.navigationController pushViewController:noInternetController animated:YES];
    } else {
        NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        NSString* password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
        [[Server sharedInstance] loginwithUsername:username andPassword:password withSender:self];
    }    
}

-(void)viewWillDisappear:(BOOL)animated {
    [UIView beginAnimations:@"animation2" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO]; 
    [UIView commitAnimations];
}

-(void)viewDidDisappear:(BOOL)animated {
    [indicator stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[Server sharedInstance] createPlaylistWithSender:self];
//    [[Server sharedInstance] getVoteCountForHost:@"3" ofUser:@"1" withSender:self];
//    [[Server sharedInstance] setNowPlayingwithSong:@"88" andHost:@"11" withSender:self];
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
