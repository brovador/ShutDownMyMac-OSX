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

@interface AppDelegate ()

@property (nonatomic, strong) NSWindowController *wcPreferences;
@property (nonatomic, strong) SDMMStatusMenuController *statusMenuController;
@property (nonatomic, strong) SDMMDockMenuController *dockMenuController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self _initializeDockIcon];
    [self _initializeStatusMenu];
    
    [[SDMMServiceManager sharedServiceManager] startService];
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
