//
//  AppDelegate.h
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

+ (instancetype)currentAppDelegate;

- (IBAction)showPairingAlertForDevice:(NSString *)device onAccept:(void(^)(void))onAccept onCancel:(void(^)(void))onCancel;
- (IBAction)showPreferencesWindow:(id)sender;

@end

