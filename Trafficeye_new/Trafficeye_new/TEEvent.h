//
//  TEEvent.h
//  Trafficeye_new
//
//  Created by zc on 13-9-23.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEGeoPoint.h"

@interface TEEvent : NSObject

@property (assign, nonatomic) int eventID;
@property (assign, nonatomic) int type;
@property (assign, nonatomic) int jamDegree;
@property (assign, nonatomic) int index;
@property (strong, nonatomic) TEGeoPoint* eventLocation;
@property (strong, nonatomic) NSString* avatar_url;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* eventuid;


@end
