//
//  SDMMStatusMenuController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 8/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "AppDelegate.h"
#import "SDMMStatusMenuController.h"
#import "SDMMUserPreferencesManager.h"

static NSInteger const TagMenuItemLaunchAtLogin = 0;
static NSInteger const TagMenuItemShutdownTypeAsk = 3;
static NSInteger const TagMenuItemShutdownTypeNoAsk = 4;

@interface SDMMStatusMenuController () <NSUserInterfaceValidations>

@property (nonatomic, weak) IBOutlet NSMenuItem *miLaunchAtLogin;
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownTypeAsk;
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownTypeNoAsk;

@end

@implementation SDMMStatusMenuController

- (id)init
{
    self = [super init];
    if (self) {
        
        [[NSBundle mainBundle] loadNibNamed:@"StatusItemMenu" owner:self topLevelObjects:NULL];
        
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        _statusItem.title = @"ShutdownMyMac";
        [_statusItem setMenu:_statusItemMenu];
    }
    return self;
}

#pragma mark IBActions

- (IBAction)toggleLaunchAtLogin:(id)sender
{
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    prefsManager.runAtStartup = !(prefsManager.runAtStartup);
}


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


- (IBAction)quitApplication:(id)sender
{
    [[NSApplication sharedApplication] terminate:sender];
}

#pragma mark NSUserInterfaceValidation

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
{
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    
    if (anItem == _miLaunchAtLogin) {
        [_miLaunchAtLogin setState:(prefsManager.runAtStartup)?NSOnState:NSOffState];
    } else if (anItem == _miShutdownTypeAsk) {
        [_miShutdownTypeAsk setState:(prefsManager.shutdownType == SDMMUserPreferenceShutdownTypeAsk)?NSOnState:NSOffState];
    } else if (anItem == _miShutdownTypeNoAsk) {
        [_miShutdownTypeNoAsk setState:(prefsManager.shutdownType == SDMMUserPreferenceShutdownTypeNoAsk)?NSOnState:NSOffState];
    }
    
    return YES;
}

@end
