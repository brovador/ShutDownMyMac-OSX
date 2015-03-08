//
//  SDMMPreferencesRootViewController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 8/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "SDMMPreferencesRootViewController.h"

@interface SDMMPreferencesRootViewController ()

@property (nonatomic, assign) IBOutlet NSView *vPreferencesContainer;

@end

@implementation SDMMPreferencesRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSViewController *vcPreferences = [self.storyboard instantiateControllerWithIdentifier:@"VCPreferencesTabs"];
    vcPreferences.view.frame = _vPreferencesContainer.bounds;
    [self addChildViewController:vcPreferences];
    [_vPreferencesContainer addSubview:vcPreferences.view];
}

@end
