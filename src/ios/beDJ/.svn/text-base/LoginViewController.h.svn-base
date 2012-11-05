//
//  LoginViewController.h
//  QuTrack
//
//  Created by Garrett Galow on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerDelegate.h"
#import "Server.h"

@interface LoginViewController : UIViewController <ServerDelegate> {
    
    IBOutlet UITextField* usernameField;
    IBOutlet UITextField* passwordField;
    IBOutlet UITextField* emailField;
    NSMutableData* tempData;
    IBOutlet UIActivityIndicatorView* loadingIndicator;
    IBOutlet UIView* loadingView;
//    Server* server;
}

-(id) init;
-(IBAction) loginButtonPressed:(id) sender;
-(IBAction) editingEnded:(id)sender;
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(IBAction) createAccountButtonPressed:(id) sender;
-(IBAction) dismissKeyboard:(id)sender;

+ (NSString*) saltString:(NSString*)input;

@end
