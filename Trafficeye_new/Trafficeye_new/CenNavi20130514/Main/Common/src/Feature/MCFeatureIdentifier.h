//
//  MCFeatureIdentifier.h
//  Connected
//
//  Created by Andreas Streuber on 12.10.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

/*!  
 @class MCFeatureIdentifier
 @abstract This class makes the concept of a feature identifier explizit.  
 @discussion The purpose of this class is to have features identified by objects and not by string values. The only way to access identifers should be through class methods of this class. Each features within the Features.plist is represented by one feature identifier in this file. The mapping between the 'FeatureIdentifier' key in the Features.plist file and MCFeatureIdentifer instances see the implementation file of this class.
 @updated 2011-10-12 
 */

#import <Foundation/Foundation.h>

@interface MCFeatureIdentifier : NSObject<NSCopying>

@property (readonly) NSString *name;

+ (MCFeatureIdentifier *)featureIdentifierForFeatureIdentifierName:(NSString *)name;

+ (MCFeatureIdentifier *)CenNavi;

@end
