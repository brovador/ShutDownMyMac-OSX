//
//  SDMMBonjourHelper.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 11/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "SDMMBonjourHelper.h"
#import "SDMMBonjourHelperChannel.h"

@interface SDMMBonjourHelper ()<NSNetServiceDelegate>

@property (nonatomic, strong) NSNetService *netService;
@property (nonatomic, strong) NSMutableArray *channels;

@end

@implementation SDMMBonjourHelper

- (void)startService:(NSString*)name type:(NSString*)type domain:(NSString*)domain
{
    NSNetService *netService = [[NSNetService alloc] initWithDomain:domain
                                                               type:type
                                                               name:name];
    [netService setDelegate:self];
    [netService publishWithOptions:NSNetServiceListenForConnections];
    
    
    if ([_delegate respondsToSelector:@selector(bonjourHelperDidStartService:)]) {
        [_delegate bonjourHelperDidStartService:self];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelConnectionStart:)
                                                 name:SDMMBonjourHelperChannelStartConnectionNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelConnectionEnd:)
                                                 name:SDMMBonjourHelperChannelEndConnectionNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelConnectionCommandReceived:)
                                                 name:SDMMBonjourHelperChannelDidReceiveCommandNotification
                                               object:nil];
    
    self.netService = netService;
    self.channels = [NSMutableArray new];
}


- (void)stopService
{
    [_netService stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDMMBonjourHelperChannelStartConnectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDMMBonjourHelperChannelEndConnectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDMMBonjourHelperChannelDidReceiveCommandNotification object:nil];
    
    if ([_delegate respondsToSelector:@selector(bonjourHelperDidStopService:)]) {
        [_delegate bonjourHelperDidStopService:self];
    }
    
    self.netService = nil;
    self.channels = nil;
}

#pragma mark NSNetServiceDelegate

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    SDMMBonjourHelperChannel *channel = [[SDMMBonjourHelperChannel alloc] initWithNetService:sender
                                                                                 inputStream:inputStream
                                                                                outputStream:outputStream
                                                                                        type:SDMMBonjourHelperChannelTypeReadWrite];
    
    [self.channels addObject:channel];
}


- (void)sendCommand:(NSString *)command toChannel:(SDMMBonjourHelperChannel *)channel
{
    [channel sendCommand:command];
}

#pragma mark SMMBonjourChannelHelperNotifications

- (void)onChannelConnectionStart:(NSNotification*)notification
{
    //SDMMBonjourHelperChannel *channel = notification.object;
    //TODO: move as available channel?
}


- (void)onChannelConnectionEnd:(NSNotification*)notification
{
    SDMMBonjourHelperChannel *channel = notification.object;
    [self.channels removeObject:channel];
}


- (void)onChannelConnectionCommandReceived:(NSNotification*)notification
{
    SDMMBonjourHelperChannel *channel = notification.object;
    if ([_channels containsObject:channel]) {
        if ([_delegate respondsToSelector:@selector(bonjourHelper:didReceiveCommand:fromChannel:)]) {
            NSString *command = notification.userInfo[SDMMBonjourHelperCommandNotificationKey];
            [_delegate bonjourHelper:self didReceiveCommand:command fromChannel:channel];
        }
    }
}

@end
