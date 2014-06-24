/*  
 *  IDStatusBar.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDFlushProtocol.h"

// TODO: header documentation

@class IDModel;

/*!
 @class IDStatusBar
 @abstract Status Bar text to be displayed.
 @discussion This class allows setting a string with status bar information to be displayed in the status bar, the area on top of the display where the current time is shown. The text will only be shown in the status bar on views belonging to the same menu (e.g. Radio or ConnectedDrive) as the application. The menu (ApplicationType) an application belongs to is set in the Remote HMI Editor (e.g. type "OnlineServices" => "ConnectedDrive" menu).
 @updated 2012-04-26
 */
@interface IDStatusBar : NSObject <IDFlushProtocol>

/*!
 @method initWithTextModel:updateEvent:
 @abstract The designated initializer.
 @discussion <#This is a more detailed description of the method.#>
 @param textModel <#param documentation#>
 @param updateEvent <#param documentation#>
 @return <#return value documentation#>
 */
- (id)initWithTextModel:(IDModel *)textModel
            updateEvent:(NSInteger)updateEvent;

/*!
 @method initWithTextModelId:updateEvent:
 @abstract Legacy initializer for compatibility reasons.
 @discussion <#This is a more detailed description of the method.#>
 @param textModelId <#param documentation#>
 @param updateEvent <#param documentation#>
 @return <#return value documentation#>
 */
-(id)initWithTextModelId:(NSInteger)textModelId
             updateEvent:(NSInteger)updateEvent __attribute__((deprecated));

/*!
 @property text
 @abstract The text to be displayed in the status bar.
 @discussion See the description of IDStatusBar (@see IDStatusBar) for a detailed explanation of the status bar behavior.
 */
@property (nonatomic, retain) NSString *text;

/*!
 @property textId
 @abstract ID of the text to be displayed in the status bar.
 @discussion (not KVO compliant)
 */
@property (nonatomic, assign) NSInteger textId;

@end
