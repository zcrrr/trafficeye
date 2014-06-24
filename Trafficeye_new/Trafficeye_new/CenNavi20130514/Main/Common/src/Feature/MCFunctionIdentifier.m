//
//  MCFunctionIdentifier.m
//  Connected
//
//  Created by Andreas Streuber on 23.11.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import "MCFunctionIdentifier.h"

@interface MCFunctionIdentifier ()

@end

@implementation MCFunctionIdentifier

static NSString *const UNIQUE_FUNCTION_STRING_SEPERATOR = @"_";

@synthesize featureIdentifier = _featureIdentifier;
@synthesize functionName = _functionName;

#pragma mark - Setup, TearDown

- (MCFunctionIdentifier *)initWithFunctionName:(NSString *)functionName featureIdentifier:(MCFeatureIdentifier *)featureIdentifier
{
    if (!functionName || !featureIdentifier) {
        [self release];
        MCLog(IDLogLevelError, @"%@ unable to create instance, at least one of the input parameters was nil!", NSStringFromClass([MCFunctionIdentifier class]));
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        _featureIdentifier = featureIdentifier;
        _functionName = [functionName copy];
    }
    
    return self;
}

- (MCFunctionIdentifier *)initWithUniqueFunctionString:(NSString *)uniqueFunctionString
{
    if (!uniqueFunctionString) {
        [self release];
        MCLog(IDLogLevelError, @"%@ unable to create instance, input parameter 'uniqueFunctionString' was nil!", NSStringFromClass([MCFunctionIdentifier class]));
        return nil;
    }

    NSArray *stringComponents = [uniqueFunctionString componentsSeparatedByString:UNIQUE_FUNCTION_STRING_SEPERATOR];
    
    if (!stringComponents || [stringComponents count] != 2) {
        [self release];
        MCLog(IDLogLevelError, @"%@ unable to create instance, input parameter '%@' has wrong format!", NSStringFromClass([MCFunctionIdentifier class]), uniqueFunctionString);
        return nil;        
    }
    
    MCFeatureIdentifier *featId = [MCFeatureIdentifier featureIdentifierForFeatureIdentifierName:[stringComponents objectAtIndex:0]];
    if (!featId) {
        [self release];
        MCLog(IDLogLevelError, @"%@ unable to create instance, could not create feature identifier!", NSStringFromClass([MCFunctionIdentifier class]));
        return nil;        
    }
    
    NSString *funcName = [stringComponents objectAtIndex:1];
    
    return [self initWithFunctionName:funcName featureIdentifier:featId];
}

- (void)dealloc {
    [_functionName release];
    [super dealloc];
}

#pragma mark - NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

#pragma mark - Object equality and description

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[MCFunctionIdentifier class]]) {
        return NO;
    }
    
    MCFunctionIdentifier *functionIdentifier = (MCFunctionIdentifier *)object;

    if (functionIdentifier.featureIdentifier != self.featureIdentifier) {
        return NO;
    }
    
    if (![functionIdentifier.functionName isEqualToString:self.functionName]) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)hash
{
    return [_featureIdentifier hash] ^ [_functionName hash];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ [%@][functionName:%@]", NSStringFromClass([MCFunctionIdentifier class]), self.featureIdentifier, self.functionName];
}

@end
