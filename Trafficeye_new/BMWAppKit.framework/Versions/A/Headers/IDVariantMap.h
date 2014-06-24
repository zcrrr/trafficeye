/*  
 *  IDVariantMap.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

// TODO: header documentation

@class IDVariantData;

/*!
 @class IDVariantMap
 @abstract <#This is a introductory explanation about the class.#>
 @discussion <#This is a more detailed description of the class.#>
 @updated 2011-08-16
 */
@interface IDVariantMap : NSObject
{
    NSMutableDictionary* _content;
}

/*!
 @method variantMapWithVariant:forId:
 @abstract <#This is a introductory explanation about the method.#>
 @discussion <#This is a more detailed description of the method.#>
 @param variant <#param documentation#>
 @param theId <#param documentation#>
 @return <#return value documentation#>
 */
+ (IDVariantMap*)variantMapWithVariant:(IDVariantData*)variant forId:(NSInteger)theId;

/*!
 @method variantMapWithDictionary:
 @abstract <#This is a introductory explanation about the method.#>
 @discussion <#This is a more detailed description of the method.#>
 @param dictionary <#param documentation#>
 @return <#return value documentation#>
 */
+ (IDVariantMap*)variantMapWithDictionary:(NSDictionary*)dictionary;

/*!
 @method initWithVariant:forId:
 @abstract <#This is a introductory explanation about the method.#>
 @discussion <#This is a more detailed description of the method.#>
 @param variant <#param documentation#>
 @param theId <#param documentation#>
 @return <#return value documentation#>
 */
- (id)initWithVariant:(IDVariantData*)variant forId:(NSInteger)theId;

/*!
 @method initWithDictionary:
 @abstract <#This is a introductory explanation about the method.#>
 @discussion <#This is a more detailed description of the method.#>
 @param dictionary <#param documentation#>
 @return <#return value documentation#>
 */
- (id)initWithDictionary:(NSDictionary*)dictionary;

/*!
 @method setVariant:forId:
 @abstract <#This is a introductory explanation about the method.#>
 @discussion <#This is a more detailed description of the method.#>
 @param variant <#param documentation#>
 @param theId <#param documentation#>
 */
- (void)setVariant:(IDVariantData*)variant forId:(NSInteger)theId; // IDParameterTypes

/*!
 @method variantForId:
 @abstract <#This is a introductory explanation about the method.#>
 @discussion <#This is a more detailed description of the method.#>
 @param theId <#param documentation#>
 @return <#return value documentation#>
 */

- (IDVariantData*)variantForId:(NSInteger)theId; // IDParameterTypes
/*!
 @method isEqualToVariantMap:
 @abstract Compares the receiving variant map to another variant map
 @param otherVariantMap A variant map
 @return YES if the contents of otherVariantMap are equal to the contents of the receiver, otherwise NO.
 */
- (BOOL)isEqualToVariantMap:(IDVariantMap *)otherVariantMap;

- (NSUInteger)count;


@end
