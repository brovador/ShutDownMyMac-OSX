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

static SDMMServiceManager* _instance;

void handleConnect(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    NSLog(@"SOCKET HANDLE CONNECT");
}


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
    NSNetService *netService = [[NSNetService alloc] initWithDomain:@"local."
                                                               type:@"_shutdownmymac._tcp."
                                                               name:@"BrovaMac"
                                                               port:8010];
    [netService setDelegate:self];
    [netService publishWithOptions:NSNetServiceListenForConnections];
}

#pragma mark NSNetServiceDelegate

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"SERVICE DID PUBLISH: %@", sender);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"SERVICE DID NOT PUSBLISH: %@", sender);
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    NSLog(@"SERVICE CONNECTED: %@", sender);
    
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    
    self.inputStream = inputStream;
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
                
                NSLog(@"Message: %@", message);
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
