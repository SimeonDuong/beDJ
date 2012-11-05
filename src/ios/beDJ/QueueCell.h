//
//  QueueCell.h
//  QuTrack
//
//  Created by Garrett Galow on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueueCell : UITableViewCell {
    
    IBOutlet UILabel* title;
    IBOutlet UILabel* artist;
    IBOutlet UILabel* votes;
    IBOutlet UILabel* selfVotes;
    IBOutlet UIImageView* songImage;
}

@property (nonatomic, retain) IBOutlet UILabel* title;
@property (nonatomic, retain) IBOutlet UILabel* artist;
@property (nonatomic, retain) IBOutlet UILabel* votes;
@property (nonatomic, retain) IBOutlet UILabel* selfVotes;
@property (nonatomic, retain) IBOutlet UIImageView* songImage;

@end
