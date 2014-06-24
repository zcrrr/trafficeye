/*  
 *  IDImageData.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
   @class IDImageData
   @abstract This class represents image data displayable by the remote hmi.
   @discussion This is a support class for IDImage widget (@see IDImage). This class provides automatic image data verification.
 */
@interface IDImageData : NSObject

/*!
   @method emptyImageData
   @abstract Creates and returns empty IDImageData
   @discussion This empty image can be used to erase image data previously sent to the HMI.
 */
+ (id)emptyImageData;

/*!
   @method imageDataWithData:
   @abstract Create and return IDImageData from NSData.
   @param data the raw image data
   @return an instance of IDImageData or nil if initialization did fail
 */
+ (id)imageDataWithData:(NSData *)data;

/*!
   @method imageDataWithURL:
   @abstract Create and return IDImageData from NSData.
   @param imageURL an URL to image data
   @return an instance of IDImageData or nil if initialization dif fail
 */
+ (id)imageDataWithURL:(NSURL *)imageURL;

/*!
   @method initWithData:
   @abstract Create IDImageData from NSData.
   @discussion The hmi requires the format of the provided data to be JPEG or PNG. PNG is supported with or without alpha channel.This is the designated initializer. The data passed in is copied by the class.
   @param data the raw image data
   @return an instance of IDImageData or nil if initialization did fail
 */
- (id)initWithData:(NSData *)data;

/*!
   @method initWithURL:
   @abstract Convenience constructor to create id image with an URL. For details @see initWithData:
   @param imageURL an URL to image data
   @return an instance of IDImageData or nil if initialization dif fail
 */
- (id)initWithURL:(NSURL *)imageURL;

@property (nonatomic, readonly) CGSize imageSize; // not KVO compliant
@property (nonatomic, readonly) NSData *imageData; // not KVO compliant

@end
