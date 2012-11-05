//
//  AppDelegate.m
//  QuTrack
//
//  Created by Garrett Galow on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVAudioSession.h>
#import "NoConnectionViewController.h"
#import "Venues.h"
#import "Server.h"
#import "HostManager.h"

@implementation AppDelegate

@synthesize window = _window;

-(void)checkForConnection {
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
//            NSLog(@"The internet is down.");
            NoConnectionViewController* noInternetController = [[NoConnectionViewController alloc] init];
//            self.internetActive = NO;
            [((UINavigationController*)self.window.rootViewController) pushViewController:noInternetController animated:YES];
            
            break;
        }
        case ReachableViaWiFi:
        {
//            NSLog(@"The internet is working via WIFI.");
//            self.internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
//            NSLog(@"The internet is working via WWAN.");
//            self.internetActive = YES;
            
            break;
        }
    }

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: NULL];
    [[AVAudioSession sharedInstance] setActive: YES error: NULL];
    
    //Start a check for if the internet is reachable
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForConnection) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[AVAudioSession sharedInstance] setActive: YES error: NULL];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    if ([[Venues sharedVenues] currentVenue] != nil) {
        [[Server sharedInstance] leaveLocationForHost:[[[Venues sharedVenues] currentVenue] valueForKey:@"HOST_id"] User:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_id"] withSender:[NSNull null]];
    }
    if ([[HostManager sharedHostManager] isHostActive]) {
        [[Server sharedInstance] disconnectHost:[[[HostManager sharedHostManager] hostInfo] valueForKey:@"HOST_id"] withSender:[NSNull null]];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
