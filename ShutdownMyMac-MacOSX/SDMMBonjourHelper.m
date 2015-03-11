//
//  SDMMBonjourHelper.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 11/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "SDMMBonjourHelper.h"

@interface SDMMBonjourHelper ()<NSNetServiceDelegate, NSStreamDelegate>

@property (nonatomic, strong) NSNetService *netService;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

@end

@implementation SDMMBonjourHelper

- (void)startService:(NSString*)name type:(NSString*)type domain:(NSString*)domain
{
    NSNetService *netService = [[NSNetService alloc] initWithDomain:domain
                                                               type:type
                                                               name:name];
    [netService setDelegate:self];
    [netService publishWithOptions:NSNetServiceListenForConnections];
    
    self.netService = netService;
}


- (void)stopService
{
    [_netService stop];
    self.netService = nil;
    
    if ([_delegate respondsToSelector:@selector(bonjourHelperDidStopService:)]) {
        [_delegate bonjourHelperDidStopService:self];
    }
}


//- (void)sendCommand:(NSString*)command
//{
//    
//}

#pragma mark NSNetServiceDelegate

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    
    self.inputStream = inputStream;
    //TODO: initialize outputStream
    
    if ([_delegate respondsToSelector:@selector(bonjourHelperDidStartService:)]) {
        [_delegate bonjourHelperDidStartService:self];
    }
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
                
                if ([_delegate respondsToSelector:@selector(bonjourHelper:didReceiveCommand:)]) {
                    [_delegate bonjourHelper:self didReceiveCommand:message];
                }
            }
            
            break;
        }
        case NSStreamEventEndEncountered:
            break;
        case NSStreamEventErrorOccurred:
            break;
        default:
            break;
    }
}



@end
