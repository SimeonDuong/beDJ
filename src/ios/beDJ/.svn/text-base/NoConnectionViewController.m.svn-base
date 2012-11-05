//
//  NoConnectionViewController.m
//  beDJ
//
//  Created by Garrett Galow on 4/12/12.
//  Copyright (c) 2012 Symplexum LLC. All rights reserved.
//
// Implementation file for the view controller that displays when there is no active internet connection

#import "NoConnectionViewController.h"

@interface NoConnectionViewController ()

@end

@implementation NoConnectionViewController

-(id) init {
    self = [super initWithNibName:@"NoConnectionViewController" bundle:nil];
    if (self)
    {
        // Further initialization if needed
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction) OKButtonPressed:(id)sender {
    //Pop this viewController of the view stack.
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
