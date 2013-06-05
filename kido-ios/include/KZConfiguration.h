/**
 * Configuration service interface
 *
 * @author kidozen
 * @version 1.00, April 2013
 *
 */
#import "KZBaseService.h"

@interface KZConfiguration : KZBaseService

/**
 * Save the value of the configuration
 *
 * @param message A NSDictionary that represents the configuration
 * @param block The callback with the result of the service call
 */
-(void) save:(id)object completion:(void (^)(KZResponse *))block;

/**
 * Retrieves the configuration value
 *
 * @param block The callback with the result of the service call
 */
-(void) get:(void (^)(KZResponse *))block;
/**
 * Deletes the current configuration
 */
-(void) remove;
/**
 * Deletes the current configuration
 *
 * @param block The callback with the result of the service call
 */
-(void) remove:(void (^)(KZResponse *))block;
/**
 * Pulls all the configuration values
 *
 * @param block The callback with the result of the service call
 */
-(void) all:(void (^)(KZResponse *))block;
@end
