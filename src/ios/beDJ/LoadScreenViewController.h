//
//  LoadScreenViewController.h
//  beDJ
//
//  Created by Garrett Galow on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerDelegate.h"

@interface LoadScreenViewController : UIViewController <ServerDelegate> {
    IBOutlet UIActivityIndicatorView* indicator;
}

-(void) loginGranted;

-(id) init;

@end
