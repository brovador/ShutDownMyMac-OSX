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

@interface SDMMStatusMenuController () <NSUserInterfaceValidations>

@property (nonatomic, strong) NSArray *topNibObjects;

@property (nonatomic, weak) IBOutlet NSMenuItem *miLaunchAtLogin;
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownTypeAsk;
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownTypeNoAsk;

@end

@implementation SDMMStatusMenuController

- (id)init
{
    self = [super init];
    if (self) {
        
        NSArray *topNibObjects = nil;
        [[NSBundle mainBundle] loadNibNamed:@"StatusItemMenu" owner:self topLevelObjects:&topNibObjects];
        self.topNibObjects = topNibObjects;
        
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        _statusItem.title = @"SMM";
        [_statusItem setMenu:_menu];
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
