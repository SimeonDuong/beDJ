//
//  HostManagementViewController.h
//  beDJ
//
//  Created by Garrett Galow on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostManagementViewController : UIViewController {
    
    IBOutlet UIButton* startButton;
    IBOutlet UIButton* returnToGustButton;
    IBOutlet UIButton* editHostButton;
    IBOutlet UIButton* addUsersButton;
    IBOutlet UIBarButtonItem* switchHostsButton;
    
//    NSDictionary* host;
    
}

-(IBAction) returnToGuestButtonPressed;

-(IBAction) switchHostsButtonPressed;

//@property (retain, nonatomic) NSDictionary* host;

@end
