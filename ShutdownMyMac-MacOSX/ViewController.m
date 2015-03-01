//
//  ViewController.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "ViewController.h"
#import "SDMMServiceManager.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SDMMServiceManager sharedServiceManager] startService];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
