/*  
 *  IDVersionInfo.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

// TODO: header documentation

/*!
 @class IDVersionInfo
 @abstract IDVersionInfo represents the version information used throughout the iDrive framework.
 @update 2012-10-07
 */
@interface IDVersionInfo : NSObject
{
@private
    NSUInteger _major;
    NSUInteger _minor;
    NSUInteger _revision;
}

/*!
 @method versionInfoWithString:
 @abstract Returns a version info for the string.
 @discussion <#This is a more detailed description of the method.#>
 @param versionString The version information (minor, major, revision) in the string should be separated by ".".
 @return Version info object for string.
 */
+ (IDVersionInfo*)versionInfoWithString:(NSString*)versionString;

/*!
 @method versionInfoWithMajor:minor:revision:
 @abstract <#This is a introductory explanation about the method.#>
 @discussion <#This is a more detailed description of the method.#>
 @param major <#param documentation#>
 @param minor <#param documentation#>
 @param revision <#param documentation#>
 @return <#return value documentation#>
 */
+ (IDVersionInfo*)versionInfoWithMajor:(NSUInteger)major minor:(NSUInteger)minor revision:(NSUInteger)revision;

/*!
 @method initWithMajor:minor:revision:
 @abstract <#This is a introductory explanation about the method.#>
 @discussion <#This is a more detailed description of the method.#>
 @param major <#param documentation#>
 @param minor <#param documentation#>
 @param revision <#param documentation#>
 @return <#return value documentation#>
 */
- (id)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor revision:(NSUInteger)revision;

/*!
 @method stringValue
 @abstract Returns a string representing the version in the form "<major>.<minor>.<revision>".
 @return String representing the version in the form "<major>.<minor>.<revision>".
 */
- (NSString*)stringValue;

/*!
 @method isEqualToVersion:
 @abstract Returns true when this version is equal to the other version.
 @discussion <#This is a more detailed description of the method.#>
 @param otherVersion <#param documentation#>
 @return <#return value documentation#>
 */
-(BOOL) isEqualToVersion:(IDVersionInfo*)otherVersion;

/*!
 @method compare:
 @abstract Returns a NSComparisonResult object indicating whether the receiver comes before or after the argument.
 @discussion <#This is a more detailed description of the method.#>
 @param otherVersion <#param documentation#>
 @return NSComparisonResult object indicating whether the receiver comes before or after the argument.
 */
-(NSComparisonResult) compare:(IDVersionInfo*) otherVersion;

/*!
 @property major
 @abstract The major part of the version.
 */
@property (assign) NSUInteger major;

/*!
 @property minor
 @abstract The minor part of the version.
 */
@property (assign) NSUInteger minor;

/*!
 @property revision
 @abstract The revision part of the version.
 */
@property (assign) NSUInteger revision;

@end
