//
//  MCFeatureIdentifier.m
//  Connected
//
//  Created by Andreas Streuber on 12.10.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import "MCFeatureIdentifier.h"
@interface MCFeatureIdentifier ()

- (id)initWithIdentifierName:(NSString *)name;

@end

@implementation MCFeatureIdentifier

@synthesize name = _name;

static NSDictionary *featureIdentifiers;

// Mapping between the MCFeatureIdentifier objects and the 'FeatureIdentifier' keys from the Features.plist file.
static NSString *const BMWAPP_FEATURE_IDENTIFER_NAME = @"CenNavi";

+ (void)initialize
{
    featureIdentifiers = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [[[MCFeatureIdentifier alloc] initWithIdentifierName:BMWAPP_FEATURE_IDENTIFER_NAME] autorelease], BMWAPP_FEATURE_IDENTIFER_NAME,
                          nil];
}


+ (MCFeatureIdentifier *)CenNavi
{
    return [MCFeatureIdentifier featureIdentifierForFeatureIdentifierName:BMWAPP_FEATURE_IDENTIFER_NAME];
}


+ (MCFeatureIdentifier *)featureIdentifierForFeatureIdentifierName:(NSString *)name
{
    if (!name) {
        MCLog(IDLogLevelWarn, @"%s - No feature identifier found, provided feature identifier name was nil!", __PRETTY_FUNCTION__);
        return nil;
    }

    MCFeatureIdentifier *featureIdentifier = [featureIdentifiers objectForKey:name];
    if (!featureIdentifier) {
        MCLog(IDLogLevelWarn, @"%s - No feature identifier found for feature identifier name: %@!", __PRETTY_FUNCTION__, name);
    }
    return featureIdentifier;
}

- (id)initWithIdentifierName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = [name copy];
    }
    return self;
}

// prevent direct initialization of this class
- (id)init {
    [self release];
    return nil;
}

- (void)dealloc {
    [_name release];
    [super dealloc];
}

#pragma mark - equality and hash

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[MCFeatureIdentifier class]])
    {
        return NO;
    }

    MCFeatureIdentifier *identfifier = (MCFeatureIdentifier *)object;
    return [identfifier.name isEqualToString:self.name];
}

- (NSUInteger)hash
{
    return [_name hash];
}

#pragma mark - NSCopying implementation
- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

#pragma mark - description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ [name:%@]", NSStringFromClass([MCFeatureIdentifier class]), self.name];
}

@end
