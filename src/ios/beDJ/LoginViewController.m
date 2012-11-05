//
//  LoginViewController.m
//  QuTrack
//
//  Created by Garrett Galow on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "UserData.h"
#import <CommonCrypto/CommonDigest.h>
#import "CreateAccountViewController.h"

@implementation LoginViewController

NSString* salt = @"conveniencegirlfriendidgafyolowhoteelala";

-(id) init {
    self = [super initWithNibName:@"LoginViewController" bundle:nil];
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

+ (NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+ (NSString*) saltString:(NSString*)input {
    NSString* saltHashedString = [LoginViewController md5HexDigest:salt];
    NSString* saltPasswordString = [LoginViewController md5HexDigest:input];
    return [LoginViewController md5HexDigest:[saltPasswordString stringByAppendingString:saltHashedString]];
}

-(BOOL) validInput:(BOOL) emailRequired {
    if ([usernameField.text isEqualToString:@""] || [passwordField.text isEqualToString:@""]) {
        return NO;
        
    }else if (emailRequired && ([emailField.text isEqualToString:@""] || NSEqualRanges([emailField.text rangeOfString:@"@"], NSMakeRange(NSNotFound, 0)))) {
        return NO;
    }
    return YES;
}

-(IBAction) loginButtonPressed:(id) sender {
    //Eventually switch hash from after to before
    if (![self validInput:NO]) {
        UIAlertView* badInput = [[UIAlertView alloc] initWithTitle:@"Invalid login info." message:@"Either you left a required field blank or your email was improperly formatted." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [badInput show];
        return;
    }
    NSString* fullSaltPasswordString = [LoginViewController saltString:passwordField.text];
    [[Server sharedInstance] loginwithUsername:usernameField.text andPassword:fullSaltPasswordString withSender:self];
//    [[Server sharedInstance] loginwithUsername:usernameField.text andPassword:passwordField.text withSender:self];
    [loadingView setHidden:false];
    [loadingIndicator startAnimating];
}

-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder]; 
}

-(IBAction) createAccountButtonPressed:(id) sender {
    
    CreateAccountViewController* createAccountVC = [[CreateAccountViewController alloc] init];
    [self presentViewController:createAccountVC animated:YES completion:nil];
    
//    if (![self validInput:YES]) {
//        UIAlertView* badInput = [[UIAlertView alloc] initWithTitle:@"Invalid login info" message:@"Either you left a required field blank or your email was improperly formatted." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [badInput show];
//        return;
//    }
//    //Eventually switch hash from after to before
//    NSString* fullSaltPasswordString = [LoginViewController saltString:passwordField.text];
//    [[Server sharedInstance] createAccount:usernameField.text andPassword:fullSaltPasswordString andEmail:emailField.text withSender:self];
////    [[Server sharedInstance] createAccount:usernameField.text andPassword:passwordField.text withSender:self];
//    [loadingView setHidden:false];
//    [loadingIndicator startAnimating];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch * touch = [touches anyObject];
//    if(touch.phase == UITouchPhaseBegan) {
//        [passwordField resignFirstResponder];
//        [usernameField resignFirstResponder];
//        [emailField resignFirstResponder];
//    }
//}

-(IBAction)dismissKeyboard:(id)sender {
    [passwordField resignFirstResponder];
    [usernameField resignFirstResponder];
}

//-(BOOL)canBecomeFirstResponder {
//    return YES;
//}

-(void) serverResponse:(NSMutableDictionary *)responseData forRequest:(ServerRequestType)requestType {
    if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 0) && (![[[responseData valueForKey:@"Status"] valueForKey:@"Code"] isEqual:[NSNull null]])) {
                
//        if(![[UserData sharedInstance] setLoginData:usernameField.text :passwordField.text :[[responseData valueForKey:@"Data"] valueForKey:@"USER_id"]]) {
//            NSLog(@"ERROR");
//        }
//        [[UserData sharedInstance] saveUserData];
        [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"Data"] valueForKey:@"USER_id"] forKey:@"USER_id"];
        
        [[NSUserDefaults standardUserDefaults] setValue:usernameField.text forKey:@"username"];
//        [[NSUserDefaults standardUserDefaults] setValue:passwordField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setValue:[LoginViewController saltString:passwordField.text] forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [loadingIndicator stopAnimating];
        [loadingView setHidden:TRUE];
        
//        [self.navigationController popViewControllerAnimated:YES];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
//        [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
        return;
    } else {
        [loadingIndicator stopAnimating];
        [loadingView setHidden:TRUE];
        //Tell user something went wrong.
        if (([[[responseData valueForKey:@"Status"] valueForKey:@"Code"] intValue] == 3)) {
            UIAlertView* usernameTaken = [[UIAlertView alloc] initWithTitle:@"Username Taken" message:@"That username has already been taken. Please pick another." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [usernameTaken show];
        } else {
            UIAlertView* incorrectLogin = [[UIAlertView alloc] initWithTitle:@"Login Incorrect" message:@"Your username or password was incorrect. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [incorrectLogin show];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
//    server = [[Server alloc] init];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    // Do any additional setup after loading the view from its nib.
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
