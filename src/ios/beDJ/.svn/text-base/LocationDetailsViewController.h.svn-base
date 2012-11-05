//
//  LocationDetailsViewController.h
//  beDJ
//
//  Created by Garrett Galow on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationDetailsViewController : UIViewController {
    
    NSNumber* hostID;
    BOOL inRange;
    IBOutlet UIBarButtonItem* BackButton;
    
    IBOutlet UIButton* joinButton;
    
    IBOutlet UILabel* name;
    IBOutlet UITextView* address;
    IBOutlet UITextView* description;
    IBOutlet UIImageView* hostPic;
    IBOutlet UIView* loadingView;
    IBOutlet UIView* innerLoadingView;
    IBOutlet UIActivityIndicatorView* indicator;

}

-(LocationDetailsViewController*) initWithHostID:(NSNumber*) ID;

-(IBAction) backButtonPressed:(id)sender;
-(IBAction) connectToVenue:(id)sender;

@property (nonatomic, retain) IBOutlet UIBarButtonItem* BackButton;
@property (nonatomic, retain) NSNumber* hostID;

@property (nonatomic, retain) IBOutlet UILabel* name;
@property (nonatomic, retain) IBOutlet UITextView* address;
@property (nonatomic, retain) IBOutlet UITextView* description;
@property (nonatomic, retain) IBOutlet UIImageView* hostPic;
@property (nonatomic) BOOL inRange;

@end
