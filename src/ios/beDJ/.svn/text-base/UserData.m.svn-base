//
//  UserData.m
//  beDJ
//
//  Created by Garrett Galow on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserData.h"

//@implementation UserData
//
//@synthesize userID, userData;
//
//NSString* userDataPath;
//
//static UserData* sharedInstance = nil;
//
//#pragma mark Singleton Methods
//
//+(UserData*) sharedInstance {
//    if(sharedInstance == nil) {
//        sharedInstance = [[super allocWithZone:NULL] init];
//    }
//    return sharedInstance;
//}
//
//- (id)init
//{
//    self = [super init];
//    
//    if (self) {
//        [self initUserData];
//    }
//    
//    return self;
//}
//
//+ (id)allocWithZone:(NSZone*)zone {
//    return [self sharedInstance];
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//    return self;
//}
//
//-(void) initUserData {
//    
//    NSPropertyListFormat propFormat;
//    NSString* documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    userDataPath = [documentsDirectoryPath stringByAppendingPathComponent:@"userData.plist"];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:userDataPath]) {
//       [[NSFileManager defaultManager] createFileAtPath:userDataPath contents:nil attributes:nil];
//        userData = [[NSMutableDictionary alloc] init];
//    } else {
//        userData = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:userDataPath] mutabilityOption:0 format:&propFormat errorDescription:nil];
//        if (userData == nil) {
//            userData = [[NSMutableDictionary alloc] init];
//        }
//        userID = [userData objectForKey:@"userID"];
//    }
//}
//
//-(BOOL) setLoginData:(NSString *)username :(NSString *)password :(NSString*) USER_id{
//    
//    if (!([username isEqual:nil] || [password isEqual:nil] || [USER_id isEqual:nil])) {
//        [userData setObject:username forKey:@"username"];
//        [userData setObject:password forKey:@"password"];
//        [userData setObject:[NSNumber numberWithInt:[USER_id intValue]] forKey:@"userID"];
//        return YES;
//    } else { return NO; }
//    
//}
//
//-(BOOL) saveUserData {
//    NSString* errorDescription;
//    NSError* error;
//    NSData* dataToSave = [NSPropertyListSerialization dataFromPropertyList:userData format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDescription];
//    BOOL success = [dataToSave writeToFile:userDataPath options:NSDataWritingFileProtectionNone error:&error];
//    return success;
//}
//
//-(NSDictionary*) readLoginData {
//    
//    return [userData dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"username",@"password", nil]];
//}
//
//@end
