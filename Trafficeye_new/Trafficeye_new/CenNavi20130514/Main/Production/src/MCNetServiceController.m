//
//  MCNetServiceDelegate.m
//  Connected
//
//  Created by Wolfram Manthey on 20.05.10.
//  Copyright 2010 BMW Group. All rights reserved.
//
//  $Id$
//

#import "MCNetServiceController.h"

#include <arpa/inet.h>
#include <ifaddrs.h>

#pragma mark -

@interface MCNetServiceController ()

- (BOOL)isNetServiceLocal:(NSNetService *)service;
- (NSInteger)portWithAddressData:(NSData *)data;
- (NSInteger)portWithSocketAddress:(struct sockaddr *)address;
- (NSString *)hostnameWithAddressData:(NSData *)data;
- (NSString *)hostnameWithSocketAddress:(struct sockaddr *)address;
- (NSString *)createNetServiceDescriptionForNetService:(NSNetService *)service;

@end

@implementation MCNetServiceController

- (id)init
{
    if (self = [super init])
    {
        [_foundServices release];
        _foundServices = [[NSMutableArray alloc] initWithCapacity:10];
        
        [_netServiceBrowser release];
        _netServiceBrowser = [[NSNetServiceBrowser alloc] init];
        
        [_netServiceBrowser setDelegate:self];
        [_netServiceBrowser searchForServicesOfType:@"_idrive._tcp" inDomain:@""];
    }
    return self;
}

