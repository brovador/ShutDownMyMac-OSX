//
//  AppDelegate.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "AppDelegate.h"
#import "SDMMServiceManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[SDMMServiceManager sharedServiceManager] startService];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[SDMMServiceManager sharedServiceManager] startService];
}

@end
