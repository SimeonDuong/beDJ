//
//  AppDelegate.h
//  QuTrack
//
//  Created by Garrett Galow on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    Reachability* internetReachable;
    Reachability* hostReachable;
}

@property (strong, nonatomic) UIWindow *window;

-(void) checkForConnection;

@end
