//
//  SDMMUserPreferencesManager.h
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 8/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SDMMUserPreferenceIconPosition) {
    SDMMUserPreferenceIconPositionDock,
    SDMMUserPreferenceIconPositionTopBar
};

typedef NS_ENUM(NSUInteger, SDMMUserPreferenceShutdownType) {
    SDMMUserPreferenceShutdownTypeAsk,
    SDMMUserPreferenceShutdownTypeNoAsk
};

@interface SDMMUserPreferencesManager : NSObject

@property (nonatomic, assign) SDMMUserPreferenceShutdownType shutdownType;
@property (nonatomic, assign) SDMMUserPreferenceIconPosition iconPosition;
@property (nonatomic, assign) BOOL runAtStartup;

+ (instancetype)sharedManager;

@end
