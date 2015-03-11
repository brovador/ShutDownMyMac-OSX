//
//  SDMMBonjourHelper.h
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 11/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDMMBonjourHelperDelegate;

@interface SDMMBonjourHelper : NSObject

@property (nonatomic, assign) NSObject<SDMMBonjourHelperDelegate> *delegate;

- (void)startService:(NSString*)name type:(NSString*)type domain:(NSString*)domain;
- (void)stopService;

//TODO: implement bidirectional flow
//- (void)sendCommand:(NSString*)command;

@end


@protocol SDMMBonjourHelperDelegate<NSObject>

@optional
- (void)bonjourHelperDidStartService:(SDMMBonjourHelper*)bonjourHelper;
- (void)bonjourHelperDidStopService:(SDMMBonjourHelper*)bonjourHelper;
- (void)bonjourHelper:(SDMMBonjourHelper*)bonjourHelper didReceiveCommand:(NSString*)command;


@end
