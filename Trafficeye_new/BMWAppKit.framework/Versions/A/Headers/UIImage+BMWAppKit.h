/*  
 *  UIImage+BMWAppKit.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// TODO: header documentation

@class IDImageData;

/*!
 @class UIImage
 @abstract <#This is a introductory explanation about the class.#>
 @discussion <#This is a more detailed description of the class.#>
 @updated 2012-05-07
 */
@interface UIImage (BMWAppKit)

/*!
 @method idJPEGImageDataWithCompressionFactor:
 @abstract Helper method to create an image data object from an UIImage. The image data will contain the JPEG represantation of the image.
 @discussion The JPEG will not support an alpha channel. An existing alpha channel in the source image will be replaced with a black background color.
 @param compressionFactor The compression to be aplied on the data. The valid range is [0.0..1.0]. 0.0 implies maximum compression, 1.0 implies minimum compression. Compression factors that are out of range will automatically imply the closest valid factor.
 @return an instance of IDImageData or nil if conversion went wrong
 */
- (IDImageData *)idJPEGImageDataWithCompressionFactor:(float)compressionFactor;

/*!
 @method idPNGImageData
 @abstract Helper method to create an image data object from an UIImage. The image data will contain the PNG represantation of the image.
 @discussion This method will create an PNG representation that always includes an alpha channel.
 @return an instance of IDImageData or nil if conversion went wrong
 */
- (IDImageData *)idPNGImageData;

/*!
 @method idResizedImage:interpolationQuality:
 @abstract Returns a rescaled copy of the image, taking into account its orientation
 @discussion The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
 @param newSize The size to which the image should get resized
 @param quality The quality to use
 @result A rescaled copy of the image
 @see CGInterpolationQuality
 */
- (UIImage *)idResizedImage:(CGSize)newSize
       interpolationQuality:(CGInterpolationQuality)quality;

@end
