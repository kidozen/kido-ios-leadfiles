#import "KZBaseService.h"
/**
 * SMS  service interface
 *
 * @author kidozen
 * @version 1.00, April 2013
 */
@interface KZSMSSender : KZBaseService
/**
 * Sends the sms message
 *
 * @param message The message to send
 * @param callback The callback with the result of the service call
 */
-(void) send:(NSString *)message completion:(void (^)(KZResponse *))block;
/**
 * Get the status of one message: Sent or queued
 *
 * @param messageId The unique identifier of the sent message
 * @param callback The callback with the result of the service call
 */
-(void) getStatus:(NSString *)messageId completion:(void (^)(KZResponse *))block;
@end
