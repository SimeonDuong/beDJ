//
//  HostInfoViewController.m
//  beDJ
//
//  Created by Garrett Galow on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HostInfoViewController.h"
#import "HostManager.h"
#import "Server.h"
#import "CoreLocationController.h"

#define kOFFSET_FOR_KEYBOARD 200

@interface HostInfoViewController () {
    CoreLocationController* CLController;
}
@end

@implementation HostInfoViewController

@synthesize hostNameField, hostAddressField, hostDescriptionField, backButton, submitButton, creatingHost, viewTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Instance Methods

-(IBAction) backButtonPressed:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction) submitButtonPressed:(id)sender {
    NSString* hostNameText = hostNameField.text;
    NSString* hostAddressText = hostAddressField.text;
    NSString* hostDescriptionText = hostDescriptionField.text;
    NSNumber* xPos = [NSNumber numberWithFloat:[[CLController.locMgr location] coordinate].latitude];
    NSNumber* yPos = [NSNumber numberWithFloat:[[CLController.locMgr location] coordinate].longitude];
    NSString* userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"];
    NSString* hostID = [[[HostManager sharedHostManager] hostInfo] valueForKey:@"HOST_id"];
    if (creatingHost) {
        [[Server sharedInstance] createHostWithName:hostNameText address:hostAddressText description:hostDescriptionText xPos:xPos yPos:yPos type:@"party" userID:userID withSender:self];
    } else {
        [[Server sharedInstance] editHostInfoWithName:hostNameText address:hostAddressText description:hostDescriptionText xPos:xPos yPos:yPos type:@"party" userID:userID hostID:hostID withSender:self];
    }
}

#pragma mark - Server Delegate Methods

-(void)serverResponse:(NSMutableDictionary *)responseData forRequest:(ServerRequestType)requestType {
    switch (requestType) {
        case CreateHost:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                [self.navigationController popViewControllerAnimated:YES];
                [self performSegueWithIdentifier:@"HostCreatedSegue" sender:self];
                [[HostManager sharedHostManager] setHostInfo:[responseData valueForKey:@"Data"]];
            }
            break;
            
        case EditHostInfo:
            if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Text View Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Enter Description Here"] || [textView.text isEqualToString:@"Enter Address Here"]) {
        textView.text = @"";
    }
    
    if (textView == hostAddressField) {
        NSTimeInterval animationDuration = 0.300000011920929;
        CGRect frame = self.view.frame;
        frame.origin.y -= kOFFSET_FOR_KEYBOARD;
        frame.size.height += kOFFSET_FOR_KEYBOARD;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        if ([textView isEqual:hostAddressField]) {
            textView.text = @"Enter Address Here";
        } else if ([textView isEqual:hostDescriptionField]) {
            textView.text = @"Enter Description Here";
        }
    }
    
    if (textView == hostAddressField) {
        NSTimeInterval animationDuration = 0.300000011920929;
        CGRect frame = self.view.frame;
        frame.origin.y += kOFFSET_FOR_KEYBOARD;
        frame.size.height -= kOFFSET_FOR_KEYBOARD;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [hostAddressField resignFirstResponder];
        [hostDescriptionField resignFirstResponder];
        [hostNameField resignFirstResponder];
    }
}

-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder]; 
}

#pragma mark - viewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    CLController = [[CoreLocationController alloc] init];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    if (creatingHost) {
        viewTitle.text = @"Create A Host";
        [submitButton setTitle:@"Create Host" forState:UIControlStateNormal];
    } else {
        viewTitle.text = @"Edit Host Info";
        [submitButton setTitle:@"Change Info" forState:UIControlStateNormal];
    }
    [CLController.locMgr startUpdatingLocation];
}

-(void) viewWillDisappear:(BOOL)animated {
    [CLController.locMgr stopUpdatingLocation];
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
