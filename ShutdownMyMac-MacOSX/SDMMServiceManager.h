//
//  SDMMServiceManager.h
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDMMServiceManagerDelegate;

@interface SDMMServiceManager : NSObject

@property (nonatomic, weak) NSObject<SDMMServiceManagerDelegate>* delegate;

+ (instancetype)sharedServiceManager;
- (void)startService;
- (void)stopService;

- (void)sendCommand:(NSString*)command;

@end


@protocol SDMMServiceManagerDelegate<NSObject>

- (void)serviceManagerInitialized:(SDMMServiceManager*)serviceManager;
- (void)serviceManagerDidFail:(SDMMServiceManager*)serviceManager;

@end
