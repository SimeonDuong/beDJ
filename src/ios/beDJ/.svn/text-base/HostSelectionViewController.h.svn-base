//
//  HostSelectionViewController.h
//  beDJ
//
//  Created by Garrett Galow on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerDelegate.h"

@interface HostSelectionViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, ServerDelegate> {
    
    IBOutlet UIPickerView* hostPicker;
    IBOutlet UIButton* manageButton;
    IBOutlet UIButton* createButton;
    IBOutlet UIBarButtonItem* returnToGuestButton;
}

-(IBAction) manageButtonClicked:(id)sender;
-(IBAction) createButtonClicked:(id)sender;
-(IBAction) returnButtonClicked:(id)sender;

@end
