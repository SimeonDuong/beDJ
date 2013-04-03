//
//  VoteView.h
//  beDJ
//
//  Created by Garrett Galow on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    IBOutlet UIPickerView* picker;
    IBOutlet UIButton* castVoteButton;
    IBOutlet UIButton* undoVoteButton;
    IBOutlet UIButton* cancelButton;
    IBOutlet UIView* backgroundView;
    
    NSInteger numVotes;
    NSDictionary* song;
    id delegate;
}
-(void) setInitialVoteValue;

-(IBAction) cancelButtonPressed:(id)sender;
-(IBAction) castVoteButtonPressed:(id)sender;
-(IBAction) undoVoteButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIPickerView* picker;
@property (retain, nonatomic) IBOutlet UIButton* castVoteButton;
@property (retain, nonatomic) IBOutlet UIButton* undoVoteButton;
@property (retain, nonatomic) IBOutlet UIButton* cancelButton;
@property (nonatomic) NSInteger numVotes;
@property (retain, nonatomic) NSDictionary* song;
@property (retain, nonatomic) id delegate;

@end
