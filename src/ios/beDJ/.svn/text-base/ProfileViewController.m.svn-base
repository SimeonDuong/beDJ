//
//  ProfileViewController.m
//  beDJ
//
//  Created by Garrett Galow on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize usernameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction) settingsButtonPressed:(id)sender {
    UIViewController* settingsView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsView"];
    [UIView beginAnimations:@"animation3" context:nil];
    [self.navigationController pushViewController:settingsView animated:NO];
    [UIView setAnimationDuration:.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO]; 
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

-(void) viewWillAppear:(BOOL)animated {
    usernameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
