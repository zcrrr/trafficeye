/*  
 *  IDModel.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

/*!
 @enum IDModelType
 @abstract Defines various possible model types.
 @discussion The type of a model depends on the model's definition in the HMI description XML file.
 @constant IDModelTypeUnknown The model type is unknown.
 @constant IDModelTypeData Represents a model which can hold image or text data.
 @constant IDModelTypeTextId Represents a model which can hold IDs of text ressources.
 @constant IDModelTypeImageId Represents a model which can hold IDs of image ressources.
 @constant IDModelTypeList Represents a model which can hold table data.
 @constant IDModelTypeInteger Represents a model which can hold integer values. These kind of models are used to represent
    target models.
 @constant IDModelTypeBoolModel Represents a model which can hold boolean values. These kind of models are used to represent
    the values of checkboxes.
 @constant IDModelTypeGauge Represents a model which can hold the values of gauges.
 */
typedef enum {
    IDModelTypeUnknown = 0,
    IDModelTypeData,
    IDModelTypeTextId,
    IDModelTypeImageId,
    IDModelTypeList,
    IDModelTypeInteger,
    IDModelTypeBoolModel,
    IDModelTypeGauge
} IDModelType;

/*!
 @class IDModel
 @abstract This class is used to represent the different kinds of HMI models.
 @discussion Models are the basic RHMI concept for representing data which should be displayed in the HMI.
    Each RHMI application needs to define the models it requires in its HMI description. At runtime the application can
    write to these models. As every HMI component can be assigned to at least one model, an update to a model will also
    update the acomponent's visual representation in the HMI.
    The Widget API is a submodule of the BMWAppKit framework which offers a high level API to the visible HMI features.
    As such it tries to hide the complexity of updating models behind an object-oriented API.
 @updated 2012-04-03
 */
@interface IDModel : NSObject

/*!
 @method modelWithId:type:implicit:
 @abstract Creates and returns a model.
 @param identifier The model's ID from the HMI description.
 @param type The model type.
 @param implicit Specifies if the model was defined explicitly or was autocreated by the RHMI editor.
 @return A model.
 */
+ (id)modelWithId:(NSInteger)identifier type:(IDModelType)type implicit:(BOOL)implicit;

/*!
 @method initWithId:type:implicit:
 @abstract Initializes a newly allocated model.
 @param identifier The model's ID from the HMI description.
 @param type The model type.
 @param implicit Specifies if the model was defined explicitly or was autocreated by the RHMI editor.
 @return A model initialized with the given identifier and type.
 */
- (id)initWithId:(NSInteger)identifier type:(IDModelType)type implicit:(BOOL)implicit;

/*!
 @property identifier
 @abstract The model's ID as it can be found in the HMI description.
 */
@property (readonly) NSInteger identifier;

/*!
 @property type
 @abstract The model type.
 */
@property (readonly) IDModelType type;

/*!
 @property implicit
 @abstract Specifies if the model was defined explicitly or was autocreated by the RHMI editor.
 */
@property (readonly) BOOL implicit;

@end
