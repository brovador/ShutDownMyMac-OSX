//
//  SDMMPreferencesWindowController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 15/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "SDMMPreferencesRootViewController.h"
#import "SDMMPreferencesWindowController.h"

@interface SDMMPreferencesWindowController ()

@property (nonatomic, strong) SDMMPreferencesRootViewController *vcRoot;

@end

@implementation SDMMPreferencesWindowController


- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setTitle:NSLocalizedString(@"WINDOW_TITLE_PREFERENCES", @"")];
    
    self.vcRoot = [self.storyboard instantiateControllerWithIdentifier:@"VCPreferencesRoot"];
    _vcRoot.view.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
    self.window.contentView = _vcRoot.view;
    
}

@end
