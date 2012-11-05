//
//  DJPullToRefreshContentView.m
//  beDJ
//
//  Created by Garrett Galow on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DJPullToRefreshContentView.h"

@implementation DJPullToRefreshContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        super.statusLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view {
    
    //statusLabel
    //lastUpdatedAtLabel
    //activityIndicatorView
    
    switch (state) {
        case SSPullToRefreshViewStateNormal:
            /// Most will say "Pull to refresh" in this state
            super.statusLabel.text = @"Pull to refresh.";
//            super.statusLabel.textColor = [UIColor whiteColor];
            break;
        case SSPullToRefreshViewStateReady:
            /// Most will say "Release to refresh" in this state
            super.statusLabel.text = @"Release to refresh.";
//            super.statusLabel.textColor = [UIColor whiteColor];
            break;
        case SSPullToRefreshViewStateLoading:
            /// The view is loading
            super.statusLabel.text = @"Loading...";
            super.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [super.activityIndicatorView startAnimating];
//            super.statusLabel.textColor = [UIColor whiteColor];
            break;
        case SSPullToRefreshViewStateClosing:
            /// The view has finished loading and is animating
            super.statusLabel.text = @"Refresh Complete.";
            [super setLastUpdatedAt:[NSDate date] withPullToRefreshView:view];
            [super.activityIndicatorView stopAnimating];
            break;
        default:
            break;
    }
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
