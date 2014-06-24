//
//  MCNetServiceDelegate.h
//  Connected
//
//  Created by Wolfram Manthey on 20.05.10.
//  Copyright 2010 BMW Group. All rights reserved.
//
//  $Id$
//

#import <Foundation/Foundation.h>


@interface MCNetServiceController : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
@private
    NSNetServiceBrowser*  _netServiceBrowser;
    NSNetService*         _connectedService;
    NSMutableArray*       _foundServices;
}

@end
