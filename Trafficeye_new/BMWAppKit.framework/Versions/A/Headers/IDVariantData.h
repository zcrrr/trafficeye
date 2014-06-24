/*  
 *  IDVariantData.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>


/*!
 @enum IDVariantType
 @abstract Used to represent the different types of variant data.
 @constant IDVariantTypeInvalid Unknown variant type.
 @constant IDVariantTypeBoolean Boolean variant type.
 @constant IDVariantTypeInteger Integer variant type.
 @constant IDVariantTypeString String variant type.
 @constant IDVariantTypeDate Date variant type.
 @constant IDVariantTypeTextId Text id variant type.
 @constant IDVariantTypePreInstTextId Text id variant type for preinstalled texts.
 @constant IDVariantTypeImageId Image id variant type.
 @constant IDVariantTypePreInstImageId Image id variant type for preinstalled images.
 @constant IDVariantTypeImageData Image data variant type.
 @constant IDVariantTypeArray Array variant type.
 @constant IDVariantTypeHashtable Hashtable variant type.
*/
typedef enum
{
    IDVariantTypeInvalid = 0,
    IDVariantTypeBoolean,
    IDVariantTypeInteger,
    IDVariantTypeString,
    IDVariantTypeDate,
    IDVariantTypeTextId,
    IDVariantTypePreInstTextId,
    IDVariantTypeImageId,
    IDVariantTypePreInstImageId,
    IDVariantTypeImageData,
    IDVariantTypeArray,
    IDVariantTypeHashtable
} IDVariantType;

/*!
 @enum IDVariantType
 @abstract Defines various possible variant types.
 @discussion Variant types can be used to represent data which can be sent to and received from the BMW HMI.
 @throws IDVariantMismatchException
 @updated 2012-11-21
 */
@interface IDVariantData : NSObject
{
    id             _variant;
    IDVariantType  _variantType;
}

/*!
 @method variantWithBoolean:
 @abstract Creates and returns variant data initialized with a boolean value.
 @param data Initial BOOL value.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithBoolean:(BOOL)data;

/*!
 @method variantWithInteger:
 @abstract Creates and returns variant data initialized with an integer value.
 @param data Initial integer value.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithInteger:(NSInteger)data;

/*!
 @method variantWithString:
 @abstract Creates and returns variant data initialized with a string value.
 @param data Initial string value.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithString:(NSString *)data;

/*!
 @method variantWithTextId:
 @abstract Creates and returns variant data initialized with a text id.
 @param data Initial text id.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithTextId:(NSInteger)data;

/*!
 @method variantWithPreInstTextId:
 @abstract Creates and returns variant data initialized with an id of a preinstalled text.
 @param data Initial text id.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithPreInstTextId:(NSInteger)data;

/*!
 @method variantWithImageId:
 @abstract Creates and returns variant data initialized with an image id.
 @param data Initial image id.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithImageId:(NSInteger)data;

/*!
 @method variantWithPreInstImageId:
 @abstract Creates and returns variant data initialized with an id of a preinstalled image.
 @param data Initial image id.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithPreInstImageId:(NSInteger)data;

/*!
 @method variantWithImageData:
 @abstract Creates and returns variant data initialized with image data.
 @param data Initial image data.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithImageData:(NSData *)data;

/*!
 @method variantWithArray:
 @abstract Creates and returns variant data initialized with an array.
 @param data Initial array.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithArray:(NSArray *)data;

/*!
 @method variantWithDictionary:
 @abstract Creates and returns variant data initialized with a dictionary.
 @param data Initial dictionary.
 @return A new IDVariantData object.
 */
+ (IDVariantData *)variantWithDictionary:(NSDictionary *)data;

/*!
 @method initWithBoolean:
 @abstract Initialize newly allocated variant data with a boolean.
 @param data Initial boolean value.
 @return A new IDVariantData object.
 */
- (id)initWithBoolean:(BOOL)data;

/*!
 @method initWithInteger:
 @abstract Initialize newly allocated variant data with an integer value.
 @param data Initial integer value.
 @return A new IDVariantData object.
 */
- (id)initWithInteger:(NSInteger)data;

/*!
 @method initWithString:
 @abstract Initialize newly allocated variant data with a string value.
 @param data Initial string.
 @return A new IDVariantData object.
 */
- (id)initWithString:(NSString *)data;

/*!
 @method initWithTextId:
 @abstract Initialize newly allocated variant data with a text id.
 @param data Initial text id.
 @return A new IDVariantData object.
 */
