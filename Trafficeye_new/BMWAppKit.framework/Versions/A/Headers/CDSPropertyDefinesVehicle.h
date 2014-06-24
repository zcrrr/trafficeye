/*  
 *  CDSPropertyDefinesVehicle.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @constant CDSVehicleLanguage
 @abstract This field returns information about the current language setting in the vehicle.
 @discussion (vehicle.language) Stored in response key "language" as a enum of type eCDSVehicleLanguage.
 */
extern NSString * const CDSVehicleLanguage;
extern NSString * const CDSNavigationGPSPosition;

/*!
 @enum eCDSVehicleLanguage
 @abstract The language setting in the vehicle.
 @constant CDSVehicleLanguage_NOLANGUAGE
 @constant CDSVehicleLanguage_DEUTSCH
 @constant CDSVehicleLanguage_ENGLISHUK
 @constant CDSVehicleLanguage_ENGLISHUS
 @constant CDSVehicleLanguage_SPANISH
 @constant CDSVehicleLanguage_ITALIAN
 @constant CDSVehicleLanguage_FRENCH
 @constant CDSVehicleLanguage_FLEMISH
 @constant CDSVehicleLanguage_DUTCH
 @constant CDSVehicleLanguage_ARABIC
 @constant CDSVehicleLanguage_CHINESETRADITIONAL
 @constant CDSVehicleLanguage_CHINESESIMPLE
 @constant CDSVehicleLanguage_KOREAN
 @constant CDSVehicleLanguage_JAPANESE
 @constant CDSVehicleLanguage_RUSSIAN
 @constant CDSVehicleLanguage_FRENCHCANADIAN
 @constant CDSVehicleLanguage_SPANISHMEXICO
 @constant CDSVehicleLanguage_PORTUGESE
 @constant CDSVehicleLanguage_POLISH
 @constant CDSVehicleLanguage_GREEK
 @constant CDSVehicleLanguage_TURKISH
 @constant CDSVehicleLanguage_HUNGARIAN
 @constant CDSVehicleLanguage_ROMANIAN
 @constant CDSVehicleLanguage_SWEDISH
 @constant CDSVehicleLanguage_INVALID
 */
typedef enum eCDSVehicleLanguage
{
    CDSVehicleLanguage_NOLANGUAGE = 0,
    CDSVehicleLanguage_DEUTSCH = 1,
    CDSVehicleLanguage_ENGLISHUK = 2,
    CDSVehicleLanguage_ENGLISHUS = 3,
    CDSVehicleLanguage_SPANISH = 4,
    CDSVehicleLanguage_ITALIAN = 5,
    CDSVehicleLanguage_FRENCH = 6,
    CDSVehicleLanguage_FLEMISH = 7,
    CDSVehicleLanguage_DUTCH = 8,
    CDSVehicleLanguage_ARABIC = 9,
    CDSVehicleLanguage_CHINESETRADITIONAL = 10,
    CDSVehicleLanguage_CHINESESIMPLE = 11,
    CDSVehicleLanguage_KOREAN = 12,
    CDSVehicleLanguage_JAPANESE = 13,
    CDSVehicleLanguage_RUSSIAN = 14,
    CDSVehicleLanguage_FRENCHCANADIAN = 15,
    CDSVehicleLanguage_SPANISHMEXICO = 16,
    CDSVehicleLanguage_PORTUGESE = 17,
    CDSVehicleLanguage_POLISH = 18,
    CDSVehicleLanguage_GREEK = 19,
    CDSVehicleLanguage_TURKISH = 20,
    CDSVehicleLanguage_HUNGARIAN = 21,
    CDSVehicleLanguage_ROMANIAN = 22,
    CDSVehicleLanguage_SWEDISH = 23,
    CDSVehicleLanguage_SLOVAK = 27,
    CDSVehicleLanguage_CZECH = 28,
    CDSVehicleLanguage_SLOVENIAN = 29,
    CDSVehicleLanguage_DANISH = 30,
    CDSVehicleLanguage_NORWEGIAN = 31,
    CDSVehicleLanguage_FINNISH = 32,
    CDSVehicleLanguage_INVALID = 255
} CDSVehicleLanguageType;

/*!
 @constant CDSVehicleTime
 @abstract This returns information regarding the vehicle's customer clock in terms of day, hour, minute, seconds, etc.
 @discussion (vehicle.time) Stored in response key "time" as a dictionary with keys "hour", "minute", "second", "date", "month", "weekday", and "year".
 "hour", "minute", "second", "date", "month", and "year" are numbers. weekday is an enumeration of type eCDSVehicleTime.
    NOTE: the weekday values will not be available in all vehicles please do not rely on the weekday value.
 */
