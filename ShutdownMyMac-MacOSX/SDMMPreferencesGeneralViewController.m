//
//  ViewController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "SDMMPreferencesGeneralViewController.h"
#import "SDMMServiceManager.h"
#import "SDMMUserPreferencesManager.h"

static NSInteger const TagIconPositionTopMenu = 0;
static NSInteger const TagIconPositionDock = 1;

static NSInteger const TagShutdownTypeAsk = 0;
static NSInteger const TagShutdownTypeNoAsk = 1;

@interface SDMMPreferencesGeneralViewController ()

@property (nonatomic, weak) IBOutlet NSButton *btnStartupAtLogin;

@property (nonatomic, weak) IBOutlet NSMatrix *matIconPosition;
@property (nonatomic, weak) IBOutlet NSTextField *tfIconPositionDescription;

@property (nonatomic, weak) IBOutlet NSMatrix *matShutdownType;
@property (nonatomic, weak) IBOutlet NSTextField *tfShutdownTypeDescription;

@end

@implementation SDMMPreferencesGeneralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _updateView];
}

#pragma mark IBActions

- (IBAction)toggleAddToStartupItems:(id)sender
{
    NSButton *bt = (NSButton*)sender;
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    prefsManager.runAtStartup = (bt.state == NSOnState);
}


- (IBAction)toggleIconPosition:(id)sender
{
    NSMatrix *matrix = (NSMatrix*)sender;
    NSButtonCell *cell = [matrix selectedCell];
    NSInteger selectedTag = [cell tag];
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    
    if (selectedTag == TagIconPositionDock) {
        prefsManager.iconPosition = SDMMUserPreferenceIconPositionDock;
    } else if (selectedTag == TagIconPositionTopMenu) {
        prefsManager.iconPosition = SDMMUserPreferenceIconPositionTopBar;
    }
    [self _updateView];
}


- (IBAction)toggleShutdownType:(id)sender
{
    NSMatrix *matrix = (NSMatrix*)sender;
    NSButtonCell *cell = [matrix selectedCell];
    NSInteger selectedTag = [cell tag];
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    
    if (selectedTag == TagShutdownTypeNoAsk) {
        prefsManager.shutdownType = SDMMUserPreferenceShutdownTypeNoAsk;
    } else if (selectedTag == TagShutdownTypeAsk) {
        prefsManager.shutdownType = SDMMUserPreferenceShutdownTypeAsk;
    }
    [self _updateView];
}


#pragma mark Private

- (void)_updateView
{
    SDMMUserPreferencesManager *prefsManager = [SDMMUserPreferencesManager sharedManager];
    _btnStartupAtLogin.state = (prefsManager.runAtStartup)?NSOnState:NSOffState;
    
    if (prefsManager.iconPosition == TagIconPositionDock) {
        [_matIconPosition selectCellAtRow:TagIconPositionDock column:0];
        [_tfIconPositionDescription setStringValue:NSLocalizedString(@"ICON_POSITION_DOCK_DESCRIPTION", @"")];
    } else if (prefsManager.iconPosition == TagIconPositionTopMenu) {
        [_matIconPosition selectCellAtRow:TagIconPositionTopMenu column:0];
        [_tfIconPositionDescription setStringValue:NSLocalizedString(@"ICON_POSITION_TOP_MENU_DESCRIPTION", @"")];
    }
    
    if (prefsManager.shutdownType == TagShutdownTypeAsk) {
        [_matShutdownType selectCellAtRow:TagShutdownTypeAsk column:0];
        [_tfShutdownTypeDescription setStringValue:NSLocalizedString(@"SHUTDOWN_TYPE_ASK_DESCRIPTION", @"")];
    } else if (prefsManager.shutdownType == TagShutdownTypeNoAsk) {
        [_matShutdownType selectCellAtRow:TagShutdownTypeNoAsk column:0];
        [_tfShutdownTypeDescription setStringValue:NSLocalizedString(@"SHUTDOWN_TYPE_NO_ASK_DESCRIPTION", @"")];
    }
}

@end
