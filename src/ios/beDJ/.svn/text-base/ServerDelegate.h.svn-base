//
//  ServerDelegate.h
//  beDJ
//
//  Created by Garrett Galow on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequestType.h"

//Need to add some sort of error reporting method for a call failed

@protocol ServerDelegate <NSObject>
@required
- (void) serverResponse:(NSMutableDictionary*) responseData forRequest:(ServerRequestType) requestType;
@end