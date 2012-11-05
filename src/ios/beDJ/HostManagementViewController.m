//
//  HostManagementViewController.m
//  beDJ
//
//  Created by Garrett Galow on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HostManagementViewController.h"
#import "MusicPlayerViewController.h"
#import "HostInfoViewController.h"
#import "Server.h"
#import "HostManager.h"

@interface HostManagementViewController () {

}
@end

@implementation HostManagementViewController

//@synthesize host;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditHostInfo"]) {
         ((HostInfoViewController*)(segue.destinationViewController)).creatingHost = NO;
    }
}

-(IBAction)switchHostsButtonPressed {
    [[self navigationController] popViewControllerAnimated:YES];
    [[Server sharedInstance] disconnectHost:[[[HostManager sharedHostManager] hostInfo] valueForKey:@"HOST_id"] withSender:[NSNull null]];
    [[HostManager sharedHostManager] setHostInactive];
    
}

-(IBAction)returnToGuestButtonPressed {
    int count = [self.navigationController.viewControllers count];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count-1-2] animated:YES];
    [[Server sharedInstance] disconnectHost:[[[HostManager sharedHostManager] hostInfo] valueForKey:@"HOST_id"] withSender:[NSNull null]];
    [[HostManager sharedHostManager] setHostInactive];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    if ([[HostManager sharedHostManager] isHostActive]) {
        [startButton setTitle:@"Go back to the Playlist!" forState:UIControlStateNormal];
    } else {
        [startButton setTitle:@"Create a Playlist and Start the Party!" forState:UIControlStateNormal];
    }
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
