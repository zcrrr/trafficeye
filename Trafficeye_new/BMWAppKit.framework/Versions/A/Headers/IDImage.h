/*  
 *  IDImage.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDWidget.h"
#import "IDImageData.h"

// TODO: header documentation

/*!
 @class IDImage
 @abstract A representation of RHMI image components.
 @discussion This class can be used to interact with image components in the HMI when conneted to a vehicle.
 @updated 2012-10-31
 */
@interface IDImage : IDWidget

/*!
    @method setImageData:
    @abstract Update the image model of the image widget with the image data.
    @discussion The image data format could either be JPEG oder PNG. For PNG data alpha is supported.
    @param imageData the image data (@see IDImageData). Setting imageData to nil is equivalent to setting it to [IDImageData emptyImageData].
    @param clearWhileSending This flag can be used to invalidate the image data (i.e. remove the image from the HMI)
            while the new image data is uploaded to the HMI.
 */
- (void)setImageData:(IDImageData *)imageData clearWhileSending:(BOOL)clearWhileSending;

/*!
    @property imageData
    @abstract Can be used to set new image data to be displayed by the corresponding component in the HMI
    @discussion
        This property should only be used for setting new image data.
        The value stored in this property do not necessarily
        have to reflect the actual data of the displayed image. In some cases
        (e.g. after a reconnect to the HMI) the value of this property might not
        be up to date.
        Furthermore assigning new image data will only succeed if the corresponding
        RHMI component has a 'model img' assigned to it in the HMI description. If the
        image component is assigned a 'id model img' (i.e. a image ressoruce) in the HMI
        description then assigning image data to this property will not have any effect in the HMI.
 */
@property (nonatomic, retain) IDImageData *imageData;

/*!
    @property imageId
    @abstract Can be used to set the ID of the image resource displayed in the HMI
    @discussion
        This property should only be used for setting new ressource IDs.
        The value stored in this property do not necessarily
        have to reflect the actual value of the displayed image. In some cases
        (e.g. after a reconnect to the HMI) the value of this property might not
        be up to date.
        Furthermore setting a new image ressource will only succeed if the corresponding
        RHMI component has a 'id model img' or a image ressource assigned to it. If the
        image component is assigned a 'model img' (i.e. a image data model) in the HMI
        description then assigning an ID to this property will not have any effect in the HMI.
 */
@property (nonatomic, assign) NSInteger imageId;

/*!
    @property position
    @abstract Can be used to set the position of the image component in the HMI
    @discussion
        This property should only be used for setting new values for the
        widget's position. The value stored in this property do not necessarily
        have to reflect the actual value of the displayed image. In some cases
        (e.g. after a reconnect to the HMI) the value of this property might not
        be up to date.
 */
@property (nonatomic, assign) CGPoint position;

/*!
    @property size
    @abstract Can be used to set the size of the image component in the HMI
    @discussion
        This property should only be used for setting new values for the
        widget's size. The values stored in this property do not necessarily
        have to reflect the actual values of the displayed image. In some cases
        (e.g. after a reconnect to the HMI) the value of this property might not
        be up to date.
 */
@property (nonatomic, assign) CGSize size;

@end
