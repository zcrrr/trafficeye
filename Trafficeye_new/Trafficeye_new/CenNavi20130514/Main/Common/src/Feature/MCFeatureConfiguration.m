//
//  MCFeatureConfiguration.m
//  Connected
//
//  Created by Andreas Streuber on 12.10.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import "MCFeatureConfiguration.h"
#import "MCFeatureIdentifier.h"
#import "MCFunctionIdentifier.h"

@implementation MCFeatureConfiguration


static NSString *const FeatureIdentifierKey = @"FeatureIdentifier";
static NSString *const FeatureFunctionsKey = @"FeatureFunctions";
static NSString *const FeatureRequiresNBTKey = @"FeatureRequiresNBT";

@synthesize identifier = _identifier;
@synthesize functionIdentifiers = _functionIdentifiers;
@synthesize requiresNBT = _requiresNBT;

#pragma mark - Setup, TearDown

- (id)initWithFeatureConfigurationDictionary:(NSDictionary *)dict
{
    if (!dict) {
        [self release];
        return nil;
    }

    self = [super init];

    if (self) {
        if (![dict objectForKey:FeatureIdentifierKey]) {
            MCLog(IDLogLevelError, @"Missing required key: %@ in feature configuration dictionary!", FeatureIdentifierKey);
            [self release];
            return nil;
        }
        NSString *identifierName = [dict objectForKey:FeatureIdentifierKey];
        _identifier = [MCFeatureIdentifier featureIdentifierForFeatureIdentifierName:identifierName];

        if (!_identifier) {
            MCLog(IDLogLevelError, @"Unable to create feature identifer for feature identifier name: %@", identifierName);
            [self release];
            return nil;
        }


        NSArray *functionNames = [dict objectForKey:FeatureFunctionsKey];

        if (functionNames && [functionNames count] > 0) {
            NSMutableArray *funcIds = [[NSMutableArray alloc] init];

            for (NSString *functionName in functionNames) {
                MCFunctionIdentifier *funcId = [[MCFunctionIdentifier alloc] initWithFunctionName:functionName featureIdentifier:_identifier];
                if (funcId) {
                    [funcIds addObject:funcId];
                    [funcId release];
                }
            }

            _functionIdentifiers = [[NSArray alloc] initWithArray:funcIds];
            [funcIds release];
        } else {
            _functionIdentifiers = [[NSArray alloc] init];
        }

        _requiresNBT = [[dict objectForKey:FeatureRequiresNBTKey] boolValue];

    }

    return self;
}

- (void)dealloc {
    _identifier = nil;
    [_functionIdentifiers release];
    [super dealloc];
}

- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[MCFeatureConfiguration class]]) {
        return NO;
    }
    return [((MCFeatureConfiguration *)object).identifier isEqual:self.identifier];
}

- (NSUInteger) hash {
    return [self.identifier hash];
}

#pragma mark - description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ [%@]", NSStringFromClass([MCFeatureConfiguration class]), [self.identifier description]];
}

@end
