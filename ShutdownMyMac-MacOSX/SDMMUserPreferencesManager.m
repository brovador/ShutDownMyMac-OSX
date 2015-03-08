//
//  SDMMUserPreferencesManager.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 8/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "LSHelper.h"
#import "SDMMUserPreferencesManager.h"


static NSString * const SDMMUserPreferencesManagerShutdownTypeKey = @"SDMMUserPreferencesManagerShutdownTypeKey";
static NSString * const SDMMUserPreferencesManagerIconPositionKey = @"SDMMUserPreferencesManagerIconPositionKey";

static SDMMUserPreferencesManager *sharedInstance;

@implementation SDMMUserPreferencesManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SDMMUserPreferencesManager new];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        id storedKey = nil;
        storedKey = [userDefaults objectForKey:SDMMUserPreferencesManagerShutdownTypeKey];
        
        if (storedKey != nil) {
            self.shutdownType = [storedKey intValue];
        } else {
            self.shutdownType = SDMMUserPreferenceShutdownTypeAsk;
        }
        
        storedKey = [userDefaults objectForKey:SDMMUserPreferencesManagerIconPositionKey];
        if (storedKey != nil) {
            self.iconPosition = [storedKey intValue];
        } else {
            self.iconPosition = SDMMUserPreferenceIconPositionDock;
        }
        
        self.runAtStartup = [LSHelper isLoginItemEnabledForAppPath:[[NSBundle mainBundle] bundlePath]];
    }
    return self;
}


- (void)setShutdownType:(SDMMUserPreferenceShutdownType)shutdownType
{
    if (shutdownType != _shutdownType) {
        _shutdownType = shutdownType;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@(shutdownType) forKey:SDMMUserPreferencesManagerShutdownTypeKey];
        [userDefaults synchronize];
    }
}


- (void)setRunAtStartup:(BOOL)runAtStartup
{
    if (runAtStartup != _runAtStartup) {
        [LSHelper enableLoginItem:runAtStartup withAppPath:[[NSBundle mainBundle] bundlePath]];
        _runAtStartup = [LSHelper isLoginItemEnabledForAppPath:[[NSBundle mainBundle] bundlePath]];
    }
}


- (void)setIconPosition:(SDMMUserPreferenceIconPosition)iconPosition
{
    if (iconPosition != _iconPosition) {
        _iconPosition = iconPosition;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@(iconPosition) forKey:SDMMUserPreferencesManagerIconPositionKey];
        [userDefaults synchronize];
    }
}


@end
