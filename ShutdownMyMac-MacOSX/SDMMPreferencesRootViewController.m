//
//  SDMMPreferencesRootViewController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 8/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "SDMMPreferencesRootViewController.h"

const NSInteger SDMMPreferencesTabGeneral = 0;
const NSInteger SDMMPreferencesTabDevices = 1;
const NSInteger SDMMPreferencesTabAbout = 2;

@interface SDMMPreferencesRootViewController ()

@property (nonatomic, assign) IBOutlet NSTabViewController *vcPreferencesTabs;
@property (nonatomic, assign) IBOutlet NSView *vPreferencesContainer;

@end

@implementation SDMMPreferencesRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vcPreferencesTabs = [self.storyboard instantiateControllerWithIdentifier:@"VCPreferencesTabs"];
    _vcPreferencesTabs.view.frame = _vPreferencesContainer.bounds;
    [self addChildViewController:_vcPreferencesTabs];
    [_vPreferencesContainer addSubview:_vcPreferencesTabs.view];
}


- (void)showTab:(NSInteger)tabIndex
{
    [_vcPreferencesTabs setSelectedTabViewItemIndex:tabIndex];
}

@end
