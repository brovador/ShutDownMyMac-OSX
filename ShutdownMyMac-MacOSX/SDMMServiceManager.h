//
//  SDMMServiceManager.h
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SDMMServiceManagerErrorDomain;
extern NSInteger const SDMMServiceManagerErrorCodeCommandNotFound;
extern NSInteger const SDMMServiceManagerErrorCodeCommandError;

@interface SDMMServiceManager : NSObject

+ (instancetype)sharedServiceManager;

- (void)startService;
- (void)stopService;

@end
