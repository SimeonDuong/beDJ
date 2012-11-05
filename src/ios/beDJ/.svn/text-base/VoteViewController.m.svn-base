//
//  VoteViewController.m
//  beDJ
//
//  Created by Garrett Galow on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Playlist.h"

@implementation VoteViewController

@synthesize picker, castVoteButton, undoVoteButton, cancelButton, delegate, numVotes, song, backgroundView;

-(id) init {
    self = [super initWithNibName:@"VoteView" bundle:nil];
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Picker View Delegate Methods

//Returns the width for the component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 50;
}

//Retruns the height for a row for a component
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

//Returns the string title for the row
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d",row];
}

//what to do if anything when a row is selected?
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSLog(@"%d",row);
    numVotes = row;
    if (row == 1) {
        [castVoteButton setTitle:@"Cast Vote" forState:UIControlStateNormal];
        [undoVoteButton setTitle:@"Undo Vote" forState:UIControlStateNormal];
    } else {
        [castVoteButton setTitle:@"Cast Votes" forState:UIControlStateNormal];
        [undoVoteButton setTitle:@"Undo Votes" forState:UIControlStateNormal];
    }
    NSInteger songUserVotes = [[song valueForKey:@"uservotes"] intValue];
    NSInteger userVotes = [[[Playlist sharedPlaylist] userVotes] intValue];
    [undoVoteButton setEnabled:!((row) > songUserVotes)];
    [castVoteButton setEnabled:!((row) > userVotes)];
}

#pragma mark Picker View Data Source Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return MAX([[[Playlist sharedPlaylist] userVotes] intValue], [[song valueForKey:@"uservotes"] intValue])+1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark Button Methods

-(IBAction) cancelButtonPressed:(id)sender {
    [self.view removeFromSuperview];
}

-(IBAction) castVoteButtonPressed:(id)sender {
    if (numVotes == 0) {
        [self.view removeFromSuperview];
        return;
    }
    [[Playlist sharedPlaylist] castVote:[song valueForKey:@"SONG_id"] withVotes:[NSString stringWithFormat:@"%d",numVotes] withSender:delegate];
    
    [delegate startLoading];
    [self.view removeFromSuperview];
}

-(IBAction) undoVoteButtonPressed:(id)sender {
    if (numVotes == 0) {
        [self.view removeFromSuperview];
        return;
    }
    [[Playlist sharedPlaylist] undoVote:[song valueForKey:@"SONG_id"] withVotes:[NSString stringWithFormat:@"%d",numVotes] withSender:delegate];
    
    [delegate startLoading];
    [self.view removeFromSuperview];
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    cancelButton.layer.cornerRadius = 5.0;
//    [[self view] setBackgroundColor:[UIColor clearColor]];
}

-(void) viewDidAppear:(BOOL)animated {
    

    
//    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pickerBackground.png"]];
    


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
