//
//  SDMMServiceManager.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "SDMMServiceManager.h"
#import "SDMMBonjourHelper.h"
#import "SDMMBonjourHelperChannel.h"
#import "SDMMUserPreferencesManager.h"

static NSString *const SDMMServiceManagerCommandConnect = @"CONNECT";
static NSString *const SDMMServiceManagerCommandPair = @"PAIR";
static NSString *const SDMMServiceManagerCommandShutdown = @"SHUTDOWN";

static NSString *const SDMMServiceManagerResponseSuccess = @"SUCCESS";
static NSString *const SDMMServiceManagerResponseFail = @"FAIL";

static NSString *const SDMMServiceManagerDomain = @"local.";
static NSString *const SDMMServiceManagerType = @"_shutdownmymac._tcp.";

NSString *const SDMMServiceManagerErrorDomain = @"SDMMServiceManagerErrorDomain";
NSInteger const SDMMServiceManagerErrorCodeCommandNotFound = 0;
NSInteger const SDMMServiceManagerErrorCodeCommandError = 1;

NSString *const SDMMServiceManagerErrorUserInfoCommandKey = @"command";
NSString *const SDMMServiceManagerErrorUserInfoDataKey = @"data";

static SDMMServiceManager* _instance;

@interface SDMMServiceManager () <SDMMBonjourHelperDelegate>

@property (nonatomic, strong) SDMMBonjourHelper *bonjourHelper;

#warning TODO: temporary check, move to preferences
@property (nonatomic, strong) NSMutableArray *pairedServices;

@end

@implementation SDMMServiceManager

+ (instancetype)sharedServiceManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [SDMMServiceManager new];
    });
    return _instance;
}

#pragma mark Public

- (id)init
{
    self = [super init];
    if (self) {
        self.pairedServices = [NSMutableArray new];
    }
    return self;
}

- (void)startService
{
    SDMMBonjourHelper *bonjourHelper = [SDMMBonjourHelper new];
    [bonjourHelper setDelegate:self];
    [bonjourHelper startService:[[NSHost currentHost] localizedName]
                           type:SDMMServiceManagerType
                         domain:SDMMServiceManagerDomain];
    
    self.bonjourHelper = bonjourHelper;
}


- (void)stopService
{
    [self.bonjourHelper stopService];
}


#pragma mark Private

- (void)executeShutdownCommand:(NSError**)error
{
    NSDictionary *errorDict = nil;
    
    NSString *shutdownCommand = @"";
    if ([[SDMMUserPreferencesManager sharedManager] shutdownType] == SDMMUserPreferenceShutdownTypeAsk) {
        shutdownCommand = @"tell app \"loginwindow\" to «event aevtrsdn»";
    } else {
        shutdownCommand = @"tell app \"System Events\" to shut down";
    }
    
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:shutdownCommand];
    [appleScript executeAndReturnError:&errorDict];
    
    if (errorDict != nil) {
        *error = [NSError errorWithDomain:SDMMServiceManagerErrorDomain
                                    code:SDMMServiceManagerErrorCodeCommandError
                                userInfo:@{
                                           SDMMServiceManagerErrorUserInfoCommandKey:SDMMServiceManagerCommandShutdown,
                                           SDMMServiceManagerErrorUserInfoDataKey:errorDict
                                           }];
    }
}


- (void)executeConnectCommand:(SDMMBonjourHelperChannel*)channel error:(NSError**)error
{
    BOOL paired = [_pairedServices containsObject:channel];
    if (!paired) {
        [channel sendCommand:SDMMServiceManagerResponseFail];
    } else {
        [channel sendCommand:SDMMServiceManagerResponseSuccess];
    }
}


- (void)executePairCommand:(SDMMBonjourHelperChannel*)channel error:(NSError**)error
{
    if (![_pairedServices containsObject:channel]) {
        [_pairedServices addObject:channel];
        [channel sendCommand:SDMMServiceManagerResponseSuccess];
    }
}


#pragma mark SDMMBonjourHelperDelegate

- (void)bonjourHelper:(SDMMBonjourHelper *)bonjourHelper didReceiveCommand:(NSString *)command fromChannel:(SDMMBonjourHelperChannel *)channel
{
    NSError *error = nil;
    
    if ([command isEqualToString:SDMMServiceManagerCommandShutdown]) {
        [self executeShutdownCommand:&error];
    } else if ([command isEqualToString:SDMMServiceManagerCommandConnect]) {
        [self executeConnectCommand:channel error:&error];
    } else if ([command isEqualToString:SDMMServiceManagerCommandPair]) {
        [self executePairCommand:channel error:&error];
    } else {
        [NSError errorWithDomain:SDMMServiceManagerErrorDomain
                            code:SDMMServiceManagerErrorCodeCommandError
                        userInfo:@{SDMMServiceManagerErrorUserInfoCommandKey : command}];
    }
    
    if (error != nil) {
        NSLog(@"ERROR PARSING COMMAND: %@", command);
    }
}




@end
