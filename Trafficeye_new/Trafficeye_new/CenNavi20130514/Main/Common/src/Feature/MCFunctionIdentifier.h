//
//  MCFunctionIdentifier.h
//  Connected
//
//  Created by Andreas Streuber on 23.11.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCFeatureIdentifier.h"

/*!  
 @class MCFunctionIdentifier
 @abstract A value object uniquely identifies a function within the fat app.  
 @discussion The class uniquely identifies a function in the fat app. A function is a specific part of a feature within the fat app. By nature instances of this class are immutable. Copying an instance of this class will return the same instance with a retain count plus one.   
 @updated 2011-11-23 
 */
@interface MCFunctionIdentifier : NSObject <NSCopying>

@property (assign, readonly) MCFeatureIdentifier *featureIdentifier;
@property (copy, readonly) NSString *functionName;

/*!  
 @method initWithFunctionName:featureIdentifier:
 @abstract Method to create a new MCFunctionIdentifier instance.
 @discussion A new instance is initialized with a function name and the feature identifier of the fat app feature this function belongs to. This is the designated initializer.
 @param functionName a string that uniquely identifies a function within a specific feature of the fat app
 @param featureIdentifier a MCFeatureIdentifier
 @return a new instance of MCFunctionIdentifier or nil if an input parameter was missing  
 */
- (MCFunctionIdentifier *)initWithFunctionName:(NSString *)functionName featureIdentifier:(MCFeatureIdentifier *)featureIdentifier;

/*!  
 @method initWithUniqueFunctionString:
 @abstract Method to create a new MCFunctionIdentifier instance.
 @discussion A new instance is initialized with a unique function string. The unique contains a string that identifies the feature the function belongs to and a string that identifies the function within this feature. Both strings are seperated by an underscore sign. The pattern is 'FEATURENAME_FUNCTIONNAME', e.g.: 'Calendar_NavigateToLocation'. The function string is case sensitive.
 @param uniqueFunctionString a string that uniquely identifies a function within a specific feature of the fat app
 @return a new instance of MCFunctionIdentifier, nil if the input parameter was missing or is not a valid unique function string
 */
- (MCFunctionIdentifier *)initWithUniqueFunctionString:(NSString *)uniqueFunctionString;

@end
