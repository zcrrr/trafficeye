/*  
 *  IDLogger.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


#import <Foundation/Foundation.h>

/*!
 @enum IDLogLevel
 @abstract Constants to describe the levels of a log message.
 @discussion The log level classifies the log message giving it a priority. Filtering log messages can be done based on these constants.
 @constant IDLogLevelTrace
    Log messages with this level are of lowest priority. Loggers this value set to the minLogLevel are most verbose.
 @constant IDLogLevelDebug
 @constant IDLogLevelInfo
 @constant IDLogLevelWarn
 @constant IDLogLevelError
    Log messages with this level are of highest priority.
 @constant IDLogLevelAll
    This is a synonym for IDLogLevelTrace.
 @constant IDLogLevelNone
    It does not make sense to give a message the log level of IDLogLevelNone since this message would never be rendered anywhere.
 */
typedef enum IDLogLevel
{
    IDLogLevelNone = 0,
    IDLogLevelError,
    IDLogLevelWarn,
    IDLogLevelInfo,
    IDLogLevelDebug,
    IDLogLevelTrace,
    IDLogLevelAll
} IDLogLevel;

#pragma mark -

/*!
 @class IDLoggerEvent
 @abstract A container class for representing logger events.
 @discussion Instances of this class represent log messages with tags that can be consumed by @link IDLogAppender @/link implementations.
 @updated 2012-05-16
 */
@interface IDLoggerEvent : NSObject

/*!
 @property message
 @abstract A string containing the log message.
 */
@property (nonatomic, copy) NSString *message;

/*!
 @property tag
 @abstract A string tagging the log message to classify it into categories.
 */
@property (nonatomic, copy) NSString *tag;

/*!
 @property level
 @abstract The log level of the log message.
 */
@property (nonatomic, assign) IDLogLevel level;

/*!
 @property timeStamp
 @abstract The time stamp of the log message.
 */
@property (nonatomic, strong) NSDate *timeStamp;

@end

#pragma mark -
/*!
 @protocol IDLogAppender
 @abstract Implementations of this protocol provide a custom strategy to render log messages to any desired sink.
 */
@protocol IDLogAppender <NSObject>
@required

/*!
 @method appendLoggerEvent:
 @abstract Implement this method to define the output strategy for the logging events from the framework.
 @param event The logger event to append
 */
- (void)appendLoggerEvent:(IDLoggerEvent *)event;

@end

#pragma mark -

/*!
 @class IDConsoleLogAppender
 @abstract A default implementation class for the IDLogAppender protocol which logs messages to the console.
 @discussion Use an instance of this class in your application if you just want to output the framework logging messages to the console. It uses NSLog() to print messages onto the console.
 */
@interface IDConsoleLogAppender : NSObject <IDLogAppender>

/*!
 @method maximumLogLevel
 @abstract The maximum log level of a console log appender instance. Only messages up to this log level will get sent to the console.
 @discussion If this value exceeds the maximum log level of the default IDLogger instance it will become overruled by that one. Default value is IDLogLevelAll.
 */
@property (assign) IDLogLevel maximumLogLevel;

@end

#pragma mark -

/*!
 @class IDLogger
 @discussion You can send log messages to an instances of IDLogger containing information about certain events at runtime. This class does not output any log message to any sink. Instead it forwards them to its registered log appenders. The log appenders are responsible to provide a strategy on how to render these messages.
 */
@interface IDLogger : NSObject

/*!
 @method defaultLogger
 @abstract The default logger object.
 @discussion The BMWAppKit framework uses this shared instance to send its logging statements to. You should add a log appenders to this shared instance if you want to receive and render the logging messages emmited by the framework.
 */
+ (IDLogger *)defaultLogger;

/*!
 @method addAppender:
 @abstract Adds a log appender to the logger.
 @discussion If as by default no log appender is registered to the logger, no logging messages will be output anywhere.
 */
- (void)addAppender:(id<IDLogAppender>)appender;

/*!
 @method removeAppender:
 @abstract Removes a log appender from the logger.
 */
- (void)removeAppender:(id<IDLogAppender>)appender;

/*!
 @method logMessage:tag:level:
 @abstract Tell the logger to log a message.
 @discussion This method will construct an instance of IDLoggerEvent from the given information and dispatch it to all log appenders registered at the logger object.
 */
- (void)logMessage:(NSString *)message tag:(NSString *)tag level:(IDLogLevel)level;

/*!
 @property maximumLogLevel
 @abstract The maximum level of logging messages to be sent to the log appenders.
 @discussion You can temporary switch off logging if you set this value to IDLogLevelNone. Default value is IDLogLevelAll.
 */
@property (assign) IDLogLevel maximumLogLevel;

@end
