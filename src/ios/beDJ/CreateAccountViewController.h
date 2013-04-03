//
//  CreateAccountViewController.h
//  beDJ
//
//  Created by Garrett Galow on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerDelegate.h"

@interface CreateAccountViewController : UIViewController <UITextFieldDelegate, ServerDelegate> {
    
    IBOutlet UITextField* usernameField;
    IBOutlet UITextField* passwordField;
    IBOutlet UITextField* password2Field;
    IBOutlet UITextField* emailField;
    
    IBOutlet UIButton* createAccountButton;
    IBOutlet UIButton* goBackButton;
    
    IBOutlet UIActivityIndicatorView* loadingIndicator;
    IBOutlet UIView* loadingView;
}

-(id) init;

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

-(IBAction) createAccountButtonPressed:(id)sender;
-(IBAction) goBackButtonPressed:(id)sender;
-(IBAction) dismissKeyboard:(id)sender;

@end
