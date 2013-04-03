//
//  NoConnectionViewController.h
//  beDJ
//
//  Created by Garrett Galow on 4/12/12.
//  Copyright (c) 2012 Symplexum LLC. All rights reserved.
//
//  Header file for the view controller that displays when there is no connection to the internet.

#import <UIKit/UIKit.h>

@interface NoConnectionViewController : UIViewController

//Initialization method
//Returns a NoConnectionViewController object
-(id) init;

//Delegate method for when OK button
//parameters:
//  (id) sender - the object that called the method
-(IBAction) OKButtonPressed:(id)sender;

@end