- (void)dealloc
{
    [_foundServices release];
    [_netServiceBrowser release];
    [_connectedService release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark NSNetServiceBrowserDelegate implementation

- (void)netServiceBrowser:(NSNetServiceBrowser*)browser didFindService:(NSNetService *)service moreComing:(BOOL)more
{
    MCLog(IDLogLevelDebug, @"Did find HMI service: %@", [self createNetServiceDescriptionForNetService:service]);
    
    [_foundServices addObject:service];
    
    [service setDelegate:self];
    [service resolveWithTimeout:5.0];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)more
{
    MCLog(IDLogLevelDebug, @"Did remove HMI service: %@", [self createNetServiceDescriptionForNetService:service]);
    
    if ([_connectedService isEqual:service])
    {
        _connectedService = nil;
        MCLog(IDLogLevelInfo, @"Local HMI service removed: %@", [self createNetServiceDescriptionForNetService:service]);
        [[NSNotificationCenter defaultCenter] postNotificationName:IDAccessoryDidDisconnectNotification
                                                            object:nil];
    }
    
    [_foundServices removeObject:service];
}

#pragma mark -
#pragma mark NSNetServiceDelegate implementation

- (void)netServiceDidResolveAddress:(NSNetService*)service
{
    MCLog(IDLogLevelDebug, @"Did resolve HMI service: %@", [self createNetServiceDescriptionForNetService:service]);
    
    if (!_connectedService)
    {
        if ([self isNetServiceLocal:service]) {
            MCLog(IDLogLevelInfo, @"Connect to local HMI service: %@", [self createNetServiceDescriptionForNetService:service]);
            _connectedService = service;
            [[NSNotificationCenter defaultCenter] postNotificationName:IDAccessoryDidConnectNotification object:nil];
        }
    }
}

- (void)netService:(NSNetService*)service didNotResolve:(NSDictionary *)errorDict
{
    MCLog(IDLogLevelDebug, @"Did not resolve HMI service: %@ reason: %@", [self createNetServiceDescriptionForNetService:service], [errorDict description]);
}

#pragma mark - Helper methods

- (BOOL)isNetServiceLocal:(NSNetService *)service
{
    @synchronized(self) {
        BOOL isLocalNetService = NO;
        struct ifaddrs *ifap;
        if (-1 == getifaddrs(&ifap)) {
            return NO;   
        }
        for (struct ifaddrs *it = ifap; it; it = it->ifa_next)
        {
            NSString *hostAddress = [self hostnameWithSocketAddress:(struct sockaddr *)it->ifa_addr];
            
            if (hostAddress) {
                for (NSData* addressData in [service addresses]) {
                    NSString *serviceAddress = [self hostnameWithAddressData:addressData];
                    NSInteger servicePort = [self portWithAddressData:addressData];
                    
                    if ([hostAddress isEqualToString:serviceAddress] && servicePort) {
                        isLocalNetService = YES;
                        MCLog(IDLogLevelInfo, @"NetService is local: %@", [self createNetServiceDescriptionForNetService:service]);                    
                        break;
                    } 
                }
                
                if (isLocalNetService) {
                    break;
                }
            }
        }
        
        freeifaddrs(ifap);
        return isLocalNetService;
    }
}

- (NSInteger)portWithAddressData:(NSData *)data
{
	if ([data length] < sizeof(struct sockaddr) ) {
		return 0;
	}
    
    return [self portWithSocketAddress:(struct sockaddr *)[data bytes]];
}

- (NSInteger)portWithSocketAddress:(struct sockaddr *)address
{
    if (address->sa_family == AF_INET) {
		return ntohs(((struct sockaddr_in *)address)->sin_port);
	}
	else if (address->sa_family == AF_INET6) {
		return ntohs(((struct sockaddr_in6 *)address)->sin6_port);
	}
	else {
		return 0;
	}
}

- (NSString *)hostnameWithAddressData:(NSData *)data
{
	if ([data length] < sizeof(struct sockaddr)) {
		return nil;
	}
    
    return [self hostnameWithSocketAddress:(struct sockaddr *)[data bytes]];
}

- (NSString *)hostnameWithSocketAddress:(struct sockaddr *)address
{
	if (address->sa_family == AF_INET) {
		char buffer[INET_ADDRSTRLEN];
		const char *pBuffer = inet_ntop(AF_INET, &((struct sockaddr_in*)address)->sin_addr, buffer, sizeof(buffer));
		return pBuffer ? [NSString stringWithUTF8String:pBuffer] : nil;
	}
	else if (address->sa_family == AF_INET6) {
		struct sockaddr_in6 *addr6 = (struct sockaddr_in6*)address;
		char buffer[INET6_ADDRSTRLEN];
		const char *pBuffer = inet_ntop(AF_INET6, &(addr6->sin6_addr), buffer, sizeof(buffer));
		return pBuffer ? [NSString stringWithUTF8String:pBuffer] : nil;
	}
	else {
		return nil;
	}
}

- (NSString *)createNetServiceDescriptionForNetService:(NSNetService *)service
{
    NSMutableString *serviceDescription = [NSMutableString string];
    
    [serviceDescription appendFormat:@"[name:%@]", service.name];
    [serviceDescription appendFormat:@"[type:%@]", service.type];
    [serviceDescription appendFormat:@"[domain:%@]", service.domain];    
    
    if (service.hostName) {
        [serviceDescription appendFormat:@"[hostName:%@]", service.hostName];
    }
    
    if ([service addresses] && [[service addresses] count] > 0) {
        [serviceDescription appendString:@"[addresses:"];
        
        for (NSData* data in [service addresses]) {
            
            struct sockaddr_in* socketAddress = (struct sockaddr_in*) [data bytes];
            int sockFamily = socketAddress->sin_family;
            
            NSString *addressStr = [self hostnameWithAddressData:data];
            NSInteger port = [self portWithAddressData:data];
            
            if (addressStr && port) {
                
                NSString *type = nil;
                if (sockFamily == AF_INET) {
                    type = @"IPv4";
                } else if (sockFamily == AF_INET6) {
                    type = @"IPv6";
                } else {
                    type = @"unknown";
                }
                
                [serviceDescription appendFormat:@"[type:%@][address:%@][port:%d]", type, addressStr, port];
            }
        }
        
        [serviceDescription appendString:@"]"];
    }
    
    return [NSString stringWithString:serviceDescription];
}

@end
