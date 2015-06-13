//
//  SDMMPreferencesRootViewController.h
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 8/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern const NSInteger SDMMPreferencesTabGeneral;
extern const NSInteger SDMMPreferencesTabDevices;
extern const NSInteger SDMMPreferencesTabAbout;

@interface SDMMPreferencesRootViewController : NSViewController

- (void)showTab:(NSInteger)tabIndex;

@end
