#import "KZBaseService.h"

typedef enum  {
    LogLevelVerbose,
    LogLevelInfo,
    LogLevelWarning,
    LogLevelError, 
    LogLevelCritical
} LogLevel;

/**
 * Log service interface
 *
 * @author kidozen
 * @version 1.00, April 2013
 */
@interface KZLogging : KZBaseService
/**
 * Writes a new entry in the application Log
 *
 * @param message The message (NSDictionary) you want to save
 * @param level The log level: Verbose, Information, Warning, Error, Critical
 * @param block The callback with the result of the service call
 */
-(void) write:(id)object withLevel:(LogLevel) level completion:(void (^)(KZResponse *))block;
/**
 * Retrieves all the Log entries
 *
 * @param block The callback with the result of the service call
 */
-(void) all:(void (^)(KZResponse *))block;
/**
 * Clears the log.
 * This method add a new entry to the Log with the information of the user that executes this action
 *
 * @param block The callback with the result of the service call
 */
-(void) clear:(void (^)(KZResponse *))block;
/**
 * Executes a query against the Log
 *
 * @param query An string with the same syntax used for a MongoDb query
 * @param options An string with the same syntax used for a MongoDb query options
 * @param block The callback with the result of the service call
 */
-(void) query:(NSString *)query withOptions:(NSString *)options andBlock:(void (^)(KZResponse *))block;
@end
