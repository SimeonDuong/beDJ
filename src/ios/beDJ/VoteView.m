//
//  VoteView.m
//  beDJ
//
//  Created by Garrett Galow on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoteView.h"
#import <QuartzCore/QuartzCore.h>
#import "Playlist.h"
#import "ThirdViewController.h"
#import "SecondViewController.h"

@implementation VoteView

@synthesize picker, castVoteButton, undoVoteButton, cancelButton, delegate, numVotes, song;

-(id) init {
    self = [super init];
    if (self) {
        cancelButton.layer.cornerRadius = 5.0;
        cancelButton.layer.masksToBounds = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        cancelButton.layer.cornerRadius = 5.0;
        cancelButton.layer.masksToBounds = YES;
    }
    return self;
}

-(void) setInitialVoteValue {
    [self pickerView:picker didSelectRow:0 inComponent:0];
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
    
    [[[pickerView subviews] objectAtIndex:0] setHidden:YES];
    [[[pickerView subviews] objectAtIndex:[[pickerView subviews] count] - 1] setHidden:YES];
    
//    CGRect rect = CGRectMake(0, 0, 1, 1);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor colorWithPatternImage:[UIImage imageNamed:@"tableCellGradient.png"]] CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [pickerView insertSubview:[[UIImageView alloc] initWithImage:img] atIndex:0];
    
    return [NSString stringWithFormat:@"%d",row+1];
}

//what to do if anything when a row is selected?
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSLog(@"%d",row);
    numVotes = row+1;
    if (row == 0) {
        [castVoteButton setTitle:@"Cast Vote" forState:UIControlStateNormal];
        [undoVoteButton setTitle:@"Undo Vote" forState:UIControlStateNormal];
    } else {
        [castVoteButton setTitle:@"Cast Votes" forState:UIControlStateNormal];
        [undoVoteButton setTitle:@"Undo Votes" forState:UIControlStateNormal];
    }
    NSInteger songUserVotes = [[song valueForKey:@"uservotes"] intValue];
    NSInteger userVotes = [[[Playlist sharedPlaylist] userVotes] intValue];
    if (songUserVotes == 0) {
        [undoVoteButton setEnabled:NO];
    } else {
        [undoVoteButton setEnabled:!((row) > songUserVotes)];
    }
    
    if (userVotes == 0) {
        [castVoteButton setEnabled:NO];
    } else {
        [castVoteButton setEnabled:!((row) > userVotes)];
    }
    
}

#pragma mark Picker View Data Source Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return MAX([[[Playlist sharedPlaylist] userVotes] intValue], [[song valueForKey:@"uservotes"] intValue]);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark Private Methods

-(void) animateAway {
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(){
        [self setCenter:CGPointMake(160, 480+self.bounds.size.height/2)];
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    if ([delegate respondsToSelector:@selector(playlistTable)] && [delegate respondsToSelector:@selector(selectedPath)]) {
        [[delegate playlistTable] deselectRowAtIndexPath:[delegate selectedPath] animated:YES];
    }
}

#pragma mark Button Methods

-(IBAction) cancelButtonPressed:(id)sender {
    [self animateAway];
}

-(IBAction) castVoteButtonPressed:(id)sender {
    if (numVotes != 0) {
        [[Playlist sharedPlaylist] castVote:[song valueForKey:@"SONG_id"] withVotes:[NSString stringWithFormat:@"%d",numVotes] withSender:delegate];
        [delegate startLoading];
    }
   
    [self animateAway];
}

-(IBAction) undoVoteButtonPressed:(id)sender {
    if (numVotes != 0) {
        [[Playlist sharedPlaylist] undoVote:[song valueForKey:@"SONG_id"] withVotes:[NSString stringWithFormat:@"%d",numVotes] withSender:delegate];
        [delegate startLoading];
    }

    [self animateAway];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
