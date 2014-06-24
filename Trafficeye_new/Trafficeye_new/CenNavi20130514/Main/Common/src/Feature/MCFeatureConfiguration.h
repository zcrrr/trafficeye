//
//  MCFeatureConfiguration.h
//  Connected
//
//  Created by Andreas Streuber on 12.10.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

/*!
 @class MCFeatureConfiguration
 @abstract This class encapsulates the configuration for a feature.
 @discussion Each instance of this class is created with a feature configuration dictionary retrieved from the Features.plist. The class does some sanity checks during initialization. (e.g. featureRequiresFMOD and featureConflictsWithFMOD are mutual exclusive). During initialization this class verifies the content of the provided dictionary. If a required key is missing from the dictionary the initialization will fail and the return value is nil.
 @updated 2011-10-12    Andreas Streuber
 */

#import <Foundation/Foundation.h>


@class MCFeatureIdentifier;

@interface MCFeatureConfiguration : NSObject

@property (readonly) MCFeatureIdentifier *identifier;
@property (readonly) NSArray *functionIdentifiers;
@property (readonly) BOOL requiresNBT;


/*!
 @method initWithFeatureConfigurationDictionary:
 @abstract Method to create a new MCFeatureConfiguration instance.
 @discussion This method is the designated initializer to create a new MCFeatureConfiguration instance.
 @param dict A dictionary containing the configuration for a feature.
 @return A new instance of MCFeatureConfiguration or nil if the input param was nil or did not pass the sanity check.
 */
- (id)initWithFeatureConfigurationDictionary:(NSDictionary *)dict;

@end
