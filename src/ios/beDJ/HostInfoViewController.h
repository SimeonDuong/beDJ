//
//  HostInfoViewController.h
//  beDJ
//
//  Created by Garrett Galow on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerDelegate.h"

@interface HostInfoViewController : UIViewController <ServerDelegate, UITextViewDelegate> {
    
    IBOutlet UITextField* hostNameField;
    IBOutlet UITextView* hostDescriptionField;
    IBOutlet UITextView* hostAddressField;
    IBOutlet UIButton* submitButton;
    IBOutlet UIBarButtonItem* backButton;
    IBOutlet UILabel* viewTitle;
    
    BOOL creatingHost;
}

-(IBAction) backButtonPressed:(id)sender;

-(IBAction) submitButtonPressed:(id)sender;

-(IBAction)editingEnded:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField* hostNameField;
@property (retain, nonatomic) IBOutlet UITextView* hostDescriptionField;
@property (retain, nonatomic) IBOutlet UITextView* hostAddressField;
@property (retain, nonatomic) IBOutlet UIButton* submitButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem* backButton;
@property (retain, nonatomic) IBOutlet UILabel* viewTitle;
@property (nonatomic) BOOL creatingHost;

@end
