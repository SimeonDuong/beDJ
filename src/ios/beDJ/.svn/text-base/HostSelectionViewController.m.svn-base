//
//  HostSelectionViewController.m
//  beDJ
//
//  Created by Garrett Galow on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HostSelectionViewController.h"
#import "HostManagementViewController.h"
#import "Server.h"
#import "HostManager.h"
#import "HostInfoViewController.h"

@interface HostSelectionViewController () {
    NSArray* userHosts;
//    NSDictionary* connectedHost;
    NSNumber* selectedHost;
    BOOL hostsLoaded;
    BOOL noHosts;
}

@end

@implementation HostSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"HostConnect"] ) {
//        ((HostManagementViewController*)segue.destinationViewController).host = connectedHost;
//    }
    if ([segue.identifier isEqualToString:@"CreateNewHost"]) {
        ((HostInfoViewController*)(segue.destinationViewController)).creatingHost = YES;
    }
}

#pragma mark - Instance Methods

-(IBAction) createButtonClicked:(id)sender {
    
}

-(IBAction) manageButtonClicked:(id)sender {
    if (noHosts) {
        UIAlertView* noHostAlert = [[UIAlertView alloc] initWithTitle:@"No Host To Manage" message:@"You have no host to manage. Create one to begin hosting!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [noHostAlert show];
        return;
    } else if (!hostsLoaded) {
        return;
    }
    [[HostManager sharedHostManager] setHostInfo:[userHosts objectAtIndex:[selectedHost integerValue]]];
    [[Server sharedInstance] connectHost:[[[HostManager sharedHostManager] hostInfo] valueForKey:@"HOST_id"] withSender:self];
    [self performSegueWithIdentifier:@"HostConnect" sender:self];
    [[HostManager sharedHostManager] setHostInfo:[userHosts objectAtIndex:[selectedHost integerValue]]];
}

-(IBAction) returnButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Server Delegate Methods

-(void)serverResponse:(NSMutableDictionary *)responseData forRequest:(ServerRequestType)requestType {
    //Handles GetAllHostNamesForUser, UserHostConnect
    switch (requestType) {
        case GetAllHostNamesForUser:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                userHosts = [responseData valueForKey:@"Data"];
                hostsLoaded = TRUE;
//                if ((!hostsLoaded) || ([userHosts count] == 0)) {
//                    manageButton.enabled = NO;
//                } else {
//                    manageButton.enabled = YES;
//                }
                [hostPicker reloadAllComponents];
            }
            break;
            
        case ManagerHostConnect:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
//                connectedHost = [responseData valueForKey:@"Data"];
//                [[HostManager sharedHostManager] setHostInfo:[responseData valueForKey:@"Data"]];
//                [self performSegueWithIdentifier:@"HostConnect" sender:self];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Picker View Delegate Methods

//Returns the width for the component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
}

//Retruns the height for a row for a component
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

//Returns the string title for the row
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    [[[pickerView subviews] objectAtIndex:0] setHidden:YES];
    [[[pickerView subviews] objectAtIndex:[[pickerView subviews] count] - 1] setHidden:YES];
    if (!hostsLoaded) {
        return @"Loading Hosts.";
    } else {
        if (noHosts) {
            return @"You have no hosts!";
        } else {
            return [NSString stringWithFormat:@"%@",[[userHosts objectAtIndex:row] valueForKey:@"name"]];    
        }
    }
    
}

//what to do if anything when a row is selected?
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!hostsLoaded) {
        return;
    }
    selectedHost = [NSNumber numberWithInt:row];
}

#pragma mark - Picker View Data Source Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (!hostsLoaded) {
        return 1;
    } else {
        NSInteger hostCount = [userHosts count];
        if (hostCount == 0) {
            noHosts = YES;
            return 1;
        } else {
            noHosts = NO;
            return hostCount;
        }
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [[Server sharedInstance] getAllHostNamesForUser:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"]  withSender:self];
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