extern NSString * const CDSVehicleTime;

/*!
 @enum eCDSVehicleTime
 @abstract The vehicle time weekdays.
 @constant CDSVehicleTimeWeekday_MONDAY
 @constant CDSVehicleTimeWeekday_TUESDAY
 @constant CDSVehicleTimeWeekday_WEDNESDAY
 @constant CDSVehicleTimeWeekday_THURSDAY
 @constant CDSVehicleTimeWeekday_FRIDAY
 @constant CDSVehicleTimeWeekday_SATURDAY
 @constant CDSVehicleTimeWeekday_SUNDAY
 @constant CDSVehicleTimeWeekday_INVALID
 */
enum eCDSVehicleTime
{
    CDSVehicleTimeWeekday_MONDAY = 0,
    CDSVehicleTimeWeekday_TUESDAY = 1,
    CDSVehicleTimeWeekday_WEDNESDAY = 2,
    CDSVehicleTimeWeekday_THURSDAY = 3,
    CDSVehicleTimeWeekday_FRIDAY = 4,
    CDSVehicleTimeWeekday_SATURDAY = 5,
    CDSVehicleTimeWeekday_SUNDAY = 6,
    CDSVehicleTimeWeekday_INVALID = 7
};

/*!
 @constant CDSVehicleType
 @abstract This returns information regarding the BMW or MINI vehicle type as the model E, F, RR or R code.
 @discussion (vehicle.type) Stored in response key "type" as an enumeration of type eCDSVehicleType.
 */
extern NSString * const CDSVehicleType;

/*!
 @enum eCDSVehicleType
 @abstract The vehicle type as model code.
 @constant CDSVehicleType_NOINFO
 @constant CDSVehicleType_E65
 @constant CDSVehicleType_E66
 @constant CDSVehicleType_E67
 @constant CDSVehicleType_E60
 @constant CDSVehicleType_E61
 @constant CDSVehicleType_E63
 @constant CDSVehicleType_E64
 @constant CDSVehicleType_E90
 @constant CDSVehicleType_RR01
 @constant CDSVehicleType_E81
 @constant CDSVehicleType_E82
 @constant CDSVehicleType_E87
 @constant CDSVehicleType_E91
 @constant CDSVehicleType_E92
 @constant CDSVehicleType_E93
 @constant CDSVehicleType_E70
 @constant CDSVehicleType_E71
 @constant CDSVehicleType_E88
 @constant CDSVehicleType_R55
 @constant CDSVehicleType_R56
 @constant CDSVehicleType_R57
 @constant CDSVehicleType_E89
 @constant CDSVehicleType_E72
 @constant CDSVehicleType_F01
 @constant CDSVehicleType_F02
 @constant CDSVehicleType_F03
 @constant CDSVehicleType_F07
 @constant CDSVehicleType_F10
 @constant CDSVehicleType_F11
 @constant CDSVehicleType_F12
 @constant CDSVehicleType_F13
 @constant CDSVehicleType_F04
 @constant CDSVehicleType_F31
 @constant CDSVehicleType_F32
 @constant CDSVehicleType_F33
 @constant CDSVehicleType_F20
 @constant CDSVehicleType_F30
 @constant CDSVehicleType_F22
 @constant CDSVehicleType_F23
 @constant CDSVehicleType_E84
 @constant CDSVehicleType_F25
 @constant CDSVehicleType_R60
 @constant CDSVehicleType_RR4
 @constant CDSVehicleType_INVALID
 */
