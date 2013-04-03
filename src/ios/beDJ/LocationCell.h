//
//  LocationCell.h
//  beDJ
//
//  Created by Garrett Galow on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell {
    
    IBOutlet UIImageView* locationImage;
    IBOutlet UIImageView* detailImage;
    IBOutlet UILabel* locName;
}

@property (nonatomic, retain) IBOutlet UIImageView* locationImage;
@property (nonatomic, retain) IBOutlet UIImageView* detailImage;
@property (nonatomic, retain) IBOutlet UILabel* locName;
@property (nonatomic, retain) IBOutlet UILabel* distanceLabel;

@end
