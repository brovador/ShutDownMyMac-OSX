//
//  SDMMPreferencesWindowController.h
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 15/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SDMMPreferencesRootViewController;

@interface SDMMPreferencesWindowController : NSWindowController

@property (nonatomic, readonly) SDMMPreferencesRootViewController *vcRoot;

@end
