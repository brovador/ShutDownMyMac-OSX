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
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownType;
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownTypeAsk;
@property (nonatomic, weak) IBOutlet NSMenuItem *miShutdownTypeNoAsk;
@property (nonatomic, weak) IBOutlet NSMenuItem *miPreferences;
@property (nonatomic, weak) IBOutlet NSMenuItem *miQuit;

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
        [_statusItem setImage:[NSImage imageNamed:@"StatusIcon"]];
        [_statusItem setMenu:_menu];
        
        [self _localizeView];
    }
    return self;
}

#pragma mark Private

- (void)_localizeView
{
    [_miLaunchAtLogin setTitle:NSLocalizedString(@"MI_LAUNCH_AT_LOGIN", @"")];
    [_miShutdownType setTitle:NSLocalizedString(@"MI_SHUTDOWN_TYPE", @"")];
    [_miShutdownTypeAsk setTitle:NSLocalizedString(@"MI_SHUTDOWN_TYPE_ASK", @"")];
    [_miShutdownTypeNoAsk setTitle:NSLocalizedString(@"MI_SHUTDOWN_TYPE_NO_ASK", @"")];
    [_miPreferences setTitle:NSLocalizedString(@"MI_PREFERENCES", @"")];
    [_miQuit setTitle:NSLocalizedString(@"MI_QUIT", @"")];
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