- (id)initWithTextId:(NSInteger)data;

/*!
 @method initWithPreInstTextId:
 @abstract Initialize newly allocated variant data with an id of a preinstalled text.
 @param data Initial text id.
 @return A new IDVariantData object.
 */
- (id)initWithPreInstTextId:(NSInteger)data;

/*!
 @method initWithImageId:
 @abstract Initialize newly allocated variant data with an image id.
 @param data Initial image id.
 @return A new IDVariantData object.
 */
- (id)initWithImageId:(NSInteger)data;

/*!
 @method initWithPreInstImageId:
 @abstract Initialize newly allocated variant data with an id of a preinstalled image.
 @param data Initial image id.
 @return A new IDVariantData object.
 */
- (id)initWithPreInstImageId:(NSInteger)data;

/*!
 @method initWithImageData:
 @abstract Initialize newly allocated variant data with image data.
 @param data Initial image data.
 @return A new IDVariantData object.
 */
- (id)initWithImageData:(NSData *)data;

/*!
 @method initWithArray:
 @abstract Initialize newly allocated variant data with an array.
 @param data Initial array.
 @return A new IDVariantData object.
 */
- (id)initWithArray:(NSArray *) data;

/*!
 @method initWithDictionary:
 @abstract Initialize newly allocated variant data with a dictionary.
 @param data Initial dictionary.
 @return A new IDVariantData object.
 */
- (id)initWithDictionary:(NSDictionary *) data;

/*!
 @method booleanValue
 @abstract Returns the boolean value.
 @discussion If the variant data has not been initialized with a BOOL value an IDVariantMismatchException is raised.
 @return The boolean value.
 */
- (BOOL)booleanValue;

/*!
 @method integerValue
 @abstract Returns the integer value.
 @discussion If the variant data has not been initialized with an integer value an IDVariantMismatchException is raised.
 @return The integer value.
 */
- (NSInteger)integerValue;

/*!
 @method string
 @abstract Returns the string value.
 @discussion If the variant data has not been initialized with a string an IDVariantMismatchException is raised.
 @return The string value.
 */
- (NSString *)string;

/*!
 @method textId
 @abstract Returns the text id.
 @discussion If the variant data has not been initialized with a text id an IDVariantMismatchException is raised.
 @return The text id.
 */
- (NSInteger)textId;

/*!
 @method preinstalledTextId
 @abstract Returns the preinstalled text id.
 @discussion If the variant data has not been initialized with a preinstalled text id an IDVariantMismatchException is raised.
 @return The preinstalled text id.
 */
- (NSInteger)preinstalledTextId;

/*!
 @method imageId
 @abstract Returns the image id.
 @discussion If the variant data has not been initialized with an image id an IDVariantMismatchException is raised.
 @return The image id.
 */
- (NSInteger)imageId;

/*!
 @method preinstalledImageId
 @abstract Returns the preinstalled image id.
 @discussion If the variant data has not been initialized with a preinstalled image id an IDVariantMismatchException is raised.
 @return The preinstalled image id.
 */
- (NSInteger)preinstalledImageId;

/*!
 @method imageData
 @abstract Returns the image data.
 @discussion If the variant data has not been initialized with image data an IDVariantMismatchException is raised.
 @return The image data.
 */
- (NSData *)imageData;

/*!
 @method array
 @abstract Returns the array.
 @discussion If the variant data has not been initialized with an array an IDVariantMismatchException is raised.
 @return The array.
 */
- (NSArray *)array;

/*!
 @method dictionary
 @abstract Returns the dictionary.
 @discussion If the variant data has not been initialized with a dictionary an IDVariantMismatchException is raised.
 @return The dictionary.
 */
- (NSDictionary *)dictionary;

/*!
 @method isTypeOf:
 @abstract Allows to check the type of this object.
 @discussion The type of a variant data object depends on which initializer was used to create the object.
 @param type A variant type.
 @return YES if the data stored in the receiver are of the given type, otherwise NO.
 */
- (BOOL)isTypeOf:(IDVariantType)type;

/*!
 @method isEqualToVariantData:
 @abstract Compares the receiving variant data to another variant data
 @param otherVariantData A variant data
 @return YES if the contents of otherVariantData are equal to the contents of the receiver, otherwise NO.
 */
- (BOOL)isEqualToVariantData:(IDVariantData *)otherVariantData;

/*!
 @property type
 @abstract Represents the data type this object has been created for.
 @discussion The data type depends on which initializer has been used to create the variant data instance.
 */
@property (readonly) IDVariantType type;

@end
