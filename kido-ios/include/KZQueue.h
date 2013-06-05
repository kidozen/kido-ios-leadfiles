#import <Foundation/Foundation.h>
#import "KZBaseService.h"
/**
 * Queue service interface
 *
 * @author kidozen
 * @version 1.00, April 2013
 */
@interface KZQueue : KZBaseService
/**
 * Enqueues a message
 *
 * @param message The message (NSDictionary) to enqueue
 */
-(void) enqueue:(id)object;
/**
 * Enqueues a message
 *
 * @param message The message to enqueue
 * @param block The callback with the result of the service call
 */
-(void) enqueue:(id)object completion:(void (^)(KZResponse *))block;
/**
 * Dequeues a message
 *
 * @param block The callback with the result of the service call
 */
-(void) dequeue:(void (^)(KZResponse *))block;

@end
