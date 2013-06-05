#import "KZBaseService.h"
/**
 * Storage  service interface
 *
 * @author kidozen
 * @version 1.00, April 2013
 */

@interface KZStorage : KZBaseService

/**
 * Creates a new object in the storage
 *
 * @param message The object (NSDictionary) to be created
 * @param block The callback with the result of the service call
 */
-(void) create:(id)object completion:(void (^)(KZResponse *))block;
/**
 * Creates a new private object in the storage
 *
 * @param message The object (NSDictionary) to be created
 * @param block The callback with the result of the service call
 */
-(void) createPrivate:(id)object completion:(void (^)(KZResponse *))block;
/**
 * Gets an object
 *
 * @param objectId The unique identifier of the object
 * @param block The callback with the result of the service call
 */
-(void) getUsingId:(NSString *) objectId withBlock:(void (^)(KZResponse *))block;
/**
 * Updates an object
 *
 * @param objectId The unique identifier of the object
 * @param object The updated object (NSDictionary)
 * @param block The callback with the result of the service call
 */
-(void) updateUsingId:(NSString *) objectId object:(id)object completion:(void (^)(KZResponse *))block;
/**
 * Updates an object
 *
 * @param objectId The unique identifier of the object
 * @param object The updated object (NSDictionary)
 */
-(void) updateUsingId:(NSString *) objectId object:(id)object;
/**
 * Deletes a message from the storage
 *
 * @param objectId The unique identifier of the object
 */
-(void) deleteUsingId:(NSString *) objectId;
/**
 * Deletes a message from the storage
 *
 * @param objectId The unique identifier of the object
 * @param callback The callback with the result of the service call
 */
-(void) deleteUsingId:(NSString *) objectId withBlock:(void (^)(KZResponse *))block;
/**
 * Drops the entire storage
*/
-(void) drop;
/**
 * Drops the entire storage
 *
 * @param block The callback with the result of the service call
 */
-(void) drop:(void (^)(KZResponse *))block;
/**
 * Returns all the objects from the storage
 *
 * @param block The callback with the result of the service call
 */
-(void) all:(void (^)(KZResponse *))block;
/**
 * Executes a query against the Storage
 *
 * @param query An string with the same syntax used for a MongoDb query
 * @param block The callback with the result of the service call
 */
-(void) query:(NSString *) query withBlock:(void (^)(KZResponse *))block;
/**
 * Executes a query against the Storage
 *
 * @param query An string with the same syntax used for a MongoDb query
 * @param options An string with the same syntax used for a MongoDb query options
 * @param block The callback with the result of the service call
 */
-(void) query:(NSString *) query withOptions:(NSString *) options withBlock:(void (^)(KZResponse *))block;
/**
 * Executes a query against the Storage
 *
 * @param query An string with the same syntax used for a MongoDb query
 * @param options An string with the same syntax used for a MongoDb query options
 * @param fields The fields to retrieve
 * @param block The callback with the result of the service call
 */
-(void) query:(NSString *) query withOptions:(NSString *) options withFields:(NSString *) fields andBlock:(void (^)(KZResponse *))block;

@end
