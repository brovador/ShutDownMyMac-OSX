//
//  SDMMUserPreferencesManager.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 8/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "LSHelper.h"
#import "SDMMUserPreferencesManager.h"

NSString * const SDMMUserPreferencesManagerUpdatedNotification = @"SDMMUserPreferencesManagerUpdatedNotification";

static NSString * const SDMMUserPreferencesManagerShutdownTypeKey = @"SDMMUserPreferencesManagerShutdownTypeKey";
static NSString * const SDMMUserPreferencesManagerIconPositionKey = @"SDMMUserPreferencesManagerIconPositionKey";
static NSString * const SDMMUserPreferencesManagerPairedDevicesKey = @"SDMMUserPreferencesManagerPairedDevicesKey";

static SDMMUserPreferencesManager *sharedInstance;

@interface SDMMUserPreferencesManager()

@property (nonatomic, strong) NSMutableArray *mutablePairedDevices;

@end

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
        
        storedKey = [userDefaults objectForKey:SDMMUserPreferencesManagerPairedDevicesKey];
        if (storedKey != nil) {
            self.mutablePairedDevices = [NSMutableArray arrayWithArray:storedKey];
        } else {
            self.mutablePairedDevices = [NSMutableArray array];
        }
        
        self.runAtStartup = [LSHelper isLoginItemEnabledForAppPath:[[NSBundle mainBundle] bundlePath]];
    }
    return self;
}

- (NSArray*)pairedDevices
{
    return [NSArray arrayWithArray:_mutablePairedDevices];
}


- (void)addDevice:(NSString *)name
{
    [_mutablePairedDevices addObject:name];
    [self _updatePrefsKey:SDMMUserPreferencesManagerPairedDevicesKey withValue:_mutablePairedDevices];
}


- (void)removeDevice:(NSString *)name
{
    [_mutablePairedDevices removeObject:name];
    [self _updatePrefsKey:SDMMUserPreferencesManagerPairedDevicesKey withValue:_mutablePairedDevices];
}


- (BOOL)isValidDevice:(NSString *)name
{
    return [_mutablePairedDevices containsObject:name];
}


- (void)setShutdownType:(SDMMUserPreferenceShutdownType)shutdownType
{
    if (shutdownType != _shutdownType) {
        _shutdownType = shutdownType;
        [self _updatePrefsKey:SDMMUserPreferencesManagerShutdownTypeKey withValue:@(shutdownType)];
    }
}


- (void)setRunAtStartup:(BOOL)runAtStartup
{
    if (runAtStartup != _runAtStartup) {
        [LSHelper enableLoginItem:runAtStartup withAppPath:[[NSBundle mainBundle] bundlePath]];
        _runAtStartup = [LSHelper isLoginItemEnabledForAppPath:[[NSBundle mainBundle] bundlePath]];
        [[NSNotificationCenter defaultCenter] postNotificationName:SDMMUserPreferencesManagerUpdatedNotification object:self userInfo:nil];
    }
}


- (void)setIconPosition:(SDMMUserPreferenceIconPosition)iconPosition
{
    if (iconPosition != _iconPosition) {
        _iconPosition = iconPosition;
        [self _updatePrefsKey:SDMMUserPreferencesManagerIconPositionKey withValue:@(iconPosition)];
    }
}


#pragma mark Private

- (void)_updatePrefsKey:(NSString*)key withValue:(id)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:SDMMUserPreferencesManagerUpdatedNotification object:self userInfo:nil];
}


@end
