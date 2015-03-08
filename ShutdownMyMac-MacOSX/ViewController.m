//
//  ViewController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "ViewController.h"
#import "SDMMServiceManager.h"
#import "LSHelper.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet NSButton *btnStartupAtLogin;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([LSHelper isLoginItemEnabledForAppPath:[[NSBundle mainBundle] bundlePath]]) {
        [_btnStartupAtLogin setState:NSOnState];
    } else {
        [_btnStartupAtLogin setState:NSOffState];
    }
}

- (IBAction)toggleAddToStartupItems:(id)sender
{
    NSButton *bt = (NSButton*)sender;
    [LSHelper enableLoginItem:(bt.state == NSOnState) withAppPath:[[NSBundle mainBundle] bundlePath]];
}

@end
