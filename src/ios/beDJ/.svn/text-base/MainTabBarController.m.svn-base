//
//  MainTabBarController.m
//  beDJ
//
//  Created by Garrett Galow on 3/27/12.
//  Copyright (c) 2012 Symplexum LLC. All rights reserved.
//

#import "MainTabBarController.h"
#import "LoadScreenViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

//Controls if the load screen should display
BOOL loadScreenShown = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
//{
//    [viewController viewWillAppear:animated];
//}
//
//-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
//{
//    [viewController viewDidAppear:animated];
//}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {  
//    [viewController viewWillAppear:NO];  
//    [viewController viewDidAppear:NO];
//}  

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    self.delegate = self;
}

//-(void) viewWillAppear:(BOOL)animated {
//        [self.selectedViewController viewWillAppear:animated];
//}

-(void) viewDidAppear:(BOOL)animated {
    if (loadScreenShown == NO) {
        //Load screen has not been shown. Initialize it and display it.
        
//        UIViewController* loadScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadScreen"];
        LoadScreenViewController* loadScreen = [[LoadScreenViewController alloc] init];
//        [UIView beginAnimations:@"animation" context:nil];
        [self.navigationController pushViewController:loadScreen animated:NO];

//        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO]; 
//        [UIView commitAnimations];
        
//        [self.navigationController presentViewController:loadScreen animated:YES completion:^(void) {
//            NSLog(@"IT WORKED!");
//        }];
        loadScreenShown = YES;
    } else {
        //App has loaded go to the selected screen.
        [self.selectedViewController viewDidAppear:animated];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
