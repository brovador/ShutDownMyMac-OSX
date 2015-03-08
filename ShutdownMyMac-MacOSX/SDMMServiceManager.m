//
//  SDMMServiceManager.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 1/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//
#include <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>

#import "SDMMServiceManager.h"

static NSString *const SMSERVICE_COMMAND_SHUTDOWN = @"SHUTDOWN";

static NSString *const ShutdownServiceDomain = @"local.";
static NSString *const ShutdownServiceType = @"_shutdownmymac._tcp.";
static SDMMServiceManager* _instance;


@interface SDMMServiceManager () <NSNetServiceDelegate, NSStreamDelegate>

@property (nonatomic, strong) NSNetService *netService;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

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


- (void)startService
{
    NSNetService *netService = [[NSNetService alloc] initWithDomain:ShutdownServiceDomain
                                                               type:ShutdownServiceType
                                                               name:[[NSHost currentHost] localizedName]];
    [netService setDelegate:self];
    [netService publishWithOptions:NSNetServiceListenForConnections];
    
    self.netService = netService;
}


- (void)stopService
{
    [self.netService stop];
}

#pragma mark NSNetServiceDelegate

- (void)netServiceDidPublish:(NSNetService *)sender
{
    //TODO notify publish
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    //TODO notify did not publish
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    
    self.inputStream = inputStream;
}

- (void)parseCommand:(NSString*)command
{
    NSDictionary *error = nil;
    if ([SMSERVICE_COMMAND_SHUTDOWN isEqualToString:command]) {
        [self executeShutdownCommand:&error];
    }
    
    if (error != nil) {
        NSLog(@"COMMAND ERROR");
    }
}

- (void)executeShutdownCommand:(NSDictionary**)error
{
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:@"tell app \"loginwindow\" to «event aevtrsdn»"];
    [appleScript executeAndReturnError:error];
}

#pragma mark NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            
            uint8_t buf[1024];
            NSInteger len = 0;
            
            len = [(NSInputStream*)aStream read:buf maxLength:1024];
            
            if (len > 0) {
                NSData *data = [NSData dataWithBytes:buf length:len];
                NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self parseCommand:message];
            }
            
            break;
        }
        case NSStreamEventEndEncountered:
            NSLog(@"EVENT END ENCOUNTERED");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"EVENT ERROR OCURRED");
            break;
        default:
            break;
    }
}

@end
