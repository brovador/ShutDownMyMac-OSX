//
//  AppDelegate.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "AppDelegate.h"
#import "SDMMDockMenuController.h"
#import "SDMMServiceManager.h"
#import "SDMMStatusMenuController.h"
#import "SDMMUserPreferencesManager.h"

@interface AppDelegate ()<NSAlertDelegate>

@property (nonatomic, strong) NSWindowController *wcPreferences;
@property (nonatomic, strong) SDMMStatusMenuController *statusMenuController;
@property (nonatomic, strong) SDMMDockMenuController *dockMenuController;

@end

@implementation AppDelegate

+ (instancetype)currentAppDelegate
{
    return (AppDelegate*)([[NSApplication sharedApplication] delegate]);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self _initializeDockIcon];
    [self _initializeStatusMenu];
    
    [[SDMMServiceManager sharedServiceManager] startService];
    [self showPreferencesWindow:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[SDMMServiceManager sharedServiceManager] stopService];
}


-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    BOOL result = YES;
    if (!flag) {
        [self showPreferencesWindow:sender];
        result = NO;
    }
    return result;
}


- (NSMenu *)applicationDockMenu:(NSApplication *)sender
{
    return _dockMenuController.dockMenu;
}


#pragma mark Public

- (IBAction)showPreferencesWindow:(id)sender
{
    if (_wcPreferences == nil) {
        NSStoryboard *mainStoryBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        NSWindowController *wcPreferences = [mainStoryBoard instantiateControllerWithIdentifier:@"WCPreferences"];
        self.wcPreferences = wcPreferences;
    }
    
    [NSApp activateIgnoringOtherApps:YES];
    [_wcPreferences showWindow:sender];
    [[_wcPreferences window] makeKeyAndOrderFront:sender];
}


- (IBAction)showPairingAlertForDevice:(NSString *)device onAccept:(void(^)(void))onAccept onCancel:(void(^)(void))onCancel
{
    NSString *message = NSLocalizedString(@"ALERT_PAIR_MESSAGE", @"");
    message = [message stringByReplacingOccurrencesOfString:@"<device>" withString:device];
    
    NSAlert *alert = [NSAlert new];
    [alert setMessageText:NSLocalizedString(@"ALERT_PAIR_TITLE", @"")];
    [alert setInformativeText:message];
    [alert addButtonWithTitle:NSLocalizedString(@"BTN_ALERT_PAIR_CONTINUE", @"")];
    [alert addButtonWithTitle:NSLocalizedString(@"BTN_ALERT_PAIR_CANCEL", @"")];
    [alert setAlertStyle:NSAlertFirstButtonReturn];
    [alert setDelegate:self];
    
    NSModalResponse modalResponse = [alert runModal];
    
    if (modalResponse == NSAlertFirstButtonReturn && onAccept != NULL) {
        onAccept();
    } else if (onCancel != NULL) {
        onCancel();
    }
}

#pragma mark Private


- (void)_initializeDockIcon
{
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    if (prefsManager.iconPosition == SDMMUserPreferenceIconPositionDock) {
        
        self.dockMenuController = [SDMMDockMenuController new];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    }
}

- (void)_initializeStatusMenu
{
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    if (prefsManager.iconPosition == SDMMUserPreferenceIconPositionTopBar) {
        self.statusMenuController = [SDMMStatusMenuController new];
    }
}


@end
