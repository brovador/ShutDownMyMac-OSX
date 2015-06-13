//
//  SDMMPreferencesDevicesViewController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 12/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SDMMPreferencesDevicesViewController.h"
#import "SDMMUserPreferencesManager.h"

@interface SDMMPreferencesDevicesViewController() <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, weak) IBOutlet NSTableView *tblDevices;
@property (nonatomic, weak) IBOutlet NSButton *btnRemoveSelected;

@end

@implementation SDMMPreferencesDevicesViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setTitle:NSLocalizedString(@"TAB_DEVICES", @"")];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUserPreferencesUpdated:)
                                                 name:SDMMUserPreferencesManagerUpdatedNotification
                                               object:nil];
    
    [self _localizeView];
    [self _updateView];
}

#pragma mark Private

- (void)_updateView
{
    NSIndexSet *selectedIndexes = [_tblDevices selectedRowIndexes];
    _btnRemoveSelected.enabled = (selectedIndexes.count > 0);
}

- (void)_localizeView
{
    [_btnRemoveSelected setTitle:NSLocalizedString(@"BTN_REMOVE_SELECTED", @"")];
}

#pragma mark NSTableViewDelegate

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if (notification.object == _tblDevices) {
        [self _updateView];
    }
}

#pragma mark IBActions

- (IBAction)removeSelected:(id)sender
{
    SDMMUserPreferencesManager *prefsMgr = [SDMMUserPreferencesManager sharedManager];
    NSInteger selectedIdx = [_tblDevices selectedRow];
    NSString *selectedName = [[prefsMgr pairedDevices] objectAtIndex:selectedIdx];
    [prefsMgr removeDevice:selectedName];
}

#pragma mark NSTableViewDataSource

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSArray *pairedDevices = [[SDMMUserPreferencesManager sharedManager] pairedDevices];
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"cell" owner:self];
    cell.textField.stringValue = pairedDevices[row];
    return cell;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[[SDMMUserPreferencesManager sharedManager] pairedDevices] count];
}

#pragma mark Notifications

- (void)onUserPreferencesUpdated:(NSNotification*)notification
{
    [_tblDevices reloadData];
    [self _updateView];
}

@end
