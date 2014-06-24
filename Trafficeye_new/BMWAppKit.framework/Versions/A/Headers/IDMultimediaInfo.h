/*  
 *  IDMultimediaInfo.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDFlushProtocol.h"

@class IDModel;

/*!
 @class IDMultimediaInfo
 @abstract This class allows setting strings with information on entertainment audio (e.g. Artist, Album or Title)
    curently played by the application to be displayed in the "Entertainment Details" view of the SplitScreen in the
    central information display.
 @discussion The multimedia info is only displayed in the split screen view in vehicles with a wide screen display.
    For the multimedia info to be visible the split screen view must be enabled by the driver, the content of the
    SplitScreen must be set to "Entertainment Details" and the IDApplication must be the active entertainment audio
    source.
    At the top of the entertainment details the name of the IDApplication playing entertainment audio is displayed,
    below two lines (firstLine and secondLine) of individual multimedia info can be displayed by the application.
    The position of the two lines is fixed and does not depend on the length of the string which is displayed.
    Strings taking up more space then available will be automtically cut.
 @updated 2012-04-26
 */
@interface IDMultimediaInfo : NSObject <IDFlushProtocol>

/*!
 @method initWithFirstLineModel:secondLineModel:updateEvent:
 @abstract The designated initializer.
 @param firstLineModel A text model ('model string' or 'id model string') representing the text displayed in the first
     line of the entertainment details.
 @param secondLineModel A text model ('model string' or 'id model string') representing the text displayed in the second
 line of the entertainment details.
 @param updateEvent ID of the multimedia info event.
 @return A fully initialized instance of IDMultimediaInfo.
 */
- (id)initWithFirstLineModel:(IDModel *)firstLineModel
             secondLineModel:(IDModel *)secondLineModel
                 updateEvent:(NSInteger)updateEvent;

/*!
 @method initWithFirstLineModelId:secondLineModelId:updateEvent:
 @abstract This method is deprecated. Don't use this for new projects. It's only existing because of compatibility reasons.
 @param firstLineModelId ID of a text model representing the text displayed in the first line of the entertainment details.
 @param secondLineModelId ID of a text model representing the text displayed in the second line of the entertainment details.
 @param updateEvent ID of the multimedia info event.
 @return A fully initialized instance of IDMultimediaInfo.
 */
- (id)initWithFirstLineModelId:(NSInteger)firstLineModelId
             secondLineModelId:(NSInteger)secondLineModelId
                   updateEvent:(NSInteger)updateEvent __attribute__((deprecated));

/*!
 @property firstLine
 @abstract The first line of the multimedia info displayed in "Entertainment Details" in the SplitScreen.
 @discussion please see the detailed the description of the multimedia info (@see IDMultimediaInfo).
    Assigning nil to this property clears the string from the first line.
    Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
    associated to the multimedia info event. This property is meant to write a text string to the model and will only work
    if the corresponding model was declared as data model (i.e. 'model string').
    (not KVO compliant)
 */
@property (nonatomic, retain) NSString *firstLine;

/*!
 @property firstLineTextId
 @abstract Sets the text ID for the first line in the splitscreen's "Entertainment Details".
 @discussion Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
    associated to the multimedia info event. This property is meant to write the ID of a text resource to the model and
    will only work if the corresponding model was declared as a text id model (i.e. 'id model string').
    (not KVO compliant)
 */
@property (nonatomic, assign) NSInteger firstLineTextId;

/*!
 @property secondLine
 @abstract The second line of the multimedia info displayed in "Entertainment Details" in the SplitScreen.
 @discussion please see the detailed the description of the multimedia info (@see IDMultimediaInfo).
 Assigning nil to this property clears the string from the second line.
 Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
 associated to the multimedia info event. This property is meant to write a text string to the model and will only work
 if the corresponding model was declared as data model (i.e. 'model string').
 (not KVO compliant)
 */
@property (nonatomic, retain) NSString *secondLine;

/*!
 @property secondLineTextId
 @abstract Sets the Text ID for the second line in the splitscreen's "Entertainment Details".o.
 @discussion Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
 associated to the multimedia info event. This property is meant to write the ID of a text resource to the model and
 will only work if the corresponding model was declared as a text id model (i.e. 'id model string').
 (not KVO compliant)
 */
@property (nonatomic, assign) NSInteger secondLineTextId;

@end
