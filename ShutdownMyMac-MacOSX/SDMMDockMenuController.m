//
//  SDMMDockMenuController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 10/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "AppDelegate.h"
#import "SDMMDockMenuController.h"
#import "SDMMUserPreferencesManager.h"

@interface SDMMDockMenuController ()<NSUserInterfaceValidations>

@property (nonatomic, strong) NSArray *topNibObjects;

@property (nonatomic, weak) IBOutlet NSMenuItem *miPreferences;
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownType;
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownTypeAsk;
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownTypeNoAsk;

@end

@implementation SDMMDockMenuController

- (id)init
{
    self = [super init];
    if (self) {
        
        NSArray *topNibObjects = nil;
        [[NSBundle mainBundle] loadNibNamed:@"DockMenu" owner:self topLevelObjects:&topNibObjects];
        
        self.topNibObjects = topNibObjects;
        
        [self _localizeView];
    }
    return self;
}

#pragma mark Private

- (void)_localizeView
{
    [_miShutdownType setTitle:NSLocalizedString(@"MI_SHUTDOWN_TYPE", @"")];
    [_miShutdownTypeAsk setTitle:NSLocalizedString(@"MI_SHUTDOWN_TYPE_ASK", @"")];
    [_miShutdownTypeNoAsk setTitle:NSLocalizedString(@"MI_SHUTDOWN_TYPE_NO_ASK", @"")];
    [_miPreferences setTitle:NSLocalizedString(@"MI_PREFERENCES", @"")];
}

#pragma mark IBActions

- (IBAction)setShutdownTypeAsk:(id)sender
{
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    prefsManager.shutdownType = SDMMUserPreferenceShutdownTypeAsk;
}


- (IBAction)setShutdownTypeNoAsk:(id)sender
{
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    prefsManager.shutdownType = SDMMUserPreferenceShutdownTypeNoAsk;
}


- (IBAction)showPreferences:(id)sender
{
    [(AppDelegate*)[[NSApplication sharedApplication] delegate] showPreferencesWindow:sender];
}


#pragma mark NSUserInterfaceValidation

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
{
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    
    if (anItem == _miShutdownTypeAsk) {
        [_miShutdownTypeAsk setState:(prefsManager.shutdownType == SDMMUserPreferenceShutdownTypeAsk)?NSOnState:NSOffState];
    } else if (anItem == _miShutdownTypeNoAsk) {
        [_miShutdownTypeNoAsk setState:(prefsManager.shutdownType == SDMMUserPreferenceShutdownTypeNoAsk)?NSOnState:NSOffState];
    }
    
    return YES;
}

@end