enum eCDSVehicleType
{
    CDSVehicleType_NOINFO = 0,
    CDSVehicleType_E65 = 1,
    CDSVehicleType_E66 = 2,
    CDSVehicleType_E67 = 3,
    CDSVehicleType_E60 = 4,
    CDSVehicleType_E61 = 5,
    CDSVehicleType_E63 = 6,
    CDSVehicleType_E64 = 7,
    CDSVehicleType_E90 = 8,
    CDSVehicleType_RR01 = 9,
    CDSVehicleType_E81 = 10,
    CDSVehicleType_E82 = 11,
    CDSVehicleType_E87 = 12,
    CDSVehicleType_E91 = 13,
    CDSVehicleType_E92 = 14,
    CDSVehicleType_E93 = 15,
    CDSVehicleType_E70 = 16,
    CDSVehicleType_E71 = 17,
    CDSVehicleType_E88 = 18,
    CDSVehicleType_R55 = 19,
    CDSVehicleType_R56 = 20,
    CDSVehicleType_R57 = 21,
    CDSVehicleType_E89 = 22,
    CDSVehicleType_E72 = 23,
    CDSVehicleType_F01 = 24,
    CDSVehicleType_F02 = 25,
    CDSVehicleType_F03 = 26,
    CDSVehicleType_F07 = 27,
    CDSVehicleType_F10 = 28,
    CDSVehicleType_F11 = 29,
    CDSVehicleType_F12 = 30,
    CDSVehicleType_F13 = 31,
    CDSVehicleType_F04 = 32,
    CDSVehicleType_F31 = 33,
    CDSVehicleType_F32 = 34,
    CDSVehicleType_F33 = 35,
    CDSVehicleType_F20 = 36,
    CDSVehicleType_F30 = 37,
    CDSVehicleType_F22 = 38,
    CDSVehicleType_F23 = 39,
    CDSVehicleType_E84 = 40,
    CDSVehicleType_F25 = 41,
    CDSVehicleType_R60 = 42,
    CDSVehicleType_RR4 = 43,
    CDSVehicleType_F21 = 44,
    CDSVehicleType_F15 = 45,
    CDSVehicleType_F16 = 46,
    CDSVehicleType_F18 = 47,
    CDSVehicleType_F55 = 48,
    CDSVehicleType_F56 = 49,
    CDSVehicleType_F06 = 50,
    CDSVehicleType_F34 = 51,
    CDSVehicleType_F35 = 52,
    CDSVehicleType_RR5 = 53,
    CDSVehicleType_F45 = 54,
    CDSVehicleType_I01 = 55,
    CDSVehicleType_I12 = 56,
    CDSVehicleType_F80 = 57,
    CDSVehicleType_F82 = 58,
    CDSVehicleType_F83 = 59,
    CDSVehicleType_F85 = 60,
    CDSVehicleType_F86 = 61,
    CDSVehicleType_R61 = 62,
    CDSVehicleType_INVALID = 255
};

/*!
 @constant CDSVehicleUnits
 @abstract This field returns information about the current unit settings in the vehicle for airPressure, fuel consumption, date display units, distance, fuel volume, temperature and time.
 @discussion (vehicle.units) Stored in response key "units" as a dictionary with keys "airPressure" "consumption", "date", "distance", "fuel", "time", "temperature". All are enumerations.
 Possible values for airPressure are stored in enumeration of type eCDSVehicleUnitsAirPressure.
 Possible values for consumption are stored in enumeration of type eCDSVehicleUnitsConsumption.
 Possible values for date are stored in enumeration of type eCDSVehicleUnitsDate.
 Possible values for distance are stored in enumeration of type eCDSVehicleUnitsDistance.
 Possible values for fuel are stored in enumeration of type eCDSVehicleUnitsFuel.
 Possible values for temperature are stored in enumeration of type eCDSVehicleUnitsTemperature.
 Possible values for time are stored in enumeration of type eCDSVehicleUnitsTime.
 */
extern NSString * const CDSVehicleUnits;

/*!
 @enum eCDSVehicleUnitsAirPressure
 @abstract Possible values for airPressure type.
 @constant CDSVehicleUnitsAirPressure_DEFAULT
 @constant CDSVehicleUnitsAirPressure_BAR
 @constant CDSVehicleUnitsAirPressure_KPA
 @constant CDSVehicleUnitsAirPressure_PSI
 @constant CDSVehicleUnitsAirPressure_INVALID
 */
enum eCDSVehicleUnitsAirPressure
{
    CDSVehicleUnitsAirPressure_DEFAULT = 0,
    CDSVehicleUnitsAirPressure_BAR = 1,
    CDSVehicleUnitsAirPressure_KPA = 2,
    CDSVehicleUnitsAirPressure_PSI = 3,
    CDSVehicleUnitsAirPressure_INVALID = 7
};

/*!
 @enum eCDSVehicleUnitsConsumption
 @abstract Possible values for consumption type.
 @constant CDSVehicleUnitsConsumption_DEFAULT
 @constant CDSVehicleUnitsConsumption_L100KM
 @constant CDSVehicleUnitsConsumption_MPGUK
 @constant CDSVehicleUnitsConsumption_MPGUS
 @constant CDSVehicleUnitsConsumption_KML
 @constant CDSVehicleUnitsConsumption_INVALID
 */
