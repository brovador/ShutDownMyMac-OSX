//
//  SDMMPreferencesAboutViewController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 15/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "NSAttributedString+Hyperlink.h"
#import "SDMMPreferencesAboutViewController.h"


@interface SDMMPreferencesAboutViewController ()

@property (nonatomic, weak) IBOutlet NSTextField *tfAppName;
@property (nonatomic, weak) IBOutlet NSTextField *tfVersion;
@property (nonatomic, weak) IBOutlet NSTextField *tfCreatedBy;

@end

@implementation SDMMPreferencesAboutViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setTitle:NSLocalizedString(@"TAB_ABOUT", @"")];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _updateView];
}

#pragma mark Private

- (void)_updateView
{
    NSString *createdBy = NSLocalizedString(@"CREATED_BY", @"");
    NSMutableAttributedString *createdByString = [[NSMutableAttributedString alloc] initWithString:createdBy];
    
#warning FIXME: improve hyperlink
    NSURL *url = [NSURL URLWithString:@"http://github.com/brovador"];
    NSAttributedString *creatorString = [NSAttributedString hyperlinkFromString:@"brovador" withURL:url];
    [createdByString appendAttributedString:creatorString];
    [_tfCreatedBy setAllowsEditingTextAttributes: YES];
    [_tfCreatedBy setSelectable: YES];
    [_tfCreatedBy setAttributedStringValue:createdByString];
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];;
    [_tfAppName setStringValue:appName];
    
    NSString *version =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    [_tfVersion setStringValue:version];
}

@end