enum eCDSVehicleUnitsConsumption
{
    CDSVehicleUnitsConsumption_DEFAULT = 0,
    CDSVehicleUnitsConsumption_L100KM = 1,
    CDSVehicleUnitsConsumption_MPGUK = 2,
    CDSVehicleUnitsConsumption_MPGUS = 3,
    CDSVehicleUnitsConsumption_KML = 4,
    CDSVehicleUnitsConsumption_INVALID = 7
};

/*!
 @enum eCDSVehicleUnitsDate
 @abstract Possible values for date.
 @constant CDSVehicleUnitsDate_DEFAULT
 @constant CDSVehicleUnitsDate_DMY
 @constant CDSVehicleUnitsDate_MDY
 @constant CDSVehicleUnitsDate_INVALID
 */
enum eCDSVehicleUnitsDate
{
    CDSVehicleUnitsDate_DEFAULT = 0,
    CDSVehicleUnitsDate_DMY = 1,
    CDSVehicleUnitsDate_MDY = 2,
    CDSVehicleUnitsDate_INVALID = 3
};

/*!
 @enum eCDSVehicleUnitsDistance
 @abstract Possible values for distance type.
 @constant CDSVehicleUnitsDistance_DEFAULT
 @constant CDSVehicleUnitsDistance_KM
 @constant CDSVehicleUnitsDistance_MI
 @constant CDSVehicleUnitsDistance_INVALID
 */
enum eCDSVehicleUnitsDistance
{
    CDSVehicleUnitsDistance_DEFAULT = 0,
    CDSVehicleUnitsDistance_KM = 1,
    CDSVehicleUnitsDistance_MI = 2,
    CDSVehicleUnitsDistance_INVALID = 3
};

/*!
 @enum eCDSVehicleUnitsFuel
 @abstract Possible values for fuel format.
 @constant CDSVehicleUnitsFuel_DEFAULT
 @constant CDSVehicleUnitsFuel_LITER
 @constant CDSVehicleUnitsFuel_GALONUK
 @constant CDSVehicleUnitsFuel_GALONUS
 @constant CDSVehicleUnitsFuel_INVALID

 */
enum eCDSVehicleUnitsFuel
{
    CDSVehicleUnitsFuel_DEFAULT = 0,
    CDSVehicleUnitsFuel_LITER = 1,
    CDSVehicleUnitsFuel_GALONUK = 2,
    CDSVehicleUnitsFuel_GALONUS = 3,
    CDSVehicleUnitsFuel_INVALID = 7
};

/*!
 @enum eCDSVehicleUnitsTemperature
 @abstract Possible values for temperature format.
 @constant CDSVehicleUnitsTemperature_DEFAULT
 @constant CDSVehicleUnitsTemperature_C
 @constant CDSVehicleUnitsTemperature_F
 @constant CDSVehicleUnitsTemperature_INVALID
 */
enum eCDSVehicleUnitsTemperature
{
    CDSVehicleUnitsTemperature_DEFAULT = 0,
    CDSVehicleUnitsTemperature_C = 1,
    CDSVehicleUnitsTemperature_F = 2,
    CDSVehicleUnitsTemperature_INVALID = 3
};

/*!
 @enum eCDSVehicleUnitsTime
 @abstract Possible values for time format.
 @constant CDSVehicleUnitsTime_DEFAULT
 @constant CDSVehicleUnitsTime_12H
 @constant CDSVehicleUnitsTime_24H
 @constant CDSVehicleUnitsTime_INVALID
 */
enum eCDSVehicleUnitsTime
{
    CDSVehicleUnitsTime_DEFAULT = 0,
    CDSVehicleUnitsTime_12H = 1,
    CDSVehicleUnitsTime_24H = 2,
    CDSVehicleUnitsTime_INVALID = 3
};

/*!
 @constant CDSVehicleUnitSpeed
 @abstract This returns information regarding the units for the vehicle speed.  It does not affect the speedActual or speedDisplayed return value as these units are always set, but rather distinguishes the users preference for speed display units
 @discussion (vehicle.unitSpeed) Stored in response key "unitSpeed" as an enumeration of type eCDSVehicleUnitSpeed.
 */
extern NSString *const CDSVehicleUnitSpeed;

/*!
 @enum eCDSVehicleUnitSpeed
 @abstract The users preference for speed display units.
 @constant CDSVehicleUnitSpeed_KMH
 @constant CDSVehicleUnitSpeed_MPH
 @constant CDSVehicleUnitSpeed_INVALID
 */
enum eCDSVehicleUnitSpeed
{
    CDSVehicleUnitSpeed_KMH = 0,
    CDSVehicleUnitSpeed_MPH = 1,
    CDSVehicleUnitSpeed_INVALID = 2
};

